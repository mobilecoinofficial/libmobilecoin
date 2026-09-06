// Copyright (c) 2018-2022 The MobileCoin Foundation

use super::{IntoFfi, McError};
use crate::LibMcError;
use mc_util_ffi::{FfiOptMutPtr, FfiOptOwnedPtr, FfiOwnedPtr};
use std::{
    panic::{catch_unwind, AssertUnwindSafe},
    process::abort,
};

/// This function should be used as the outer-most "layer" protecting Rust code
/// from unwinding across the FFI boundary in the event of a panic. All Rust
/// code in FFI functions (e.g. `extern "C"` functions) should be executed
/// within the closure passed as parameter `f`. This function ensures FFI safety
/// by catching unwind panics, logging the panic, and returning the
/// sentinel error value returned by a call to `R::error_value()`.
pub(crate) fn ffi_boundary<R, I>(f: impl (FnOnce() -> R)) -> I
where
    R: IntoFfi<I>,
{
    ffi_boundary_impl(|| {
        let result = f().into_ffi();
        Ok(result)
    })
    .unwrap_or_else(|err| {
        log_error(err);
        R::error_value()
    })
}

/// This function should be used as the outer-most "layer" protecting Rust code
/// from unwinding across the FFI boundary in the event of a panic. All Rust
/// code in FFI functions (e.g. `extern "C"` functions) should be executed
/// within the closure passed as parameter `f`. This function ensures FFI safety
/// by catching unwind panics, saving the panic as a `LibMcError` to the
/// `out_error` (if `out_error` is non-null), and returning the sentinel error
/// value returned by a call to `R::error_value()`.
pub(crate) fn ffi_boundary_with_error<R, I>(
    out_error: FfiOptMutPtr<FfiOptOwnedPtr<McError>>,
    f: impl (FnOnce() -> Result<R, LibMcError>),
) -> I
where
    R: IntoFfi<I>,
{
    ffi_boundary_impl(|| {
        let result = f()?.into_ffi();
        Ok(result)
    })
    .unwrap_or_else(|err| {
        set_error_or_log(err, out_error);
        R::error_value()
    })
}

fn ffi_boundary_impl<R>(f: impl (FnOnce() -> Result<R, LibMcError>)) -> Result<R, LibMcError> {
    // AssertUnwindSafe: the `Box<dyn ... + Send + Sync>` types the builders hold
    // cannot be UnwindSafe, because interior mutability is possible. Dropping
    // `+ Send + Sync` to gain it makes those types illegal behind a Mutex, which
    // breaks the android bindings. Boxing is what keeps the builders from taking
    // a generic parameter, which would multiply the types needing bindings.
    //
    // UnwindSafe guards against observing a broken invariant after a caught
    // panic. This boundary needs only to stop the unwind before it crosses the
    // C ABI.
    catch_unwind(AssertUnwindSafe(f))
        // Formatting the payload into a `LibMcError` can itself panic, so that
        // step is caught as well.
        .unwrap_or_else(|panic_error| {
            // AssertUnwindSafe: the payload is read and never modified, so a panic
            // here leaves no broken invariant behind.
            let panic_error = AssertUnwindSafe(panic_error);
            catch_unwind(|| Err(LibMcError::Panic(format!("{:?}", *panic_error))))
                // A panic here leaves no route that reports the failure, so the
                // process aborts rather than unwind across the C ABI.
                .unwrap_or_else(|_| abort())
        })
}

fn set_error_or_log(err: LibMcError, out_error: FfiOptMutPtr<FfiOptOwnedPtr<McError>>) {
    error_handling_ffi_boundary(|| {
        if let Some(error) = out_error.into_mut() {
            *error = FfiOwnedPtr::new(McError::from(err)).into();
        } else {
            eprintln!("LibMobileCoin Error: {}", err);
        }
    });
}

fn log_error(err: LibMcError) {
    error_handling_ffi_boundary(|| eprintln!("LibMobileCoin Error: {}", err))
}

fn error_handling_ffi_boundary(f: impl FnOnce()) {
    let _ = ffi_boundary_impl(|| {
        f();
        Ok(())
    })
    // Reaching here means the error handling itself panicked. The payload is printed and
    // then dropped, because aborting would take the host process down.
    .map_err(|panic_error| {
        let panic_error = AssertUnwindSafe(panic_error);
        // guard against panics while printing
        let _ = catch_unwind(|| {
            let panic_error = panic_error.0;
            eprintln!(
                "LibMobileCoin panicked during error handling: {}",
                panic_error
            );
        });
    });
}
