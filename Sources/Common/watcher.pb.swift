// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: watcher.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

// Copyright (c) 2018-2022 The MobileCoin Foundation

// MUST BE KEPT IN SYNC WITH RUST CODE!

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

//// The result code indicating whether the timestamp was found, can be tried again later, or will
//// never be found with the current configuration of the service offering timestamps via the watcher.
public enum Watcher_TimestampResultCode: SwiftProtobuf.Enum {
  public typealias RawValue = Int

  //// The default value for fixed32 is intentionally unused to avoid omitting this field.
  case unusedField // = 0

  //// The timestamp was found for at least one watched consensus validator.
  case timestampFound // = 1

  //// The timestamp was not found, but the watcher sync is behind for at least one watched consensus
  //// validator. It is possible that the timestamp will be available once the watcher is fully synced.
  case watcherBehind // = 2

  //// The timestamp cannot be known with the service's current watcher configuration.
  //// In this case, the watcher must be restarted to include in its watched URLs a sufficient
  //// set of consensus validators so that at least one of those validators participated in
  //// consensus for every block.
  case unavailable // = 3

  //// A WatcherDBError occurred when getting signatures and timestamps.
  case watcherDatabaseError // = 4

  //// A timestamp was requested for a block index out of bounds, e.g. 0.
  case blockIndexOutOfBounds // = 5
  case UNRECOGNIZED(Int)

  public init() {
    self = .unusedField
  }

  public init?(rawValue: Int) {
    switch rawValue {
    case 0: self = .unusedField
    case 1: self = .timestampFound
    case 2: self = .watcherBehind
    case 3: self = .unavailable
    case 4: self = .watcherDatabaseError
    case 5: self = .blockIndexOutOfBounds
    default: self = .UNRECOGNIZED(rawValue)
    }
  }

  public var rawValue: Int {
    switch self {
    case .unusedField: return 0
    case .timestampFound: return 1
    case .watcherBehind: return 2
    case .unavailable: return 3
    case .watcherDatabaseError: return 4
    case .blockIndexOutOfBounds: return 5
    case .UNRECOGNIZED(let i): return i
    }
  }

}

#if swift(>=4.2)

extension Watcher_TimestampResultCode: CaseIterable {
  // The compiler won't synthesize support with the UNRECOGNIZED case.
  public static let allCases: [Watcher_TimestampResultCode] = [
    .unusedField,
    .timestampFound,
    .watcherBehind,
    .unavailable,
    .watcherDatabaseError,
    .blockIndexOutOfBounds,
  ]
}

#endif  // swift(>=4.2)

#if swift(>=5.5) && canImport(_Concurrency)
extension Watcher_TimestampResultCode: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension Watcher_TimestampResultCode: SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "UnusedField"),
    1: .same(proto: "TimestampFound"),
    2: .same(proto: "WatcherBehind"),
    3: .same(proto: "Unavailable"),
    4: .same(proto: "WatcherDatabaseError"),
    5: .same(proto: "BlockIndexOutOfBounds"),
  ]
}
