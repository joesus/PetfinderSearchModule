//
//  SearchServiceTests.swift
//  PetfinderSearchTests
//
//  Created by Joe Susnick on 9/30/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import XCTest
import AnimalSearchModule
import AnimalData
@testable import PetfinderSearch

class SearchServiceTests: XCTestCase {

    let communicator = FakeCommunicator()
    let service = PetfinderSearch.SearchServiceFactory().createService(
        parameters: SampleSearchParameters.usingCat,
        pageSize: 2
    ) as! PetfinderSearch.SearchService

    override func setUp() {
        super.setUp()

        service.communicator = communicator
    }

    func testServiceIndicatesSearchability() {
        XCTAssertFalse(service.searchComplete,
                       "Service should not consider a search complete by default")
    }

    func testFetchFailure() {
        var capturedError: Error?

        service.loadNextPage { result in
            capturedError = result.error
        }

        communicator.completionHandler!(.failure(SampleError()))
        XCTAssertEqual(service.nextPaginationCursor.index, 0,
                       "A failed fetch should not advance the search cursor")
        XCTAssertFalse(service.searchComplete,
                       "Service should not consider a search complete when a network error occurs")
        XCTAssertTrue(capturedError is SampleError,
                      "The service should pass through the error received from the communicator")
    }

    func testReceivingBadData() {
        var callFailed = false
        let badData = "Soup".data(using: .utf8)!

        service.loadNextPage { result in
            callFailed = result.isFailure
        }

        communicator.completionHandler!(.success(badData))

        XCTAssertEqual(service.nextPaginationCursor.index, 0,
                       "A failed fetch should not advance the search cursor")
        XCTAssertFalse(service.searchComplete,
                       "Service should not consider a search complete when a network error occurs")
        XCTAssertTrue(callFailed,
                      "The service should fail when the data is unparsable")
    }

    func testFetchingFirstPage() {
        let url = UrlBuilder.buildSearchUrl(
            searchParameters: SampleSearchParameters.usingCat,
            range: PaginationCursor(size: 2)
        )
        var capturedAnimals: [Animal]?

        service.loadNextPage { result in
            capturedAnimals = result.value
        }

        communicator.completionHandler!(
            .success(serializedPageOfCats(pageIndex: 0))
        )

        XCTAssertEqual(communicator.latestUrl, url,
                       "Service should create and pass expected URL to communicator")
        XCTAssertEqual(service.nextPaginationCursor.index, 1,
                       "A successful fetch advances the search cursor")
        XCTAssertFalse(service.searchComplete,
                       "Service should not consider a search complete when a full page of results is returned")
        XCTAssertEqual(capturedAnimals?.count, 2,
                       "A successful fetch should return a page worth of animals")
    }

    func testFetchingSubsequentPages() {
        let url = UrlBuilder.buildSearchUrl(
            searchParameters: SampleSearchParameters.usingCat,
            range: PaginationCursor(size: 2, index: 1)
        )
        var capturedAnimals: [Animal]?

        service.loadNextPage { _ in }

        communicator.completionHandler!(
            .success(serializedPageOfCats(pageIndex: 0))
        )

        service.loadNextPage { result in
            capturedAnimals = result.value
        }

        communicator.completionHandler!(
            .success(serializedPageOfCats(pageIndex: 1))
        )

        XCTAssertEqual(communicator.latestUrl, url,
                       "Service should pass a URL with an updated cursor to the communicator on subsequent calls")
        XCTAssertEqual(service.nextPaginationCursor.index, 2,
                       "Each successful fetch advances the search cursor")
        XCTAssertFalse(service.searchComplete,
                       "Service should not consider a search complete when a full page of results is returned")
        XCTAssertEqual(capturedAnimals?.count, 2,
                       "A successful fetch should return a page worth of animals")
        XCTAssertEqual(capturedAnimals?.first?.name, "Cat2",
                       "Serialized animal data is correctly translated to animals")
    }

    func testReceivingPartialPage() {
        var capturedAnimals: [Animal]?

        service.loadNextPage { result in
            capturedAnimals = result.value
        }

        communicator.completionHandler!(
            .success(
                serializedPageOfCats(pageIndex: 0, count: 1)
            )
        )

        XCTAssertTrue(service.searchComplete,
                      "Service should consider a search complete when a partial page of results is returned")
        XCTAssertEqual(service.nextPaginationCursor.index, 0,
                       "A partial page of results should not advance the search cursor")
        XCTAssertEqual(capturedAnimals?.count, 1,
                       "A partial page of results should return the number of animals found")
    }

    func testEmptyPage() {
        var capturedAnimals: [Animal]?

        service.loadNextPage { result in
            capturedAnimals = result.value
        }

        communicator.completionHandler!(
            .success(
                serializedPageOfCats(pageIndex: 0, count: 0)
            )
        )

        XCTAssertTrue(service.searchComplete,
                      "Service should consider a search complete when an empty page of results is returned")
        XCTAssertEqual(service.nextPaginationCursor.index, 0,
                       "An empty page of results should not advance the search cursor")
        XCTAssertEqual(capturedAnimals?.count, 0,
                       "An empty page of results should not pass back animals")
    }

    func testSearchNotRunWhenResultsExhausted() {
        service.loadNextPage { _ in }

        communicator.completionHandler!(
            .success(
                serializedPageOfCats(pageIndex: 0, count: 0)
            )
        )

        communicator.completionHandler = nil

        var resultCount: Int?
        service.loadNextPage { result in
            resultCount = result.value?.count
        }

        XCTAssertEqual(resultCount, 0,
                       "Service should return an empty set of animals when results are known to be exhausted")
        XCTAssertNil(communicator.completionHandler,
                     "Communicator should not request data when results are known to be exhausted")
    }

    private func serializedPageOfCats(pageIndex: Int, count: Int = 2) -> Data {
        let firstIndex = pageIndex * 2
        let animals = (0 ..< count).map {
            SampleExternalAnimalData.Cat.validCat(usingIndex: firstIndex + $0)
        }
        let json = SampleExternalAnimalData.wrap(animals: animals)

        return try! JSONSerialization.data(
            withJSONObject: json,
            options: []
        )
    }

}
