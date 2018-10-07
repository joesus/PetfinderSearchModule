//
//  SearchServiceFactory.swift
//  PetfinderSearch
//
//  Created by Joe Susnick on 9/9/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import Foundation
import AnimalSearchModule

public class SearchServiceFactory: AnimalSearchModule.SearchServiceFactory {

    public init() {}

    public func createService(
        parameters: SearchParameters,
        pageSize: Int
        ) -> AnimalSearchModule.SearchService {

        return PetfinderSearch.SearchService(
            parameters: parameters,
            pageSize: pageSize
        )
    }

}
