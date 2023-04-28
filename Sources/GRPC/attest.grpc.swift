//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: attest.proto
//

//
// Copyright 2018, gRPC Authors All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import GRPC
#if canImport(LibMobileCoinCommon)
import LibMobileCoinCommon
#endif
import NIO
import SwiftProtobuf


//// A server-authenticated service for SGX enclaves. The responder is the
//// attesting enclave, and the client is unauthenticated. When described
//// within the noise protocol, this is similar to the "IX" style key exchange:
////
//// ```txt
//// IX:
////   -> e, s
////   <- e, ee, se, s, es
////   ->
////   <-
//// ```
////
//// The first two messages are contained within the Auth and AuthResponse
///
/// Usage: instantiate `Attest_AttestedApiClient`, then call methods of this protocol to make API calls.
public protocol Attest_AttestedApiClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: Attest_AttestedApiClientInterceptorFactoryProtocol? { get }

  func auth(
    _ request: Attest_AuthMessage,
    callOptions: CallOptions?
  ) -> UnaryCall<Attest_AuthMessage, Attest_AuthMessage>
}

extension Attest_AttestedApiClientProtocol {
  public var serviceName: String {
    return "attest.AttestedApi"
  }

  //// This API call is made when one enclave wants to start a mutually-
  //// authenticated key-exchange session with an enclave.
  ///
  /// - Parameters:
  ///   - request: Request to send to Auth.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func auth(
    _ request: Attest_AuthMessage,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Attest_AuthMessage, Attest_AuthMessage> {
    return self.makeUnaryCall(
      path: "/attest.AttestedApi/Auth",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeAuthInterceptors() ?? []
    )
  }
}

public protocol Attest_AttestedApiClientInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when invoking 'auth'.
  func makeAuthInterceptors() -> [ClientInterceptor<Attest_AuthMessage, Attest_AuthMessage>]
}

public final class Attest_AttestedApiClient: Attest_AttestedApiClientProtocol {
  public let channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: Attest_AttestedApiClientInterceptorFactoryProtocol?

  /// Creates a client for the attest.AttestedApi service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Attest_AttestedApiClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

