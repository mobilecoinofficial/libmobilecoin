# `make -i` and `make -k` run a step after a check refused it, so every step
# that writes reads the flags itself. A word holding `=` is a command-line
# variable and a word opening `--` is a long option.
#
# Under `-i` the refusal is ignored like any other error and the run still
# exits 0, so the guard stops the work rather than the run. It does that as
# the first clause of one backslash-joined shell, where its exit 1 kills
# every later clause.
#
# Both Makefiles read this file so the two copies of the guard cannot drift.
ASSERT_STRICT_MAKE = for W in $(MAKEFLAGS); do \
		case "$$W" in \
			--|--*|*=*) ;; \
			*i*|*k*) echo 'Error: this step does not run under `make -i` or `make -k`, which run a step after a check refused it.' >&2; exit 1 ;; \
		esac; \
	done
