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

    static let emptyResponse = ["petfinder": [String: Any]()]
    static let emptyOuterList = [
        "petfinder": [
            "pets": [String: Any]()
        ]
    ]
    static let emptyInnerList = [
        "petfinder": [
            "pets": [
                "pet": []
            ]
        ]
    ]

    static func wrap(animals: [[String: Any]]) -> [String: Any] {
        return [
            "petfinder": [
                "pets": [
                    "pet": animals
                ]
            ]
        ]
    }

    enum Cat {
        static let missingName: [String: Any] = [
            "animal": [
                "$t": "cat"
            ]
        ]

        static func validCat(usingIndex index: Int) -> [String: Any] {
            return [
                "name": [
                    "$t": "Cat\(index)"
                ],
                "animal": [
                    "$t": "cat"
                ]
            ]
        }
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

    enum NonAnimal {
        static let missingSpecies: [String: Any] = [
            "name": [
                "$t": "NonAnimal"
            ]
        ]
        static let unknownSpecies: [String: Any] = [
            "name": [
                "$t": "NonAnimal"
            ],
            "animal": [
                "$t": "planet"
            ]
        ]
    }

}
