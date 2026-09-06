import XCTest
import LibMobileCoinHTTP
import LibMobileCoinCommon

/// Imports one class from each file, so a packaging failure fails the suite.
final class HTTPClientImports: XCTestCase {
    func testAttestRestClient() throws {
        let client = Attest_AttestedApiRestClient()
        XCTAssertNotNil(client)
    }
    
    func testConsensusRestClient() throws {
        let client = ConsensusClient_ConsensusClientAPIRestClient()
        XCTAssertNotNil(client)
    }
    
    func testConsensusCommon() throws {
        let client = ConsensusCommon_BlockchainAPIRestClient()
        XCTAssertNotNil(client)
    }
    
    func testLedgerRestClient() throws {
        let client = FogLedger_FogMerkleProofAPIRestClient()
        XCTAssertNotNil(client)
    }
    
    func testReportRestClient() throws {
        let client = Report_ReportAPIRestClient()
        XCTAssertNotNil(client)
    }
    
    func testFogViewRestClient() throws {
        let client = FogView_FogViewAPIRestClient()
        XCTAssertNotNil(client)
    }
}
