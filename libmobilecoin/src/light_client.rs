// Copyright (c) 2018-2023 The MobileCoin Foundation

use crate::{common::*, LibMcError};
use mc_light_client_verifier::{LightClientVerifier, LightClientVerifierConfig};
use mc_util_ffi::*;

/* ==== LightClientVerifier ==== */

pub type McLightClientVerifier = LightClientVerifier;
impl_into_ffi!(McLightClientVerifier);

#[no_mangle]
pub extern "C" fn mc_light_client_verifier_create(
    config_json: FfiStr,
    out_error: FfiOptMutPtr<FfiOptOwnedPtr<McError>>,
) -> FfiOptOwnedPtr<McLightClientVerifier> {
    ffi_boundary_with_error(out_error, || {
        let config_json_str = config_json
            .as_str()
            .map_err(|err| LibMcError::InvalidInput(format!("config_json: {}", err)))?;

        let lvc_conf = serde_json::from_str::<LightClientVerifierConfig>(config_json_str)
            .map_err(|err| LibMcError::InvalidInput(format!("config_json_str: {}", err)))?;

        Ok(LightClientVerifier::from(lvc_conf))
    })
}
