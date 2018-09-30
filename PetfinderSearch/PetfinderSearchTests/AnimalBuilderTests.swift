//
//  AnimalBuilderTests.swift
//  PetfinderSearchTests
//
//  Created by Joe Susnick on 9/30/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import XCTest
@testable import PetfinderSearch

class AnimalBuilderTests: XCTestCase {

    func testMissingRoot() {
        let animals = AnimalBuilder.buildAnimals(from: [String: Any]())

        XCTAssertTrue(animals.isEmpty, "A response with an empty root should not produce a list of animals")
    }

    func testEmptyResponse() {
        let animals = AnimalBuilder.buildAnimals(from: SampleExternalAnimalData.emptyResponse)

        XCTAssertTrue(animals.isEmpty, "A empty response should not produce a list of animals")
    }

    func testMissingOuterList() {
        let animals = AnimalBuilder.buildAnimals(from: SampleExternalAnimalData.emptyOuterList)

        XCTAssertTrue(animals.isEmpty, "A response with an empty outer list should not produce a list of animals")
    }

    func testMissingInnerList() {
        let animals = AnimalBuilder.buildAnimals(from: SampleExternalAnimalData.emptyInnerList)

        XCTAssertTrue(animals.isEmpty, "A response with an empty inner list should not produce a list of animals")
    }

    func testBuildingAnimalsFromMinimalAnimalData() {
        let response = SampleExternalAnimalData.wrap(
            animals: [
                SampleExternalAnimalData.Cat.valid,
                SampleExternalAnimalData.Cat.anotherValid
            ]
        )
        let animals = AnimalBuilder.buildAnimals(from: response)

        guard animals.count == 2,
            let animalOne = animals.first,
            let animalTwo = animals.last
            else {
                return XCTFail("There should be two valid animals")
        }

        XCTAssertEqual(animalOne.name, "CatOne", "First animal name was set incorrectly")
        XCTAssertEqual(animalOne.species, .cat, "First animal species was set incorrectly")

        XCTAssertEqual(animalTwo.name, "CatTwo", "Second animal name was set incorrectly")
        XCTAssertEqual(animalTwo.species, .cat, "Second animal species was set incorrectly")
    }

    func testBuildingDog() {
        let response = SampleExternalAnimalData.wrap(
            animals: [SampleExternalAnimalData.Dog.valid]
        )
        let animals = AnimalBuilder.buildAnimals(from: response)

        guard let dog = animals.first else {
            return XCTFail("Should build a dog from a valid response")
        }

        XCTAssertEqual(dog.name, "DogOne", "Animal name was set incorrectly")
        XCTAssertEqual(dog.species, .dog, "Animal species was set incorrectly")
    }
}
