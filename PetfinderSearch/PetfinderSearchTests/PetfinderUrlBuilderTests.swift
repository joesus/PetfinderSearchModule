//
//  UrlBuilderTests.swift
//  PetfinderSearchTests
//
//  Created by Joe Susnick on 10/7/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import PetfinderSearch
import AnimalSearchModule
import XCTest

class UrlBuilderTests: XCTestCase {

    func testWellKnownValues() {
        XCTAssertEqual(UrlBuilder.CommonValues.hostname, "api.petfinder.com",
                       "There should be a known hostname for building Petfinder urls")
        XCTAssertEqual(UrlBuilder.CommonValues.apiKey, "APIKEY",
                       "There should be a well known api key for building Petfinder urls")
        XCTAssertEqual(UrlBuilder.CommonValues.outputFormat, "json",
                       "There should be a well known format for building Petfinder urls")
    }

    func testMethodPaths() {
        XCTAssertEqual(UrlBuilder.MethodPaths.search, "/pet.find",
                       "Builder should know the API method for searching")
    }

    func testBaseQueryItemKeys() {
        XCTAssertEqual(
            UrlBuilder.BaseQueryItemKeys.apiKey,
            "key",
            "Petfinder query items should have well defined keys"
        )
        XCTAssertEqual(
            UrlBuilder.BaseQueryItemKeys.outputFormat,
            "format",
            "Petfinder query items should have well defined keys"
        )
        XCTAssertEqual(
            UrlBuilder.BaseQueryItemKeys.recordLength,
            "output",
            "Petfinder query items should have well defined keys"
        )
    }

    func testBaseQueryItems() {
        let queryItems = UrlBuilder.baseQueryItems
        let expectedItems: Set = [
            URLQueryItem(
                name: UrlBuilder.BaseQueryItemKeys.apiKey,
                value: UrlBuilder.CommonValues.apiKey
            ),
            URLQueryItem(
                name: UrlBuilder.BaseQueryItemKeys.outputFormat,
                value: UrlBuilder.CommonValues.outputFormat
            )
        ]

        XCTAssertEqual(queryItems, expectedItems,
                       "Base query items should contain api key and output format")
    }

    func testBuildingMinimalUrlForFindingPets() {
        let searchParameters = SampleSearchParameters.zipCodeOnly
        let cursor = PaginationCursor(size: 20)
        let url = UrlBuilder.buildSearchUrl(
            searchParameters: searchParameters,
            range: cursor
        )

        validateBaseUrl(url, withPath: UrlBuilder.MethodPaths.search)

        guard let queryItems = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
            )?
            .queryItems
            else {
                return XCTFail("Should be able to get query items from url")
        }

        let expectedQueryItems = UrlBuilder.buildPagingQueryItems(for: cursor)
            .union(SearchQueryItemBuilder.build(from: searchParameters))
            .union(UrlBuilder.baseQueryItems)
            .union([RecordLength.short.queryItem])

        XCTAssertEqual(
            Set(queryItems),
            expectedQueryItems,
            "Builder should use query items from minimal search parameters, pagination cursor, and base query items"
        )
    }

    func testBuildingUrlForFindingPetsWithMaximalSearchOptions() {
        let searchParameters = SampleSearchParameters.usingDog
        let cursor = PaginationCursor(size: 20)
        let url = UrlBuilder.buildSearchUrl(
            searchParameters: searchParameters,
            range: cursor
        )

        validateBaseUrl(url, withPath: UrlBuilder.MethodPaths.search)

        guard let queryItems = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
            )?.queryItems
            else {
                return XCTFail("Should be able to get query items from url")
        }

        let expectedQueryItems = UrlBuilder.buildPagingQueryItems(for: cursor)
            .union(SearchQueryItemBuilder.build(from: searchParameters))
            .union(UrlBuilder.baseQueryItems)
            .union([RecordLength.short.queryItem])

        XCTAssertEqual(
            Set(queryItems),
            expectedQueryItems,
            "Builder should use query items from maximal search parameters, pagination cursor, and base query items"
        )
    }

    private func validateBaseUrl(
        _ url: URL,
        withPath path: String?,
        inFile file: StaticString = #file,
        atLine line: UInt = #line
    ) {

        XCTAssertEqual(
            url.scheme,
            "https",
            "URL should use a secure protocol",
            file: file,
            line: line
        )
        XCTAssertEqual(
            url.host,
            UrlBuilder.CommonValues.hostname,
            "URL should use pet finder host name",
            file: file,
            line: line
        )
        XCTAssertNil(
            url.port,
            "URL should not override the default port",
            file: file,
            line: line
        )
        XCTAssertEqual(
            url.path,
            path ?? "",
            "URL path should be root",
            file: file,
            line: line
        )
    }

}
