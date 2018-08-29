// Copyright DApps Platform Inc. All rights reserved.

import XCTest
@testable import Trust
import BigInt

class GasLimitConfigurationTests: XCTestCase {
    
    func testDefault() {
        XCTAssertEqual(BigInt(90000), GasLimitConfiguration.default)
        XCTAssertEqual(BigInt(21000), GasLimitConfiguration.min)
        XCTAssertEqual(BigInt(600000), GasLimitConfiguration.max)
    }
}
