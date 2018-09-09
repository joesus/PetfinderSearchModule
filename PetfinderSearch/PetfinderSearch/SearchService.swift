//
//  SearchService.swift
//  PetfinderSearch
//
//  Created by Joe Susnick on 9/9/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import AnimalData
import AnimalSearchModule

public class SearchService: AnimalSearchModule.SearchService {
    var parameters: SearchParameters
    var paginationCursor: PaginationCursor

    init(parameters: SearchParameters, pageSize: Int) {
        self.parameters = parameters
        paginationCursor = PaginationCursor(size: pageSize)
    }

    public func loadNextPage(completion: (Result<[Animal]>) -> Void) {
        // TODO
    }
}
