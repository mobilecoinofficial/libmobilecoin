// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: report.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

// Copyright (c) 2018-2021 The MobileCoin Foundation

/// MUST BE KEPT IN SYNC WITH RUST CODE!

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

public struct Report_ReportRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct Report_ReportResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  //// All available reports
  public var reports: [Report_Report] = []

  //// The X509 chain from the fog authority to the signer
  public var chain: [Data] = []

  //// The signature over the report list made by the last cert in the chain
  public var signature: Data = Data()

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct Report_Report {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  //// The fog_report_id of users with which this pubkey should be used
  //// This should match fog_report_id in Bob's public_address
  public var fogReportID: String = String()

  //// The IAS report of the Fog Ingest node.
  ////
  //// This report structure includes the ingest server's ingress public key.
  public var report: External_VerificationReport {
    get {return _report ?? External_VerificationReport()}
    set {_report = newValue}
  }
  /// Returns true if `report` has been explicitly set.
  public var hasReport: Bool {return self._report != nil}
  /// Clears the value of `report`. Subsequent reads from it will return its default value.
  public mutating func clearReport() {self._report = nil}

  //// The first block index in which a well-formed client may not use this public key.
  //// This is the same semantic as tombstone block of a Tx, which is the first block index
  //// in which the Tx cannot appear.
  ////
  //// The tombstone block of a Tx formed using this public key should not exceed this number.
  //// This constraint is enforced in the TransactionBuilder.
  ////
  //// This number is likely to be e.g. next block index + 50,
  //// and may be updated (larger) if you come back to the server later.
  public var pubkeyExpiry: UInt64 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _report: External_VerificationReport? = nil
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "report"

extension Report_ReportRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".ReportRequest"
  public static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Report_ReportRequest, rhs: Report_ReportRequest) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Report_ReportResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".ReportResponse"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "reports"),
    2: .same(proto: "chain"),
    3: .same(proto: "signature"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.reports) }()
      case 2: try { try decoder.decodeRepeatedBytesField(value: &self.chain) }()
      case 3: try { try decoder.decodeSingularBytesField(value: &self.signature) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.reports.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.reports, fieldNumber: 1)
    }
    if !self.chain.isEmpty {
      try visitor.visitRepeatedBytesField(value: self.chain, fieldNumber: 2)
    }
    if !self.signature.isEmpty {
      try visitor.visitSingularBytesField(value: self.signature, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Report_ReportResponse, rhs: Report_ReportResponse) -> Bool {
    if lhs.reports != rhs.reports {return false}
    if lhs.chain != rhs.chain {return false}
    if lhs.signature != rhs.signature {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Report_Report: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".Report"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "fog_report_id"),
    2: .same(proto: "report"),
    3: .standard(proto: "pubkey_expiry"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.fogReportID) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._report) }()
      case 3: try { try decoder.decodeSingularFixed64Field(value: &self.pubkeyExpiry) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.fogReportID.isEmpty {
      try visitor.visitSingularStringField(value: self.fogReportID, fieldNumber: 1)
    }
    if let v = self._report {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    }
    if self.pubkeyExpiry != 0 {
      try visitor.visitSingularFixed64Field(value: self.pubkeyExpiry, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Report_Report, rhs: Report_Report) -> Bool {
    if lhs.fogReportID != rhs.fogReportID {return false}
    if lhs._report != rhs._report {return false}
    if lhs.pubkeyExpiry != rhs.pubkeyExpiry {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
