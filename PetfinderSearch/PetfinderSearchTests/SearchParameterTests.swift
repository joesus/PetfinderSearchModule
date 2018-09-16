//
//  SearchParameterTests.swift
//  PetfinderSearchTests
//
//  Created by Joe Susnick on 8/26/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

@testable import PetfinderSearch
import XCTest

class SearchParameterTests: XCTestCase {

    func testSearchParameterKeys() {
        XCTAssertEqual(SearchQueryItemKeys.location, "location",
                       "There should be a defined name for each key")
        XCTAssertEqual(SearchQueryItemKeys.species, "animal",
                       "There should be a defined name for each key")
    }

    func testCreatingQueryItemsWithoutSpecies() {
        let queryItems = SearchQueryItemBuilder.build(
            from: SampleSearchParameters.zipCodeOnly
        )

        XCTAssertEqual(queryItems.count, 1,
                       "Should create correct number of query items")

        guard let locationItem = queryItems
            .first(where: { $0.name == SearchQueryItemKeys.location })
            else {
                return XCTFail("Query items should include an entry for location")
        }

        XCTAssertEqual(locationItem.value, SampleSearchParameters.zipCode.rawValue,
                       "Should create location query item with the correct value")
    }

    func testCreatingQueryItemsWithDog() {
        let queryItems = SearchQueryItemBuilder.build(
            from: SampleSearchParameters.usingDog
        )

        XCTAssertEqual(queryItems.count, 2,
                       "Should create correct number of query items")

        guard let locationItem = queryItems
            .first(where: { $0.name == SearchQueryItemKeys.location })
            else {
                return XCTFail("Query items should include an entry for location")
        }

        XCTAssertEqual(locationItem.value, SampleSearchParameters.zipCode.rawValue,
                       "Should create location query item with the correct value")

        guard let speciesItem = queryItems
            .first(where: { $0.name == SearchQueryItemKeys.species })
            else {
                return XCTFail("Query items should include an entry for species")
        }

        XCTAssertEqual(speciesItem.value, "dog",
                       "Should create species query item with the correct value")
    }

    func testCreatingQueryItemsWithCat() {
        let queryItems = SearchQueryItemBuilder.build(
            from: SampleSearchParameters.usingCat
        )

        XCTAssertEqual(queryItems.count, 2,
                       "Should create correct number of query items")

        guard let locationItem = queryItems
            .first(where: { $0.name == SearchQueryItemKeys.location })
            else {
                return XCTFail("Query items should include an entry for location")
        }

        XCTAssertEqual(locationItem.value, SampleSearchParameters.zipCode.rawValue,
                       "Should create location query item with the correct value")

        guard let speciesItem = queryItems
            .first(where: { $0.name == SearchQueryItemKeys.species })
            else {
                return XCTFail("Query items should include an entry for species")
        }

        XCTAssertEqual(speciesItem.value, "cat",
                       "Should create species query item with the correct value")
    }

//
//    func testParametersDoNotRequireSpecies() {
//        XCTAssertNil(SampleSearchParameters.minimalSearchOptions.species,
//                     "Parameters do not require a species")
//    }
//
//    func testParametersMayIncludeSpecies() {
//        let parameters = PetFinderSearchParameters(
//            zipCode: SampleSearchParameters.zipCode,
//            species: PetfinderAnimalSpecies.cat
//        )
//        XCTAssertTrue(parameters.species == PetfinderAnimalSpecies.cat,
//                      "Parameters may include a species")
//
//        let queryItems = Set(parameters.queryItems)
//        let expected = Set(
//            [
//                SampleSearchParameters.zipCodeQueryItem,
//                SampleSearchParameters.speciesQueryItem
//            ]
//        )
//        XCTAssertEqual(queryItems, expected,
//                       "Parameters should provide query items")
//    }
//
//    func testParametersDoNotRequireAnimalBreed() {
//        XCTAssertNil(SampleSearchParameters.minimalSearchOptions.breed,
//                     "Parameters do not require a breed")
//    }
//
//    func testParametersMayIncludeBreed() {
//        let parameters = PetFinderSearchParameters(
//            zipCode: SampleSearchParameters.zipCode,
//            breed: "egyptian"
//        )
//        XCTAssertEqual(parameters.breed, "egyptian",
//                       "Parameters may include a breed")
//
//        let queryItems = Set(parameters.queryItems)
//        let expected = Set(
//            [
//                SampleSearchParameters.zipCodeQueryItem,
//                SampleSearchParameters.breedQueryItem
//            ]
//        )
//        XCTAssertEqual(queryItems, expected,
//                       "Parameters should provide query items")
//    }
//
//    func testParametersDoNotRequireAnimalSize() {
//        XCTAssertNil(SampleSearchParameters.minimalSearchOptions.size,
//                     "Parameters do not require a size")
//    }
//
//    func testParametersMayIncludeAnimalSize() {
//        let parameters = PetFinderSearchParameters(
//            zipCode: SampleSearchParameters.zipCode,
//            size: .medium
//        )
//        XCTAssertEqual(parameters.size, .medium,
//                       "Parameters may include a size")
//
//        let queryItems = Set(parameters.queryItems)
//        let expected = Set(
//            [
//                SampleSearchParameters.zipCodeQueryItem,
//                SampleSearchParameters.sizeQueryItem
//            ]
//        )
//        XCTAssertEqual(queryItems, expected,
//                       "Parameters should provide query items")
//    }
//
//    func testParametersDoNotRequireAnimalAge() {
//        XCTAssertNil(SampleSearchParameters.minimalSearchOptions.age,
//                     "Parameters do not require an age")
//    }
//
//    func testParametersMayIncludeAnimalAge() {
//        let parameters = PetFinderSearchParameters(
//            zipCode: SampleSearchParameters.zipCode,
//            age: .adult
//        )
//        XCTAssertEqual(parameters.age, .adult,
//                       "Parameters may include an age")
//
//        let queryItems = Set(parameters.queryItems)
//        let expected = Set(
//            [
//                SampleSearchParameters.zipCodeQueryItem,
//                SampleSearchParameters.ageQueryItem
//            ]
//        )
//        XCTAssertEqual(queryItems, expected,
//                       "Parameters should provide query items")
//    }
//
//    func testParametersDoNotRequireAnimalSex() {
//        XCTAssertNil(SampleSearchParameters.minimalSearchOptions.sex,
//                     "Parameters do not require a sex")
//    }
//
//    func testParametersMayIncludeAnimalSex() {
//        let parameters = PetFinderSearchParameters(
//            zipCode: SampleSearchParameters.zipCode,
//            sex: .female
//        )
//        XCTAssertEqual(parameters.sex, .female,
//                       "Parameters may include a sex")
//
//        let queryItems = Set(parameters.queryItems)
//        let expected = Set(
//            [
//                SampleSearchParameters.zipCodeQueryItem,
//                SampleSearchParameters.sexQueryItem
//            ]
//        )
//        XCTAssertEqual(queryItems, expected,
//                       "Parameters should provide query items")
//    }
//
//    func testCreatingWithAllFields() {
//        let parameters = SampleSearchParameters.fullSearchOptions
//
//        XCTAssertEqual(parameters.zipCode, SampleSearchParameters.zipCode,
//                       "Parameters should be created with provided zip code")
//        XCTAssertTrue(parameters.species == PetfinderAnimalSpecies.cat,
//                      "Parameters should be created with provided species")
//        XCTAssertEqual(parameters.breed, "egyptian",
//                       "Parameters should be created with provided breed")
//        XCTAssertEqual(parameters.size, .medium,
//                       "Parameters should be created with provided size")
//        XCTAssertEqual(parameters.age, .adult,
//                       "Parameters should be created with provided age")
//        XCTAssertEqual(parameters.sex, .female,
//                       "Parameters should be created with provided sex")
//
//        let queryItems = Set(parameters.queryItems)
//        let expected = Set(
//            [
//                SampleSearchParameters.zipCodeQueryItem,
//                SampleSearchParameters.speciesQueryItem,
//                SampleSearchParameters.breedQueryItem,
//                SampleSearchParameters.ageQueryItem,
//                SampleSearchParameters.sizeQueryItem,
//                SampleSearchParameters.sexQueryItem
//            ]
//        )
//        XCTAssertEqual(queryItems, expected,
//                       "Parameters should provide query items")
//    }

}
