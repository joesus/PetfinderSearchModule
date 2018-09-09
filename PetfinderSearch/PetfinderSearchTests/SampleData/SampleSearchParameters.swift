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

    static let minimalSearchOptions = SearchParameters(
        zipCode: zipCode,
        species: .dog
    )
}
