// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: consensus_client.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

// Copyright (c) 2018-2022 The MobileCoin Foundation

// Consensus service client-facing data types and service descriptors.

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

public enum ConsensusClient_MintValidationResultCode: SwiftProtobuf.Enum {
  public typealias RawValue = Int
  case ok // = 0
  case invalidBlockVersion // = 1
  case invalidTokenID // = 2
  case invalidNonceLength // = 3
  case invalidSignerSet // = 4
  case invalidSignature // = 5
  case tombstoneBlockExceeded // = 6
  case tombstoneBlockTooFar // = 7
  case unknown // = 8
  case amountExceedsMintLimit // = 9
  case noGovernors // = 10
  case nonceAlreadyUsed // = 11
  case noMatchingMintConfig // = 12
  case mintingToFogNotSupported // = 13
  case UNRECOGNIZED(Int)

  public init() {
    self = .ok
  }

  public init?(rawValue: Int) {
    switch rawValue {
    case 0: self = .ok
    case 1: self = .invalidBlockVersion
    case 2: self = .invalidTokenID
    case 3: self = .invalidNonceLength
    case 4: self = .invalidSignerSet
    case 5: self = .invalidSignature
    case 6: self = .tombstoneBlockExceeded
    case 7: self = .tombstoneBlockTooFar
    case 8: self = .unknown
    case 9: self = .amountExceedsMintLimit
    case 10: self = .noGovernors
    case 11: self = .nonceAlreadyUsed
    case 12: self = .noMatchingMintConfig
    case 13: self = .mintingToFogNotSupported
    default: self = .UNRECOGNIZED(rawValue)
    }
  }

  public var rawValue: Int {
    switch self {
    case .ok: return 0
    case .invalidBlockVersion: return 1
    case .invalidTokenID: return 2
    case .invalidNonceLength: return 3
    case .invalidSignerSet: return 4
    case .invalidSignature: return 5
    case .tombstoneBlockExceeded: return 6
    case .tombstoneBlockTooFar: return 7
    case .unknown: return 8
    case .amountExceedsMintLimit: return 9
    case .noGovernors: return 10
    case .nonceAlreadyUsed: return 11
    case .noMatchingMintConfig: return 12
    case .mintingToFogNotSupported: return 13
    case .UNRECOGNIZED(let i): return i
    }
  }

}

#if swift(>=4.2)

extension ConsensusClient_MintValidationResultCode: CaseIterable {
  // The compiler won't synthesize support with the UNRECOGNIZED case.
  public static let allCases: [ConsensusClient_MintValidationResultCode] = [
    .ok,
    .invalidBlockVersion,
    .invalidTokenID,
    .invalidNonceLength,
    .invalidSignerSet,
    .invalidSignature,
    .tombstoneBlockExceeded,
    .tombstoneBlockTooFar,
    .unknown,
    .amountExceedsMintLimit,
    .noGovernors,
    .nonceAlreadyUsed,
    .noMatchingMintConfig,
    .mintingToFogNotSupported,
  ]
}

#endif  // swift(>=4.2)

public struct ConsensusClient_MintValidationResult {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  //// The actual result code.
  public var code: ConsensusClient_MintValidationResultCode = .ok

  //// Block version, if result is InvalidBlockVersion.
  public var blockVersion: UInt32 = 0

  //// Token ID, if result is InvalidTokenId or NoGovernors.
  public var tokenID: UInt64 = 0

  //// Nonce length, if result is InvalidNonceLength
  public var nonceLength: UInt64 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

//// Response from ProposeMintConfigTx RPC call.
public struct ConsensusClient_ProposeMintConfigTxResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  //// Result.
  public var result: ConsensusClient_MintValidationResult {
    get {return _result ?? ConsensusClient_MintValidationResult()}
    set {_result = newValue}
  }
  /// Returns true if `result` has been explicitly set.
  public var hasResult: Bool {return self._result != nil}
  /// Clears the value of `result`. Subsequent reads from it will return its default value.
  public mutating func clearResult() {self._result = nil}

  //// The number of blocks in the ledger at the time the request was received.
  public var blockCount: UInt64 = 0

  //// The block version which is in effect right now
  public var blockVersion: UInt32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _result: ConsensusClient_MintValidationResult? = nil
}

//// Response from ProposeMintTx RPC call.
public struct ConsensusClient_ProposeMintTxResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  //// Result.
  public var result: ConsensusClient_MintValidationResult {
    get {return _result ?? ConsensusClient_MintValidationResult()}
    set {_result = newValue}
  }
  /// Returns true if `result` has been explicitly set.
  public var hasResult: Bool {return self._result != nil}
  /// Clears the value of `result`. Subsequent reads from it will return its default value.
  public mutating func clearResult() {self._result = nil}

  //// The number of blocks in the ledger at the time the request was received.
  public var blockCount: UInt64 = 0

  //// The block version which is in effect right now
  public var blockVersion: UInt32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _result: ConsensusClient_MintValidationResult? = nil
}

#if swift(>=5.5) && canImport(_Concurrency)
extension ConsensusClient_MintValidationResultCode: @unchecked Sendable {}
extension ConsensusClient_MintValidationResult: @unchecked Sendable {}
extension ConsensusClient_ProposeMintConfigTxResponse: @unchecked Sendable {}
extension ConsensusClient_ProposeMintTxResponse: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "consensus_client"

extension ConsensusClient_MintValidationResultCode: SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "Ok"),
    1: .same(proto: "InvalidBlockVersion"),
    2: .same(proto: "InvalidTokenId"),
    3: .same(proto: "InvalidNonceLength"),
    4: .same(proto: "InvalidSignerSet"),
    5: .same(proto: "InvalidSignature"),
    6: .same(proto: "TombstoneBlockExceeded"),
    7: .same(proto: "TombstoneBlockTooFar"),
    8: .same(proto: "Unknown"),
    9: .same(proto: "AmountExceedsMintLimit"),
    10: .same(proto: "NoGovernors"),
    11: .same(proto: "NonceAlreadyUsed"),
    12: .same(proto: "NoMatchingMintConfig"),
    13: .same(proto: "MintingToFogNotSupported"),
  ]
}

extension ConsensusClient_MintValidationResult: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".MintValidationResult"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "code"),
    2: .standard(proto: "block_version"),
    3: .standard(proto: "token_id"),
    4: .standard(proto: "nonce_length"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.code) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.blockVersion) }()
      case 3: try { try decoder.decodeSingularUInt64Field(value: &self.tokenID) }()
      case 4: try { try decoder.decodeSingularUInt64Field(value: &self.nonceLength) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.code != .ok {
      try visitor.visitSingularEnumField(value: self.code, fieldNumber: 1)
    }
    if self.blockVersion != 0 {
      try visitor.visitSingularUInt32Field(value: self.blockVersion, fieldNumber: 2)
    }
    if self.tokenID != 0 {
      try visitor.visitSingularUInt64Field(value: self.tokenID, fieldNumber: 3)
    }
    if self.nonceLength != 0 {
      try visitor.visitSingularUInt64Field(value: self.nonceLength, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: ConsensusClient_MintValidationResult, rhs: ConsensusClient_MintValidationResult) -> Bool {
    if lhs.code != rhs.code {return false}
    if lhs.blockVersion != rhs.blockVersion {return false}
    if lhs.tokenID != rhs.tokenID {return false}
    if lhs.nonceLength != rhs.nonceLength {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension ConsensusClient_ProposeMintConfigTxResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".ProposeMintConfigTxResponse"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "result"),
    2: .standard(proto: "block_count"),
    3: .standard(proto: "block_version"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._result) }()
      case 2: try { try decoder.decodeSingularUInt64Field(value: &self.blockCount) }()
      case 3: try { try decoder.decodeSingularUInt32Field(value: &self.blockVersion) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._result {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    if self.blockCount != 0 {
      try visitor.visitSingularUInt64Field(value: self.blockCount, fieldNumber: 2)
    }
    if self.blockVersion != 0 {
      try visitor.visitSingularUInt32Field(value: self.blockVersion, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: ConsensusClient_ProposeMintConfigTxResponse, rhs: ConsensusClient_ProposeMintConfigTxResponse) -> Bool {
    if lhs._result != rhs._result {return false}
    if lhs.blockCount != rhs.blockCount {return false}
    if lhs.blockVersion != rhs.blockVersion {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension ConsensusClient_ProposeMintTxResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".ProposeMintTxResponse"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "result"),
    2: .standard(proto: "block_count"),
    3: .standard(proto: "block_version"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._result) }()
      case 2: try { try decoder.decodeSingularUInt64Field(value: &self.blockCount) }()
      case 3: try { try decoder.decodeSingularUInt32Field(value: &self.blockVersion) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._result {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    if self.blockCount != 0 {
      try visitor.visitSingularUInt64Field(value: self.blockCount, fieldNumber: 2)
    }
    if self.blockVersion != 0 {
      try visitor.visitSingularUInt32Field(value: self.blockVersion, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: ConsensusClient_ProposeMintTxResponse, rhs: ConsensusClient_ProposeMintTxResponse) -> Bool {
    if lhs._result != rhs._result {return false}
    if lhs.blockCount != rhs.blockCount {return false}
    if lhs.blockVersion != rhs.blockVersion {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
