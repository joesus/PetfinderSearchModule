//
//  NetworkFakes.swift
//  PetfinderSearchTests
//
//  Created by Joe Susnick on 9/30/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import Foundation

class FakeDataTask: URLSessionDataTask {

    let capturedUrlRequest: URLRequest
    let completionHandler: (Data?, URLResponse?, Error?) -> Void

    init(request: URLRequest, handler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        capturedUrlRequest = request
        completionHandler = handler
    }

    var resumeWasCalled = false
    override func resume() {
        resumeWasCalled = true
    }

    var cancelWasCalled = false
    override func cancel() {
        cancelWasCalled = true
    }

}

class FakeSession: URLSession {

    var currentDataTask: URLSessionDataTask?

    override func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
        ) -> URLSessionDataTask {

        let fakeDataTask = FakeDataTask(request: request, handler: completionHandler)
        currentDataTask = fakeDataTask

        return fakeDataTask
    }

}
