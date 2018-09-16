//
//  SampleSearchParameters.swift
//  PetfinderSearchTests
//
//  Created by Joe Susnick on 8/26/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import AnimalData
import AnimalSearchModule

enum SampleSearchParameters {
    static let zipCode = ZipCode(rawValue: "80202")!

    static let zipCodeOnly = SearchParameters(zipCode: zipCode)

    static let usingDog = SearchParameters(
        zipCode: zipCode,
        species: .dog
    )

    static let usingCat = SearchParameters(
        zipCode: zipCode,
        species: .cat
    )
}
