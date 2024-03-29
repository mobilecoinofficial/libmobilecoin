//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: mistyswap_common.proto
//

//
// Copyright 2023, MobileCoin Authors All rights reserved.
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
#if canImport(LibMobileCoinCommon)
import LibMobileCoinCommon
#endif
#if canImport(SwiftProtobuf)
import SwiftProtobuf
#endif


/// Usage: instantiate `MistyswapCommon_MistyswapCommonApiRestClient`, then call methods of this protocol to make API calls.
public protocol MistyswapCommon_MistyswapCommonApiRestClientProtocol: HTTPClient {
  var serviceName: String { get }

  func getInfo(
    _ request: SwiftProtobuf.Google_Protobuf_Empty,
    callOptions: HTTPCallOptions?
  ) -> HTTPUnaryCall<SwiftProtobuf.Google_Protobuf_Empty, MistyswapCommon_GetInfoResponse>
}

extension MistyswapCommon_MistyswapCommonApiRestClientProtocol {
  public var serviceName: String {
    return "mistyswap_common.MistyswapCommonApi"
  }

  //// Get information about this mistyswap instance.
  ///
  /// - Parameters:
  ///   - request: Request to send to GetInfo.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func getInfo(
    _ request: SwiftProtobuf.Google_Protobuf_Empty,
    callOptions: HTTPCallOptions? = nil
  ) -> HTTPUnaryCall<SwiftProtobuf.Google_Protobuf_Empty, MistyswapCommon_GetInfoResponse> {
    return self.makeUnaryCall(
      path: MistyswapCommon_MistyswapCommonApiClientMetadata.Methods.getInfo.path,
      request: request,
      callOptions: callOptions ?? self.defaultHTTPCallOptions
    )
  }
}

public final class MistyswapCommon_MistyswapCommonApiRestClient: MistyswapCommon_MistyswapCommonApiRestClientProtocol {
  public var defaultHTTPCallOptions: HTTPCallOptions

  /// Creates a client for the mistyswap_common.MistyswapCommonApi service.
  ///
  /// - Parameters:
  ///   - defaultHTTPCallOptions: Options to use for each service call if the user doesn't provide them.
  public init(
    defaultHTTPCallOptions: HTTPCallOptions = HTTPCallOptions()
  ) {
    self.defaultHTTPCallOptions = defaultHTTPCallOptions
  }
}

public enum MistyswapCommon_MistyswapCommonApiClientMetadata {
  public static let serviceDescriptor = HTTPServiceDescriptor(
    name: "MistyswapCommonApi",
    fullName: "mistyswap_common.MistyswapCommonApi",
    methods: [
      MistyswapCommon_MistyswapCommonApiClientMetadata.Methods.getInfo,
    ]
  )

  public enum Methods {
    public static let getInfo = HTTPMethodDescriptor(
      name: "GetInfo",
      path: "/mistyswap_common.MistyswapCommonApi/GetInfo",
      type: HTTPCallType.unary
    )
  }
}

