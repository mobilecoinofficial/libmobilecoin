// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: mistyswap_common.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

// Copyright (c) 2018-2023 MobileCoin Inc.

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

//// On-going swap info.
public struct MistyswapCommon_OngoingSwap {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  //// The Mixin trace ID of the swap.
  public var traceID: String = String()

  //// The Mixin user ID of the swap.
  public var followID: String = String()

  //// Asset UUID we are swapping from.
  public var srcAssetID: String = String()

  //// Amount we are swapping (string since it can be decimal).
  public var srcAmount: String = String()

  //// Asset UUID we are swapping to.
  public var dstAssetID: String = String()

  //// Minimum amount we will accept, otherwise the swap gets rejected (string since it can be decimal).
  public var dstAmountMin: String = String()

  //// Mixin route hash ids.
  public var routeHashIds: String = String()

  //// The Mixin snapshot JSON blob.
  public var transferJson: String = String()

  //// Our balance of the src asset before we sent the swap transaction.
  public var preSwapSrcBalance: String = String()

  //// Our balance of the dst asset before we sent the swap transaction.
  public var preSwapDstBalance: String = String()

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

//// Response to the `GetInfo` request
public struct MistyswapCommon_GetInfoResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  //// Max concurrent offramps
  public var maxConcurrentOfframps: UInt64 = 0

  //// Max concurrent onramps
  public var maxConcurrentOnramps: UInt64 = 0

  //// Current number of offramps
  public var currentOfframps: UInt64 = 0

  //// Current number of onramps
  public var currentOnramps: UInt64 = 0

  //// List of supported offramp source asset ids.
  public var offrampAllowedSrcAssetIds: [String] = []

  //// List of supported offramp destination asset ids.
  public var offrampAllowedDstAssetIds: [String] = []

  //// List of supported onramp source asset ids.
  public var onrampAllowedSrcAssetIds: [String] = []

  //// List of supported onramp destination asset ids.
  public var onrampAllowedDstAssetIds: [String] = []

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

#if swift(>=5.5) && canImport(_Concurrency)
extension MistyswapCommon_OngoingSwap: @unchecked Sendable {}
extension MistyswapCommon_GetInfoResponse: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "mistyswap_common"

extension MistyswapCommon_OngoingSwap: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".OngoingSwap"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "trace_id"),
    2: .standard(proto: "follow_id"),
    3: .standard(proto: "src_asset_id"),
    4: .standard(proto: "src_amount"),
    5: .standard(proto: "dst_asset_id"),
    6: .standard(proto: "dst_amount_min"),
    7: .standard(proto: "route_hash_ids"),
    8: .standard(proto: "transfer_json"),
    9: .standard(proto: "pre_swap_src_balance"),
    10: .standard(proto: "pre_swap_dst_balance"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.traceID) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.followID) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.srcAssetID) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.srcAmount) }()
      case 5: try { try decoder.decodeSingularStringField(value: &self.dstAssetID) }()
      case 6: try { try decoder.decodeSingularStringField(value: &self.dstAmountMin) }()
      case 7: try { try decoder.decodeSingularStringField(value: &self.routeHashIds) }()
      case 8: try { try decoder.decodeSingularStringField(value: &self.transferJson) }()
      case 9: try { try decoder.decodeSingularStringField(value: &self.preSwapSrcBalance) }()
      case 10: try { try decoder.decodeSingularStringField(value: &self.preSwapDstBalance) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.traceID.isEmpty {
      try visitor.visitSingularStringField(value: self.traceID, fieldNumber: 1)
    }
    if !self.followID.isEmpty {
      try visitor.visitSingularStringField(value: self.followID, fieldNumber: 2)
    }
    if !self.srcAssetID.isEmpty {
      try visitor.visitSingularStringField(value: self.srcAssetID, fieldNumber: 3)
    }
    if !self.srcAmount.isEmpty {
      try visitor.visitSingularStringField(value: self.srcAmount, fieldNumber: 4)
    }
    if !self.dstAssetID.isEmpty {
      try visitor.visitSingularStringField(value: self.dstAssetID, fieldNumber: 5)
    }
    if !self.dstAmountMin.isEmpty {
      try visitor.visitSingularStringField(value: self.dstAmountMin, fieldNumber: 6)
    }
    if !self.routeHashIds.isEmpty {
      try visitor.visitSingularStringField(value: self.routeHashIds, fieldNumber: 7)
    }
    if !self.transferJson.isEmpty {
      try visitor.visitSingularStringField(value: self.transferJson, fieldNumber: 8)
    }
    if !self.preSwapSrcBalance.isEmpty {
      try visitor.visitSingularStringField(value: self.preSwapSrcBalance, fieldNumber: 9)
    }
    if !self.preSwapDstBalance.isEmpty {
      try visitor.visitSingularStringField(value: self.preSwapDstBalance, fieldNumber: 10)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: MistyswapCommon_OngoingSwap, rhs: MistyswapCommon_OngoingSwap) -> Bool {
    if lhs.traceID != rhs.traceID {return false}
    if lhs.followID != rhs.followID {return false}
    if lhs.srcAssetID != rhs.srcAssetID {return false}
    if lhs.srcAmount != rhs.srcAmount {return false}
    if lhs.dstAssetID != rhs.dstAssetID {return false}
    if lhs.dstAmountMin != rhs.dstAmountMin {return false}
    if lhs.routeHashIds != rhs.routeHashIds {return false}
    if lhs.transferJson != rhs.transferJson {return false}
    if lhs.preSwapSrcBalance != rhs.preSwapSrcBalance {return false}
    if lhs.preSwapDstBalance != rhs.preSwapDstBalance {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension MistyswapCommon_GetInfoResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".GetInfoResponse"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "max_concurrent_offramps"),
    2: .standard(proto: "max_concurrent_onramps"),
    3: .standard(proto: "current_offramps"),
    4: .standard(proto: "current_onramps"),
    5: .standard(proto: "offramp_allowed_src_asset_ids"),
    6: .standard(proto: "offramp_allowed_dst_asset_ids"),
    7: .standard(proto: "onramp_allowed_src_asset_ids"),
    8: .standard(proto: "onramp_allowed_dst_asset_ids"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularUInt64Field(value: &self.maxConcurrentOfframps) }()
      case 2: try { try decoder.decodeSingularUInt64Field(value: &self.maxConcurrentOnramps) }()
      case 3: try { try decoder.decodeSingularUInt64Field(value: &self.currentOfframps) }()
      case 4: try { try decoder.decodeSingularUInt64Field(value: &self.currentOnramps) }()
      case 5: try { try decoder.decodeRepeatedStringField(value: &self.offrampAllowedSrcAssetIds) }()
      case 6: try { try decoder.decodeRepeatedStringField(value: &self.offrampAllowedDstAssetIds) }()
      case 7: try { try decoder.decodeRepeatedStringField(value: &self.onrampAllowedSrcAssetIds) }()
      case 8: try { try decoder.decodeRepeatedStringField(value: &self.onrampAllowedDstAssetIds) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.maxConcurrentOfframps != 0 {
      try visitor.visitSingularUInt64Field(value: self.maxConcurrentOfframps, fieldNumber: 1)
    }
    if self.maxConcurrentOnramps != 0 {
      try visitor.visitSingularUInt64Field(value: self.maxConcurrentOnramps, fieldNumber: 2)
    }
    if self.currentOfframps != 0 {
      try visitor.visitSingularUInt64Field(value: self.currentOfframps, fieldNumber: 3)
    }
    if self.currentOnramps != 0 {
      try visitor.visitSingularUInt64Field(value: self.currentOnramps, fieldNumber: 4)
    }
    if !self.offrampAllowedSrcAssetIds.isEmpty {
      try visitor.visitRepeatedStringField(value: self.offrampAllowedSrcAssetIds, fieldNumber: 5)
    }
    if !self.offrampAllowedDstAssetIds.isEmpty {
      try visitor.visitRepeatedStringField(value: self.offrampAllowedDstAssetIds, fieldNumber: 6)
    }
    if !self.onrampAllowedSrcAssetIds.isEmpty {
      try visitor.visitRepeatedStringField(value: self.onrampAllowedSrcAssetIds, fieldNumber: 7)
    }
    if !self.onrampAllowedDstAssetIds.isEmpty {
      try visitor.visitRepeatedStringField(value: self.onrampAllowedDstAssetIds, fieldNumber: 8)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: MistyswapCommon_GetInfoResponse, rhs: MistyswapCommon_GetInfoResponse) -> Bool {
    if lhs.maxConcurrentOfframps != rhs.maxConcurrentOfframps {return false}
    if lhs.maxConcurrentOnramps != rhs.maxConcurrentOnramps {return false}
    if lhs.currentOfframps != rhs.currentOfframps {return false}
    if lhs.currentOnramps != rhs.currentOnramps {return false}
    if lhs.offrampAllowedSrcAssetIds != rhs.offrampAllowedSrcAssetIds {return false}
    if lhs.offrampAllowedDstAssetIds != rhs.offrampAllowedDstAssetIds {return false}
    if lhs.onrampAllowedSrcAssetIds != rhs.onrampAllowedSrcAssetIds {return false}
    if lhs.onrampAllowedDstAssetIds != rhs.onrampAllowedDstAssetIds {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
