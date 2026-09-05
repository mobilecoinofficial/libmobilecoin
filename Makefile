# The source of truth for VERSION and XCFRAMEWORK_SHA256. LibMobileCoin.podspec
# reads the same file, and Package.swift carries both as literals. Plain
# KEY=value lines, so make includes it directly.
include release.env
$(if $(VERSION),,$(error release.env has no VERSION))
$(if $(XCFRAMEWORK_SHA256),,$(error release.env has no XCFRAMEWORK_SHA256))

MOBILECOIN_DIR = Vendor/mobilecoin
LIBMOBILECOIN_LIB_DIR = libmobilecoin
LIBMOBILECOIN_ARTIFACTS_DIR = $(LIBMOBILECOIN_LIB_DIR)/out/ios
LIBMOBILECOIN_ARTIFACTS_HEADERS = $(LIBMOBILECOIN_LIB_DIR)/out/ios/include
# Not .build/artifacts: SwiftPM extracts binary targets there, and
# clean-artifacts would delete them.
ARTIFACTS_DIR = .build/mc-artifacts
RELEASE_ZIP = .build/LibMobileCoinLibrary.xcframework.zip
GITHUB_REPO = mobilecoinofficial/libmobilecoin
# The release tag and the release branch push both name this, so a fork
# configured as `origin` cannot take either of them.
RELEASE_REMOTE = git@github.com:$(GITHUB_REPO).git
TEST_VECTOR_DIR = Sources/TestVector
IOS_TARGETS = aarch64-apple-ios-sim aarch64-apple-ios x86_64-apple-ios x86_64-apple-darwin aarch64-apple-darwin

# -j does not preserve prerequisite order, and the release chain has steps that
# read what an earlier one wrote. make 3.81 has no target-scoped form, so this
# covers every target in the file.
.NOTPARALLEL:

LIBMOBILECOIN_PROFILE = mobile-release

define BINARY_copy
	$(foreach arch,$(IOS_TARGETS),cp $(LIBMOBILECOIN_ARTIFACTS_DIR)/$(1)/$(arch)/$(LIBMOBILECOIN_PROFILE)/libmobilecoin.a $(ARTIFACTS_DIR)/target/$(arch)/release/libmobilecoin.a;)
endef

.PHONY: default
default: setup build clean-artifacts copy generate

# Vendor/mobilecoin is a build-time input this target fetches. Every target
# that reads it depends on this so a fresh clone builds without extra steps.
.PHONY: vendor
vendor:
	tools/fetch-vendor.sh

.PHONY: setup
setup: vendor
	cd "$(LIBMOBILECOIN_LIB_DIR)" && $(MAKE) setup
	bundle install

# Unexport conditional environment variables so the build is more predictable
unexport SGX_MODE
unexport IAS_MODE
unexport CARGO_BUILD_FLAGS
unexport CARGO_TARGET_DIR
unexport CARGO_PROFILE

.PHONY: build
build: vendor
	cd "$(LIBMOBILECOIN_LIB_DIR)" && $(MAKE)


.PHONY: clean-artifacts
clean-artifacts:
	rm -r "$(ARTIFACTS_DIR)" 2>/dev/null || true
	mkdir -p "$(ARTIFACTS_DIR)"

	# Create arch specific folders for each lib
	$(foreach arch,$(IOS_TARGETS),mkdir -p $(ARTIFACTS_DIR)/target/$(arch)/release;) 

.PHONY: copy
copy: copy-libs generate-xcframework

.PHONY: copy-libs
copy-libs: check-headers
	$(call BINARY_copy,target)
	# cp -R merges into a directory that is already there, so the destination
	# is cleared to make this copy a replacement.
	rm -rf "$(ARTIFACTS_DIR)/include"
	cp -R "$(LIBMOBILECOIN_ARTIFACTS_HEADERS)" "$(ARTIFACTS_DIR)"

.PHONY: generate
generate: generate-test-vectors generate-protoc 

SWIFT_PROTOBUF_GENERATOR := 1.36.1
HTTP_SWIFT_GENERATOR := f19b2756c423ef066568459b5b45e3f3cbbce16f

.PHONY: generate-protoc
generate-protoc: vendor
	DOCKER_BUILDKIT=1 docker build . \
		--build-arg swift_protobuf_version=$(SWIFT_PROTOBUF_GENERATOR) \
		--build-arg http_swift_revision=$(HTTP_SWIFT_GENERATOR) \
		--output .

.PHONY: generate-test-vectors
generate-test-vectors: vendor
	rm -rf $(TEST_VECTOR_DIR)/vectors
	cp -R $(MOBILECOIN_DIR)/test-vectors/vectors $(TEST_VECTOR_DIR)
	cd $(TEST_VECTOR_DIR)/vectors && find . -type f -name '*.jsonl' -exec mv -fi '{}' ./ ';'
	cd $(TEST_VECTOR_DIR)/vectors && find .  -mindepth 1 -maxdepth 1 -type d -exec rm -rf '{}' ';'

.PHONY: generate-xcframework
generate-xcframework:
	rm -rf $(ARTIFACTS_DIR)/LibMobileCoinLibrary.xcframework || true
	rm libmobilecoin/out/ios/target/libmobilecoin_macos.a || true
	rm libmobilecoin/out/ios/target/libmobilecoin_iossimulator.a || true
	# The removal at the end of this recipe does not run when a step below
	# fails, so the directory starts empty rather than carrying leftovers.
	rm -rf .build/headers
	mkdir -p .build/headers
	cp $(ARTIFACTS_DIR)/include/* .build/headers
	cp modulemap/module.modulemap .build/headers
	mkdir -p libmobilecoin/out/ios/target
	lipo -create \
		$(ARTIFACTS_DIR)/target/x86_64-apple-darwin/release/libmobilecoin.a \
		$(ARTIFACTS_DIR)/target/aarch64-apple-darwin/release/libmobilecoin.a \
		-output $(LIBMOBILECOIN_ARTIFACTS_DIR)/target/libmobilecoin_macos.a
	lipo -create \
		$(ARTIFACTS_DIR)/target/x86_64-apple-ios/release/libmobilecoin.a \
		$(ARTIFACTS_DIR)/target/aarch64-apple-ios-sim/release/libmobilecoin.a \
		-output $(LIBMOBILECOIN_ARTIFACTS_DIR)/target/libmobilecoin_iossimulator.a
	rm -rf $(LIBMOBILECOIN_ARTIFACTS_DIR)/LibMobileCoinLibrary.xcframework
	xcodebuild -create-xcframework \
		-library $(LIBMOBILECOIN_ARTIFACTS_DIR)/target/libmobilecoin_macos.a \
		-headers .build/headers \
		-library $(LIBMOBILECOIN_ARTIFACTS_DIR)/target/libmobilecoin_iossimulator.a \
		-headers .build/headers \
		-library $(ARTIFACTS_DIR)/target/aarch64-apple-ios/release/libmobilecoin.a \
		-headers .build/headers \
		-output $(ARTIFACTS_DIR)/LibMobileCoinLibrary.xcframework
	rm -rf .build/headers


.PHONY: lint
lint: lint-podspec

.PHONY: lint-locally
lint-locally: lint-locally-podspec

# stamp must land in a commit before the tag is created, because Package.swift
# and the podspec read the checksum out of release.env at the tagged revision.
#
# publish-build sits after the checks, so a refusal costs no build, and before
# stamp, because stamp packages whatever the artifacts directory holds.
.PHONY: publish
publish: check-branch publish-preflight check-main-push-rights publish-build stamp commit-stamp push-stamp tag-release upload-release wait-for-asset publish-podspec

# `make -i` and `make -k` run a step after a check refused it, so every step
# that writes reads the flags itself. A word holding `=` is a command-line
# variable and a word opening `--` is a long option.
ASSERT_STRICT_MAKE = for W in $(MAKEFLAGS); do \
		case "$$W" in \
			--|--*|*=*) ;; \
			*i*|*k*) echo 'Error: this step does not run under `make -i` or `make -k`, which run a step after a check refused it.' >&2; exit 1 ;; \
		esac; \
	done

# The same three targets `default` runs, in the same order. They sit behind a
# guarded target because a release build writes, and `default` keeps them
# unguarded for local use.
.PHONY: publish-build
publish-build:
	@set -eu; \
	$(ASSERT_STRICT_MAKE); \
	$(MAKE) --no-print-directory build clean-artifacts copy

# The version, the `gh` login, the push permission and the ssh channel are read
# here, before the run packages anything. A refusal then costs nothing.
.PHONY: publish-preflight
publish-preflight:
	@set -eu; \
	ERRF="$$(mktemp)"; \
	trap 'rm -f "$$ERRF"' EXIT; \
	if git rev-parse -q --verify "refs/tags/v$(VERSION)" >/dev/null; then \
		echo 'Error: tag v$(VERSION) exists locally. If the remote carries it too, finish with `make upload-release wait-for-asset publish-podspec`. If not, delete it and re-run. Otherwise bump VERSION in release.env.' >&2; \
		exit 1; \
	fi; \
	TRUNK="$$(bundle exec pod trunk me 2>&1)" || { \
		printf '%s\n' "$$TRUNK" >&2; \
		echo 'Error: cannot read a CocoaPods trunk session. The trunk message above says why.' >&2; \
		echo 'A session that was just registered cannot push until its emailed link is followed.' >&2; \
		echo 'A missing gem needs `bundle install` in this directory.' >&2; \
		exit 1; }; \
	printf '%s\n' "$$TRUNK" | grep -qE '^[[:space:]]*-[[:space:]]*LibMobileCoin$$' || \
		{ echo 'Error: this trunk session does not own LibMobileCoin. `bundle exec pod trunk me` lists the pods that account owns.' >&2; exit 1; }; \
	POD="$$(curl --silent --output /dev/null --write-out '%{http_code}' \
		--connect-timeout 10 --max-time 30 \
		"https://trunk.cocoapods.org/api/v1/pods/LibMobileCoin/versions/$(VERSION)")" \
		|| POD="curl exited $$?"; \
	case "$$POD" in \
		404) ;; \
		200) echo 'Error: LibMobileCoin $(VERSION) is on the CocoaPods trunk already, so `publish-podspec` rejects it. Bump VERSION in release.env.' >&2; exit 1 ;; \
		*) echo "Error: the CocoaPods trunk answered $$POD for LibMobileCoin $(VERSION), so the pod version is unknown." >&2; exit 1 ;; \
	esac; \
	gh auth status >/dev/null 2>&1 || \
		{ echo 'Error: gh is not authenticated. Run `gh auth login`.' >&2; exit 1; }; \
	PUSHOK="$$(gh api repos/$(GITHUB_REPO) --jq .permissions.push 2>"$$ERRF")" || \
		{ cat "$$ERRF" >&2; \
		echo 'Error: gh cannot read $(GITHUB_REPO), so push rights are unknown.' >&2; exit 1; }; \
	case "$$PUSHOK" in \
		true) ;; \
		false) echo 'Error: this gh account cannot push to $(GITHUB_REPO).' >&2; exit 1 ;; \
		*) echo "Error: $(GITHUB_REPO) reports no push permission, so push rights are unknown. gh gave \"$$PUSHOK\"." >&2; exit 1 ;; \
	esac; \
	git ls-remote --exit-code $(RELEASE_REMOTE) HEAD >/dev/null 2>&1 || \
		{ echo 'Error: $(RELEASE_REMOTE) is unreachable over ssh.' >&2; exit 1; }; \
	S=0; \
	TAGLINE="$$(git ls-remote --exit-code --tags $(RELEASE_REMOTE) "refs/tags/v$(VERSION)" 2>/dev/null)" || S=$$?; \
	case "$$S" in \
		0) TAGSHA="$$(printf '%s\n' "$$TAGLINE" | cut -f1)"; \
			echo "Error: tag v$(VERSION) exists on the remote at $$TAGSHA. If an earlier run pushed it and then failed, finish with \`make upload-release wait-for-asset publish-podspec\`. Otherwise bump VERSION in release.env." >&2; \
			exit 1 ;; \
		2) ;; \
		*) echo "Error: cannot read tags from $(RELEASE_REMOTE), git ls-remote gave $$S." >&2; exit 1 ;; \
	esac; \
	echo "publish preflight passed"

# The wrong branch is cheap to catch here and expensive to find out later.
.PHONY: check-branch
check-branch:
	@set -eu; \
	[ "$$(git rev-parse --abbrev-ref HEAD)" = "main" ] || \
		{ echo 'Error: Must be on branch "main" to publish a release.' >&2; exit 1; }; \
	echo "on main"

# GitHub matches `main` against every ruleset and returns the ones that gate
# it, so this reads that answer and not the include entries. It accepts one
# answer, because a bypass of `always` is the one that covers a branch push.
.PHONY: check-main-push-rights
check-main-push-rights:
	@set -eu; \
	ERRF="$$(mktemp)"; \
	trap 'rm -f "$$ERRF"' EXIT; \
	IDS="$$(gh api --paginate "repos/$(GITHUB_REPO)/rules/branches/main" --jq '.[].ruleset_id' 2>"$$ERRF")" || \
		{ cat "$$ERRF" >&2; \
		echo 'Error: gh cannot read the rules on main, so the bypass the branch push needs is unknown.' >&2; exit 1; }; \
	for ID in $$(printf '%s\n' "$$IDS" | sort -u); do \
		BYPASS="$$(gh api "repos/$(GITHUB_REPO)/rulesets/$$ID" --jq .current_user_can_bypass 2>"$$ERRF")" || \
			{ cat "$$ERRF" >&2; \
			echo "Error: gh cannot read ruleset $$ID on $(GITHUB_REPO)." >&2; exit 1; }; \
		[ "$$BYPASS" = "always" ] || \
			{ echo "Error: ruleset $$ID gates main and this account bypasses it \"$$BYPASS\". The branch push fails." >&2; exit 1; }; \
	done; \
	echo "main push rights confirmed"

# A remote main that is not an ancestor makes the push fail, and failing
# here costs no tag. The one commit the push may carry is the stamp
# commit, which changes release.env and Package.swift and nothing else.
.PHONY: check-main-current
check-main-current: check-branch
	@set -eu; \
	git fetch --quiet $(RELEASE_REMOTE) main; \
	git merge-base --is-ancestor FETCH_HEAD HEAD || \
		{ echo 'Error: main has moved on the remote. Rebase before publishing.' >&2; exit 1; }; \
	AHEAD="$$(git rev-list --count FETCH_HEAD..HEAD)"; \
	[ "$$AHEAD" -le 1 ] || \
		{ echo "Error: HEAD is $$AHEAD commits ahead of remote main. Only the stamp commit belongs in this push, and \`git reset --soft FETCH_HEAD\` collapses them." >&2; exit 1; }; \
	EXTRA=""; \
	for F in $$(git diff --name-only FETCH_HEAD..HEAD); do \
		case "$$F" in \
			release.env|Package.swift) ;; \
			*) EXTRA="$$EXTRA $$F" ;; \
		esac; \
	done; \
	[ -z "$$EXTRA" ] || \
		{ echo "Error: the commit ahead of remote main also changes$$EXTRA. Only the stamp commit belongs in this push." >&2; exit 1; }; \
	echo "main is current"

# The tag names a commit main carries, so the stamp reaches main first. The
# preflight, the rights check and the ancestry test are prerequisites, and the
# recipe reads the make flags because those two options ignore a refusal.
.PHONY: push-stamp
push-stamp: publish-preflight check-main-push-rights check-main-current
	@set -eu; \
	$(ASSERT_STRICT_MAKE); \
	[ "$$(git rev-parse --abbrev-ref HEAD)" = "main" ] || \
		{ echo 'Error: HEAD is not main, so this push does not run.' >&2; exit 1; }; \
	git push $(RELEASE_REMOTE) HEAD:refs/heads/main

# --only takes the working-tree content of these two paths, so a change staged
# elsewhere stays out of the release commit.
.PHONY: commit-stamp
commit-stamp:
	@set -eu; \
	$(ASSERT_STRICT_MAKE); \
	git diff HEAD --quiet -- release.env Package.swift || \
		git commit --only release.env Package.swift \
			-m "chore: stamp release.env for v$(VERSION)"

# A hotfix is tagged off a branch main does not carry, so nothing is pushed to
# a branch. A tag puts no asset anywhere.
.PHONY: publish-hotfix
publish-hotfix: check-not-main publish-preflight publish-build stamp commit-stamp tag-hotfix upload-release wait-for-asset publish-podspec

# On main this target commits the stamp and pushes only the tag, so main would
# not record the release the tag names.
.PHONY: check-not-main
check-not-main:
	@set -eu; \
	[ "$$(git rev-parse --abbrev-ref HEAD)" != "main" ] || \
		{ echo 'Error: on branch "main". `make publish` releases from main.' >&2; exit 1; }; \
	echo "not on main"

.PHONY: push-generated
push-generated:
	git add Sources/HTTP
	git add Sources/Common
	if ! git diff-index --quiet HEAD; then \
		git commit -m '[skip ci] commit generated protos from build machine'; \
		git push origin HEAD; \
	fi

# Release

# Build the reproducible release zip and print its SwiftPM checksum. The
# checksum is what Package.swift and the podspec both pin.
.PHONY: package
package:
	tools/package-xcframework.sh \
		"$(ARTIFACTS_DIR)/LibMobileCoinLibrary.xcframework" "$(RELEASE_ZIP)"

# Write the checksum of the built zip back into release.env. Package.swift and
# the podspec both read it from there, so this is the whole stamp step.
.PHONY: stamp
stamp:
	@set -eu; \
	$(ASSERT_STRICT_MAKE); \
	CHECKSUM="$$(tools/package-xcframework.sh \
		"$(ARTIFACTS_DIR)/LibMobileCoinLibrary.xcframework" "$(RELEASE_ZIP)")"; \
	grep -q "^XCFRAMEWORK_SHA256=" release.env || \
		{ echo "error: release.env has no XCFRAMEWORK_SHA256= line to stamp" >&2; exit 1; }; \
	sed -i '' "s|^XCFRAMEWORK_SHA256=.*|XCFRAMEWORK_SHA256=$$CHECKSUM|" release.env; \
	grep -q "^XCFRAMEWORK_SHA256=$$CHECKSUM$$" release.env || \
		{ echo "error: stamping release.env did not take" >&2; exit 1; }; \
	echo "release.env stamped with $$CHECKSUM"
	@set -eu; \
	$(ASSERT_STRICT_MAKE); \
	$(MAKE) --no-print-directory stamp-manifest

# Push release.env into Package.swift's literals.
.PHONY: stamp-manifest
stamp-manifest:
	tools/stamp-package-swift.sh

# Fail if Package.swift and release.env disagree.
.PHONY: check-manifest
check-manifest:
	tools/stamp-package-swift.sh --check

# Fail if a public header does not compile. The release zip carries its own
# copy of these headers, which is why this copy needs its own check.
.PHONY: check-headers
check-headers:
	clang -fsyntax-only -x c -std=c11 -I$(LIBMOBILECOIN_LIB_DIR)/include $(LIBMOBILECOIN_LIB_DIR)/include/libmobilecoin.h

# Fail if the module map does not compile. It names its header relative to
# itself, so the headers and the map stage into one directory first.
.PHONY: check-module
check-module:
# A stale copy of a header deleted from include/ still satisfies the module,
# so the stage cannot carry anything over between runs.
	rm -rf .build/module-check
	mkdir -p .build/module-check/cache
	cp $(LIBMOBILECOIN_LIB_DIR)/include/* modulemap/module.modulemap .build/module-check
	clang -fsyntax-only -fmodules -fimplicit-module-maps -x c -std=c11 \
		-I.build/module-check -fmodules-cache-path=.build/module-check/cache \
		-Xclang -emit-module -Xclang -fmodule-name=LibMobileCoin \
		.build/module-check/module.modulemap

# Fail if the cmake patch and un-patch pair does not round trip the fixture
# set. It drives a fake install, so the cmake on PATH is left alone.
.PHONY: check-cmake-patch
check-cmake-patch:
	tools/check-cmake-patch.sh

# Attach the packaged zip to the release for the tag this run just pushed.
# Package.swift and the podspec both point a consumer at this exact URL, so
# until this runs neither of them resolves.
.PHONY: upload-release
upload-release:
	@set -eu; \
	$(ASSERT_STRICT_MAKE); \
	ERRF="$$(mktemp)"; \
	trap 'rm -f "$$ERRF"' EXIT; \
	[ -f "$(RELEASE_ZIP)" ] || \
		{ echo 'Error: $(RELEASE_ZIP) not found. Run `make stamp` first.'; exit 1; }; \
	EXPECTED="$$(sed -n 's|^XCFRAMEWORK_SHA256=||p' release.env)"; \
	ACTUAL="$$(shasum -a 256 "$(RELEASE_ZIP)" | cut -d' ' -f1)"; \
	[ "$$ACTUAL" = "$$EXPECTED" ] || \
		{ echo "Error: $(RELEASE_ZIP) hashes to $$ACTUAL and release.env names $$EXPECTED. SwiftPM rejects the mismatch, so run \`make stamp\` and re-run." >&2; exit 1; }; \
	if gh release view "v$(VERSION)" --repo $(GITHUB_REPO) >/dev/null 2>&1; then \
		HAVE="$$(gh release view "v$(VERSION)" --repo $(GITHUB_REPO) --json assets --jq '.assets[].name' 2>"$$ERRF")" || \
			{ cat "$$ERRF" >&2; \
			echo 'Error: gh cannot list the assets on v$(VERSION), so this run cannot tell an upload from a replacement.' >&2; exit 1; }; \
		if printf '%s\n' "$$HAVE" | grep -qxF "$(notdir $(RELEASE_ZIP))"; then \
			echo "Error: v$(VERSION) already carries $(notdir $(RELEASE_ZIP)). Every consumer pinned to v$(VERSION) verifies the checksum of that asset, so this run leaves it alone. Bump VERSION in release.env, or delete the asset by hand to replace it." >&2; \
			exit 1; \
		fi; \
	else \
		gh release create "v$(VERSION)" --repo $(GITHUB_REPO) --title "v$(VERSION)" --notes "" --verify-tag; \
	fi; \
	gh release upload "v$(VERSION)" "$(RELEASE_ZIP)" --repo $(GITHUB_REPO); \
	echo "uploaded $(RELEASE_ZIP) to v$(VERSION)"

# The upload call returns before GitHub serves the asset, so the URL answers 404
# for a short while after it. Thirty probes ten seconds apart allow the lag
# nearly five minutes to clear, and a probe that times out allows more.
.PHONY: wait-for-asset
wait-for-asset:
	@set -eu; \
	URL="https://github.com/$(GITHUB_REPO)/releases/download/v$(VERSION)/$(notdir $(RELEASE_ZIP))"; \
	CODE=""; \
	N=0; \
	while [ "$$N" -lt 30 ]; do \
		N=$$((N + 1)); \
		CODE="$$(curl --silent --location --head --output /dev/null \
			--connect-timeout 10 --max-time 15 \
			--write-out '%{http_code}' "$$URL")" || CODE="curl exited $$?"; \
		if [ "$$CODE" = "200" ]; then break; fi; \
		echo "probe $$N: $$CODE" >&2; \
		if [ "$$N" -lt 30 ]; then sleep 10; fi; \
	done; \
	[ "$$CODE" = "200" ] || \
		{ echo "Error: $$URL answers $$CODE after $$N probes, so the asset is not servable. \`make wait-for-asset publish-podspec\` resumes once it is." >&2; exit 1; }; \
	echo "$$URL is servable"

.PHONY: tag-release
tag-release: check-branch publish-preflight tag-hotfix
	@echo "tagged v$(VERSION) on main"

# The tag is the irreversible step, so the preflight is a prerequisite and the
# recipe reads the make flags. Both steps share one shell, so a `git tag` that
# fails cannot reach the tag push.
.PHONY: tag-hotfix
tag-hotfix: publish-preflight
	@set -eu; \
	$(ASSERT_STRICT_MAKE); \
	git tag "v$(VERSION)"; \
	git push $(RELEASE_REMOTE) "refs/tags/v$(VERSION)"

# LibMobileCoin pod

.PHONY: lint-locally-podspec
lint-locally-podspec:
	bundle exec pod lib lint LibMobileCoin.podspec --allow-warnings

.PHONY: lint-podspec
lint-podspec:
	bundle exec pod spec lint LibMobileCoin.podspec --allow-warnings

.PHONY: publish-podspec
publish-podspec:
	@set -eu; \
	$(ASSERT_STRICT_MAKE); \
	bundle exec pod trunk push LibMobileCoin.podspec --allow-warnings

.PHONY: clean
clean:
	$(MAKE) -C libmobilecoin clean
	@rm -r $(MOBILECOIN_DIR)/target 2>/dev/null || true

.PHONY: patch-cmake
patch-cmake:
	tools/patch-cmake.sh

.PHONY: unpatch-cmake
unpatch-cmake:
	tools/unpatch-cmake.sh

.PHONY: test-spm
test-spm:
	cd LibMobileCoinExample && swift package reset && swift test
