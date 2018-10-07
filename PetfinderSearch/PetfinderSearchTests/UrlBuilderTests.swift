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

    func testWithMinimalSearchParameters() {
        let url = UrlBuilder.buildSearchUrl(
            searchParameters: SampleSearchParameters.zipCodeOnly,
            range: PaginationCursor(size: 10)
        )

        let queryItems = validateBaseUrl(url)

        XCTAssertFalse(queryItems.contains { $0.name == "species" },
                       "Url should contain a query item for the species")

        guard let offsetItem = queryItems.first(where: { $0.name == "offset" }),
            let countItem = queryItems.first(where: { $0.name == "count" })
            else {
                return XCTFail("Query items should contain information about paging")
        }

        XCTAssertEqual(offsetItem.value, "0",
                       "Pagination cursor should be passed correctly")
        XCTAssertEqual(countItem.value, "10",
                       "Pagination cursor should be passed correctly")
    }

    func testWithDogSpecies() {
        let url = UrlBuilder.buildSearchUrl(
            searchParameters: SampleSearchParameters.usingDog,
            range: PaginationCursor(size: 20, index: 2)
        )

        let queryItems = validateBaseUrl(url)

        if let speciesItem = queryItems.first(where: { $0.name == "animal" }) {
            XCTAssertEqual(speciesItem.value, "Dog",
                           "Species should be passed correctly")
        }
        else {
            XCTFail("Species should be passed correctly")
        }

        guard let offsetItem = queryItems.first(where: { $0.name == "offset" }),
            let countItem = queryItems.first(where: { $0.name == "count" })
            else {
                return XCTFail("Query items should contain information about paging")
        }

        XCTAssertEqual(offsetItem.value, "40",
                       "Pagination cursor should be passed correctly")
        XCTAssertEqual(countItem.value, "20",
                       "Pagination cursor should be passed correctly")
    }

    func testWithCatSpecies() {
        let url = UrlBuilder.buildSearchUrl(
            searchParameters: SampleSearchParameters.usingCat,
            range: PaginationCursor(size: 20, index: 2)
        )

        let queryItems = validateBaseUrl(url)

        if let speciesItem = queryItems.first(where: { $0.name == "animal" }) {
            XCTAssertEqual(speciesItem.value, "Cat",
                           "Species should be passed correctly")
        }
        else {
            XCTFail("Species should be passed correctly")
        }
    }

    private func validateBaseUrl(
        _ url: URL,
        inFile file: StaticString = #file,
        atLine line: UInt = #line
    ) -> [URLQueryItem] {

        XCTAssertEqual(
            url.scheme,
            "https",
            "URL should use a secure protocol",
            file: file,
            line: line
        )
        XCTAssertEqual(
            url.host,
            "api.petfinder.com",
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
            "/pet.find",
            "URL path should be the search path",
            file: file,
            line: line
        )

        let components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )

        let queryItems = components?.queryItems ?? []

        XCTAssertEqual(queryItems["key"]?.value, "APIKEY",
                       "Query items should contain an api key")
        XCTAssertEqual(queryItems["format"]?.value, "json",
                       "Query items should contain a response format")
        XCTAssertEqual(queryItems["output"]?.value, "short",
                       "Query items should contain a record length")

        return queryItems
    }

}

extension Array where Element == URLQueryItem {

    subscript(index: String) -> URLQueryItem? {
        return first { $0.name == index }
    }

}
