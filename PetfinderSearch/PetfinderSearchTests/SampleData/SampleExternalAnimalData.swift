// swiftlint:disable line_length
//
//  SampleExternalAnimalData.swift
//  PetfinderSearch
//
//  Created by Joesus on 1/29/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import PetfinderSearch

enum SampleExternalAnimalData {

    static func wrap(animals: [[String: Any]]) -> [String: Any] {
        return [
            "petfinder": [
                "pets": [
                    "pet": animals
                ]
            ]
        ]
    }

    static let empty: [String: Any] = [:]

    enum Cat {
        static let valid: [String: Any] = [
            "name": [
                "$t": "CatOne"
            ],
            "animal": [
                "$t": "cat"
            ]
        ]
        static let anotherValid: [String: Any] = [
            "name": [
                "$t": "CatTwo"
            ],
            "animal": [
                "$t": "cat"
            ]
        ]
        static let missingName: [String: Any] = [
            "animal": [
                "$t": "cat"
            ]
        ]
    }

    enum Dog {
        static let valid: [String: Any] = [
            "name": [
                "$t": "DogOne"
            ],
            "animal": [
                "$t": "dog"
            ]
        ]
    }

}
