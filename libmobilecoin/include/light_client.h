// Copyright (c) 2018-2023 The MobileCoin Foundation

#ifndef LIGHT_CLIENT_H_
#define LIGHT_CLIENT_H_

#include "common.h"

/* ==================== Transaction ==================== */

#ifdef __cplusplus
extern "C"
{
#endif

    typedef struct _LightClientVerifier McLightClientVerifier;

    McLightClientVerifier *MC_NULLABLE mc_light_client_verifier_create(
        const char *MC_NONNULL config_json,
        McError *MC_NULLABLE *MC_NULLABLE out_error)
        MC_ATTRIBUTE_NONNULL(1);

    void mc_light_client_verifier_free(McLightClientVerifier *MC_NONNULL lcv)
        MC_ATTRIBUTE_NONNULL(1);

#ifdef __cplusplus
}
#endif

#endif /* !TRANSACTION_H_ */
