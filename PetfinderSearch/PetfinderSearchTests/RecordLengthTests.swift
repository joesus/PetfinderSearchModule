//
//  RecordLengthTests.swift
//  PetfinderSearchTests
//
//  Created by Joe Susnick on 9/16/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

@testable import PetfinderSearch
import XCTest

class RecordLengthTests: XCTestCase {
    
    func testAllCases() {
        switch RecordLength.short {
        case .short, .long:
            break
        }
    }

    func testStringRepresentation() {
        XCTAssertEqual(RecordLength.short.description, "basic",
                       "The string representation should be 'basic'")
        XCTAssertEqual(RecordLength.long.description, "full",
                       "The string representation should be 'full'")
    }

    func testQueryItem() {
        var expected = URLQueryItem(
            name: RecordLength.queryItemKey,
            value: RecordLength.short.description
        )

        XCTAssertEqual(RecordLength.short.queryItem, expected,
                       "A record length should be expressible as a URL query item")

        expected = URLQueryItem(
            name: RecordLength.queryItemKey,
            value: RecordLength.long.description
        )

        XCTAssertEqual(RecordLength.long.queryItem, expected,
                       "A record length should be expressible as a URL query item")
    }

}
