//
//  SearchCommunicator.swift
//  PetfinderSearch
//
//  Created by Joe Susnick on 9/30/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import AnimalData
import AnimalSearchModule

class SearchCommunicator {

    var session: URLSession = .shared
    private weak var currentTask: URLSessionDataTask?

    func findAnimals(at url: URL, completion: @escaping (Result<Data>) -> Void) {
        currentTask?.cancel()

        currentTask = session.dataTask(with: url) {
            potentialData, potentialResponse, potentialError in

            guard potentialError == nil else {
                return completion(.failure(potentialError))
            }

            guard let response = potentialResponse as? HTTPURLResponse,
                response.statusCode == 200,
                let data = potentialData
                else {
                    return completion(.failure(nil))
            }

            return completion(.success(data))
        }

        currentTask?.resume()
    }
}
