//
//  FakeCommunicator.swift
//  PetfinderSearchTests
//
//  Created by Joe Susnick on 9/30/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import AnimalSearchModule
@testable import PetfinderSearch

class FakeCommunicator: SearchCommunicator {
    var completionHandler: ((Result<Data>) -> Void)?
    var latestUrl: URL?

    override func findAnimals(at url: URL, completion: @escaping (Result<Data>) -> Void) {
        completionHandler = completion
        latestUrl = url
    }
}
