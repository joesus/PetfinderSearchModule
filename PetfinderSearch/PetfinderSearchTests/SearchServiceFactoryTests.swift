//
//  SearchServiceFactoryTests.swift
//  PetfinderSearchTests
//
//  Created by Joe Susnick on 9/9/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import XCTest
import AnimalSearchModule
@testable import PetfinderSearch

class SearchServiceFactoryTests: XCTestCase {

    func testFactoryProvidesSearchService() {
        let abstractService = PetfinderSearch.SearchServiceFactory().createService(
            parameters: SampleSearchParameters.minimalSearchOptions,
            pageSize: 1
        )

        guard let concreteService = abstractService as? PetfinderSearch.SearchService else {
            return XCTFail("Factory should return the correct concrete service type")
        }

        let expectedCursor = PaginationCursor(size: 1)
        XCTAssertEqual(concreteService.paginationCursor, expectedCursor,
                       "Factory should provide service with correctly configured cursor")
        XCTAssertEqual(concreteService.paginationCursor.index, 0,
                       "Factory should start on the first page")

        XCTAssertEqual(
            concreteService.parameters,
            SampleSearchParameters.minimalSearchOptions,
            "Factory should provide service with correct search parameters"
        )
    }
}
