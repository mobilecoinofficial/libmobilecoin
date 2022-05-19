// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: consensus_config.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

// Copyright (c) 2022 The MobileCoin Foundation

// Consensus service configuration data types.

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

/// A single active minting configuration.
public struct ConsensusConfig_ActiveMintConfig {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The actual mint configuration.
  public var mintConfig: External_MintConfig {
    get {return _mintConfig ?? External_MintConfig()}
    set {_mintConfig = newValue}
  }
  /// Returns true if `mintConfig` has been explicitly set.
  public var hasMintConfig: Bool {return self._mintConfig != nil}
  /// Clears the value of `mintConfig`. Subsequent reads from it will return its default value.
  public mutating func clearMintConfig() {self._mintConfig = nil}

  /// How many tokens have been minted using this configuration.
  public var totalMinted: UInt64 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _mintConfig: External_MintConfig? = nil
}

/// Active minting configurations for a single token.
public struct ConsensusConfig_ActiveMintConfigs {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  //// Active configs
  public var configs: [ConsensusConfig_ActiveMintConfig] = []

  /// The original MintConfigTx that this configuration resulted from.
  public var mintConfigTx: External_MintConfigTx {
    get {return _mintConfigTx ?? External_MintConfigTx()}
    set {_mintConfigTx = newValue}
  }
  /// Returns true if `mintConfigTx` has been explicitly set.
  public var hasMintConfigTx: Bool {return self._mintConfigTx != nil}
  /// Clears the value of `mintConfigTx`. Subsequent reads from it will return its default value.
  public mutating func clearMintConfigTx() {self._mintConfigTx = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _mintConfigTx: External_MintConfigTx? = nil
}

/// Token configuration (per-token configuration).
public struct ConsensusConfig_TokenConfig {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The token id this configuration is for.
  public var tokenID: UInt64 = 0

  /// The current minimum fee for this token.
  public var minimumFee: UInt64 = 0

  /// Minting governors (optional, only when minting is configured).
  public var governors: External_Ed25519SignerSet {
    get {return _governors ?? External_Ed25519SignerSet()}
    set {_governors = newValue}
  }
  /// Returns true if `governors` has been explicitly set.
  public var hasGovernors: Bool {return self._governors != nil}
  /// Clears the value of `governors`. Subsequent reads from it will return its default value.
  public mutating func clearGovernors() {self._governors = nil}

  /// Currently active mint configurations for this token (optional, only if a valid MintConfigTx has been previously issued).
  public var activeMintConfigs: ConsensusConfig_ActiveMintConfigs {
    get {return _activeMintConfigs ?? ConsensusConfig_ActiveMintConfigs()}
    set {_activeMintConfigs = newValue}
  }
  /// Returns true if `activeMintConfigs` has been explicitly set.
  public var hasActiveMintConfigs: Bool {return self._activeMintConfigs != nil}
  /// Clears the value of `activeMintConfigs`. Subsequent reads from it will return its default value.
  public mutating func clearActiveMintConfigs() {self._activeMintConfigs = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _governors: External_Ed25519SignerSet? = nil
  fileprivate var _activeMintConfigs: ConsensusConfig_ActiveMintConfigs? = nil
}

/// Consensus node configuration.
public struct ConsensusConfig_ConsensusNodeConfig {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Minting trust root public key.
  public var mintingTrustRoot: External_Ed25519Public {
    get {return _mintingTrustRoot ?? External_Ed25519Public()}
    set {_mintingTrustRoot = newValue}
  }
  /// Returns true if `mintingTrustRoot` has been explicitly set.
  public var hasMintingTrustRoot: Bool {return self._mintingTrustRoot != nil}
  /// Clears the value of `mintingTrustRoot`. Subsequent reads from it will return its default value.
  public mutating func clearMintingTrustRoot() {self._mintingTrustRoot = nil}

  /// token id -> configuration map.
  public var tokenConfigMap: Dictionary<UInt64,ConsensusConfig_TokenConfig> = [:]

  /// Governors signature.
  public var governorsSignature: External_Ed25519Signature {
    get {return _governorsSignature ?? External_Ed25519Signature()}
    set {_governorsSignature = newValue}
  }
  /// Returns true if `governorsSignature` has been explicitly set.
  public var hasGovernorsSignature: Bool {return self._governorsSignature != nil}
  /// Clears the value of `governorsSignature`. Subsequent reads from it will return its default value.
  public mutating func clearGovernorsSignature() {self._governorsSignature = nil}

  /// Peer responder id.
  public var peerResponderID: String = String()

  /// Client responser id.
  public var clientResponderID: String = String()

  /// Block signing key.
  public var blockSigningKey: External_Ed25519Public {
    get {return _blockSigningKey ?? External_Ed25519Public()}
    set {_blockSigningKey = newValue}
  }
  /// Returns true if `blockSigningKey` has been explicitly set.
  public var hasBlockSigningKey: Bool {return self._blockSigningKey != nil}
  /// Clears the value of `blockSigningKey`. Subsequent reads from it will return its default value.
  public mutating func clearBlockSigningKey() {self._blockSigningKey = nil}

  /// Currently configured block version.
  public var blockVersion: UInt32 = 0

  /// SCP message signing key.
  public var scpMessageSigningKey: External_Ed25519Public {
    get {return _scpMessageSigningKey ?? External_Ed25519Public()}
    set {_scpMessageSigningKey = newValue}
  }
  /// Returns true if `scpMessageSigningKey` has been explicitly set.
  public var hasScpMessageSigningKey: Bool {return self._scpMessageSigningKey != nil}
  /// Clears the value of `scpMessageSigningKey`. Subsequent reads from it will return its default value.
  public mutating func clearScpMessageSigningKey() {self._scpMessageSigningKey = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _mintingTrustRoot: External_Ed25519Public? = nil
  fileprivate var _governorsSignature: External_Ed25519Signature? = nil
  fileprivate var _blockSigningKey: External_Ed25519Public? = nil
  fileprivate var _scpMessageSigningKey: External_Ed25519Public? = nil
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "consensus_config"

extension ConsensusConfig_ActiveMintConfig: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".ActiveMintConfig"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "mint_config"),
    2: .standard(proto: "total_minted"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._mintConfig) }()
      case 2: try { try decoder.decodeSingularUInt64Field(value: &self.totalMinted) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._mintConfig {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    if self.totalMinted != 0 {
      try visitor.visitSingularUInt64Field(value: self.totalMinted, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: ConsensusConfig_ActiveMintConfig, rhs: ConsensusConfig_ActiveMintConfig) -> Bool {
    if lhs._mintConfig != rhs._mintConfig {return false}
    if lhs.totalMinted != rhs.totalMinted {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension ConsensusConfig_ActiveMintConfigs: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".ActiveMintConfigs"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "configs"),
    2: .standard(proto: "mint_config_tx"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.configs) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._mintConfigTx) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if !self.configs.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.configs, fieldNumber: 1)
    }
    try { if let v = self._mintConfigTx {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: ConsensusConfig_ActiveMintConfigs, rhs: ConsensusConfig_ActiveMintConfigs) -> Bool {
    if lhs.configs != rhs.configs {return false}
    if lhs._mintConfigTx != rhs._mintConfigTx {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension ConsensusConfig_TokenConfig: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".TokenConfig"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "token_id"),
    2: .standard(proto: "minimum_fee"),
    3: .same(proto: "governors"),
    4: .standard(proto: "active_mint_configs"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularUInt64Field(value: &self.tokenID) }()
      case 2: try { try decoder.decodeSingularUInt64Field(value: &self.minimumFee) }()
      case 3: try { try decoder.decodeSingularMessageField(value: &self._governors) }()
      case 4: try { try decoder.decodeSingularMessageField(value: &self._activeMintConfigs) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if self.tokenID != 0 {
      try visitor.visitSingularUInt64Field(value: self.tokenID, fieldNumber: 1)
    }
    if self.minimumFee != 0 {
      try visitor.visitSingularUInt64Field(value: self.minimumFee, fieldNumber: 2)
    }
    try { if let v = self._governors {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
    } }()
    try { if let v = self._activeMintConfigs {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 4)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: ConsensusConfig_TokenConfig, rhs: ConsensusConfig_TokenConfig) -> Bool {
    if lhs.tokenID != rhs.tokenID {return false}
    if lhs.minimumFee != rhs.minimumFee {return false}
    if lhs._governors != rhs._governors {return false}
    if lhs._activeMintConfigs != rhs._activeMintConfigs {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension ConsensusConfig_ConsensusNodeConfig: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".ConsensusNodeConfig"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "minting_trust_root"),
    2: .standard(proto: "token_config_map"),
    3: .standard(proto: "governors_signature"),
    4: .standard(proto: "peer_responder_id"),
    5: .standard(proto: "client_responder_id"),
    6: .standard(proto: "block_signing_key"),
    7: .standard(proto: "block_version"),
    8: .standard(proto: "scp_message_signing_key"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._mintingTrustRoot) }()
      case 2: try { try decoder.decodeMapField(fieldType: SwiftProtobuf._ProtobufMessageMap<SwiftProtobuf.ProtobufUInt64,ConsensusConfig_TokenConfig>.self, value: &self.tokenConfigMap) }()
      case 3: try { try decoder.decodeSingularMessageField(value: &self._governorsSignature) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.peerResponderID) }()
      case 5: try { try decoder.decodeSingularStringField(value: &self.clientResponderID) }()
      case 6: try { try decoder.decodeSingularMessageField(value: &self._blockSigningKey) }()
      case 7: try { try decoder.decodeSingularUInt32Field(value: &self.blockVersion) }()
      case 8: try { try decoder.decodeSingularMessageField(value: &self._scpMessageSigningKey) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._mintingTrustRoot {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    if !self.tokenConfigMap.isEmpty {
      try visitor.visitMapField(fieldType: SwiftProtobuf._ProtobufMessageMap<SwiftProtobuf.ProtobufUInt64,ConsensusConfig_TokenConfig>.self, value: self.tokenConfigMap, fieldNumber: 2)
    }
    try { if let v = self._governorsSignature {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
    } }()
    if !self.peerResponderID.isEmpty {
      try visitor.visitSingularStringField(value: self.peerResponderID, fieldNumber: 4)
    }
    if !self.clientResponderID.isEmpty {
      try visitor.visitSingularStringField(value: self.clientResponderID, fieldNumber: 5)
    }
    try { if let v = self._blockSigningKey {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 6)
    } }()
    if self.blockVersion != 0 {
      try visitor.visitSingularUInt32Field(value: self.blockVersion, fieldNumber: 7)
    }
    try { if let v = self._scpMessageSigningKey {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 8)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: ConsensusConfig_ConsensusNodeConfig, rhs: ConsensusConfig_ConsensusNodeConfig) -> Bool {
    if lhs._mintingTrustRoot != rhs._mintingTrustRoot {return false}
    if lhs.tokenConfigMap != rhs.tokenConfigMap {return false}
    if lhs._governorsSignature != rhs._governorsSignature {return false}
    if lhs.peerResponderID != rhs.peerResponderID {return false}
    if lhs.clientResponderID != rhs.clientResponderID {return false}
    if lhs._blockSigningKey != rhs._blockSigningKey {return false}
    if lhs.blockVersion != rhs.blockVersion {return false}
    if lhs._scpMessageSigningKey != rhs._scpMessageSigningKey {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}