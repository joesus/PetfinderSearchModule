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

    func testTransformingEmptyDataToAnimalList() {
        let response = SampleExternalAnimalData.wrap(
            animals: [SampleExternalAnimalData.empty]
        )
        let animals = AnimalBuilder.buildAnimals(from: response)
        XCTAssertTrue(animals.isEmpty, "Empty data should produce empty list of animals")
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
