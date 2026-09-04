// Copyright (c) 2018-2022 The MobileCoin Foundation

#ifndef ATTEST_H_
#define ATTEST_H_

#include "common.h"

/* ==================== Attestation ==================== */

#ifdef __cplusplus
extern "C" {
#endif

/* ==== Types ==== */

typedef struct _McTrustedMrEnclaveIdentity McTrustedMrEnclaveIdentity;

typedef struct _McTrustedMrSignerIdentity McTrustedMrSignerIdentity;

typedef struct _McTrustedIdentity McTrustedIdentity;

typedef struct _McAdvisories McAdvisories;

typedef struct _McAttestAke McAttestAke;

/* ==== McTrustedMrEnclaveIdentity and McTrustedMrSignerIdentity ==== */

McTrustedMrEnclaveIdentity* MC_NULLABLE mc_trusted_identity_mr_enclave_create(
  const McBuffer* MC_NONNULL mr_enclave,
  McAdvisories* MC_NONNULL config_advisories,
  McAdvisories* MC_NONNULL hardening_advisories
)
MC_ATTRIBUTE_NONNULL(1, 2, 3);

McTrustedMrSignerIdentity* MC_NULLABLE mc_trusted_identity_mr_signer_create(
  const McBuffer* MC_NONNULL mr_signer,
  McAdvisories* MC_NONNULL config_advisories,
  McAdvisories* MC_NONNULL hardening_advisories,
  uint16_t expected_product_id,
  uint16_t minimum_security_version
)
MC_ATTRIBUTE_NONNULL(1, 2, 3);

void mc_trusted_identity_mr_enclave_free(
  McTrustedMrEnclaveIdentity* MC_NULLABLE mr_enclave_trusted_identity
);

void mc_trusted_identity_mr_signer_free(
  McTrustedMrSignerIdentity* MC_NULLABLE mr_signer_trusted_identity
);

// MrEnclave to string
ssize_t  mc_trusted_mr_enclave_identity_advisories_to_string(
  const McTrustedMrEnclaveIdentity* MC_NONNULL mr_enclave_trusted_identity,
  McMutableBuffer* MC_NULLABLE out_advisories
)
MC_ATTRIBUTE_NONNULL(1);

ssize_t  mc_trusted_mr_enclave_identity_to_string(
  const McTrustedMrEnclaveIdentity* MC_NONNULL mr_enclave_trusted_identity,
  McMutableBuffer* MC_NULLABLE out_enclave_measurement
)
MC_ATTRIBUTE_NONNULL(1);

// MrSigner to string
ssize_t  mc_trusted_mr_signer_identity_advisories_to_string(
  const McTrustedMrSignerIdentity* MC_NONNULL mr_signer_trusted_identity,
  McMutableBuffer* MC_NULLABLE out_advisories
)
MC_ATTRIBUTE_NONNULL(1);

ssize_t  mc_trusted_mr_signer_identity_to_string(
  const McTrustedMrSignerIdentity* MC_NONNULL mr_signer_trusted_identity,
  McMutableBuffer* MC_NULLABLE out_enclave_measurement
)
MC_ATTRIBUTE_NONNULL(1);

/* ==== McAdvisories ==== */

/// Construct a new advisories vector to hold strings
McAdvisories* MC_NULLABLE mc_advisories_create(void);

void mc_advisories_free(
  McAdvisories* MC_NULLABLE advisories
);

bool mc_add_advisory(
    McAdvisories* MC_NONNULL advisories,
    const char* MC_NONNULL advisory_id
)
MC_ATTRIBUTE_NONNULL(1, 2);

/* ==== McTrustedIdentities ==== */

/// Construct a new trusted identities vector to hold TrustedIdentity structs
McTrustedIdentities* MC_NULLABLE mc_trusted_identities_create(void);

void mc_trusted_identities_free(
  McTrustedIdentities* MC_NULLABLE verifier
);

/// Verify the given MrEnclave-based status verifier succeeds
bool mc_trusted_identities_add_mr_enclave(
  McTrustedIdentities* MC_NONNULL trusted_identities,
  const McTrustedMrEnclaveIdentity* MC_NONNULL mr_enclave_trusted_identity
)
MC_ATTRIBUTE_NONNULL(1, 2);

/// Verify the given MrSigner-based status trusted_identities succeeds
bool mc_trusted_identities_add_mr_signer(
  McTrustedIdentities* MC_NONNULL trusted_identities,
  const McTrustedMrSignerIdentity* MC_NONNULL mr_signer_trusted_identity
)
MC_ATTRIBUTE_NONNULL(1, 2);

/* ==== McAttestAke ==== */

McAttestAke* MC_NULLABLE mc_attest_ake_create(void);

void mc_attest_ake_free(
  McAttestAke* MC_NULLABLE attest_ake
);

bool mc_attest_ake_is_attested(
  const McAttestAke* MC_NONNULL attest_ake,
  bool* MC_NONNULL out_attested
)
MC_ATTRIBUTE_NONNULL(1, 2);

/// # Preconditions
///
/// * `attest_ake` - must be in the attested state.
/// * `out_binding` - must be null or else length must be >= `binding.len`.
ssize_t mc_attest_ake_get_binding(
  const McAttestAke* MC_NONNULL attest_ake,
  McMutableBuffer* MC_NULLABLE out_binding
)
MC_ATTRIBUTE_NONNULL(1);

/* ==== Auth ==== */

/// # Preconditions
///
/// * `responder_id` - must be a nul-terminated C string containing a valid responder ID.
/// * `out_auth_request` - must be null or else length must be >= auth_request_output.len.
ssize_t mc_attest_ake_get_auth_request(
  McAttestAke* MC_NONNULL attest_ake,
  const char* MC_NONNULL responder_id,
  McRngCallback* MC_NULLABLE rng_callback,
  McMutableBuffer* MC_NULLABLE out_auth_request
)
MC_ATTRIBUTE_NONNULL(1, 2);

/// # Preconditions
///
/// * `attest_ake` - must be in the auth pending state.
///
/// # Errors
///
/// * `LibMcError::AttestationVerificationFailed`
/// * `LibMcError::InvalidInput`
bool mc_attest_ake_process_auth_response(
  McAttestAke* MC_NONNULL attest_ake,
  const McBuffer* MC_NONNULL auth_response_data,
  const McTrustedIdentities* MC_NONNULL trusted_identities,
  McError* MC_NULLABLE * MC_NULLABLE out_error
)
MC_ATTRIBUTE_NONNULL(1, 2, 3);

/* ==== Message Encryption ==== */

/// # Preconditions
///
/// * `attest_ake` - must be in the attested state.
/// * `out_ciphertext` - must be null or else length must be >= `ciphertext.len`.
///
/// # Errors
///
/// * `LibMcError::Aead`
/// * `LibMcError::Cipher`
ssize_t mc_attest_ake_encrypt(
  McAttestAke* MC_NONNULL attest_ake,
  const McBuffer* MC_NONNULL aad,
  const McBuffer* MC_NONNULL plaintext,
  McMutableBuffer* MC_NULLABLE out_ciphertext,
  McError* MC_NULLABLE * MC_NULLABLE out_error
)
MC_ATTRIBUTE_NONNULL(1, 2, 3);

/// # Preconditions
///
/// * `attest_ake` - must be in the attested state.
/// * `out_plaintext` - length must be >= `ciphertext.len`.
///
/// # Errors
///
/// * `LibMcError::Aead`
/// * `LibMcError::Cipher`
ssize_t mc_attest_ake_decrypt(
  McAttestAke* MC_NONNULL attest_ake,
  const McBuffer* MC_NONNULL aad,
  const McBuffer* MC_NONNULL ciphertext,
  McMutableBuffer* MC_NONNULL out_plaintext,
  McError* MC_NULLABLE * MC_NULLABLE out_error
)
MC_ATTRIBUTE_NONNULL(1, 2, 3, 4);

#ifdef __cplusplus
}
#endif

#endif /* !ATTEST_H_ */
