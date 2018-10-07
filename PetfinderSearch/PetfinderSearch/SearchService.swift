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
    var communicator = SearchCommunicator()
    var parameters: SearchParameters
    var nextPaginationCursor: PaginationCursor
    private(set) var searchComplete = false

    init(parameters: SearchParameters, pageSize: Int) {
        self.parameters = parameters
        nextPaginationCursor = PaginationCursor(size: pageSize)
    }

    public func loadNextPage(completion: @escaping (Result<[Animal]>) -> Void) {
        guard !searchComplete else {
            return completion(.success([]))
        }

        let url = UrlBuilder.buildSearchUrl(
            searchParameters: parameters,
            range: nextPaginationCursor
        )

        communicator.findAnimals(at: url) { [weak self] result in
            switch result {
            case .success(let rawAnimalData):
                do {
                    guard let json = try JSONSerialization.jsonObject(
                        with: rawAnimalData,
                        options: []
                        ) as? [String: Any]
                        else {
                            return completion(.failure(nil))
                    }

                    let animals = AnimalBuilder.buildAnimals(from: json)

                    if let pageSize = self?.nextPaginationCursor.size,
                        animals.count >= pageSize,
                        let nextCursor = self?.nextPaginationCursor.nextPage() {

                        self?.nextPaginationCursor = nextCursor
                    }
                    else {
                        self?.searchComplete = true
                    }

                    return completion(.success(animals))
                }
                catch let error {
                    return completion(.failure(error))
                }

            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
}
