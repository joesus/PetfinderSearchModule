//
//  CommunicatorTests.swift
//  PetfinderSearch
//
//  Created by Joesus on 1/21/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

@testable import PetfinderSearch
import AnimalSearchModule
import XCTest

class CommunicatorTests: XCTestCase {

    let communicator = Communicator()
    var fakeSession: FakeSession!
    let url = URL(string: "https://example.com")!
    var result: Result<Data>!

    override func setUp() {
        super.setUp()

        fakeSession = FakeSession()
    }

    func testCommunicatorSessionIsSharedSession() {
        XCTAssertEqual(communicator.session, URLSession.shared,
                       "Communicators should be using the shared session")
    }

    func testCreatingFindAnimalsTask() {
        communicator.session = fakeSession
        communicator.findAnimals(at: url) { _ in }

        guard let task = fakeSession.currentDataTask as? FakeDataTask else {
            return XCTFail("Communicator should spawn a data task")
        }

        XCTAssertEqual(task.capturedUrlRequest.url, url,
                       "Finding animals should use the URL passed to the communicator")
        XCTAssertEqual(task.capturedUrlRequest.httpMethod, "GET",
                       "Finding animals should use a get request")
        XCTAssertTrue(task.resumeWasCalled,
                      "Communicator should resume the data task after creating it")
    }

    func testNewFindAnimalsTaskCancelsExistingTask() {
        communicator.session = fakeSession
        communicator.findAnimals(at: url) { _ in }

        guard let firstTask = fakeSession.currentDataTask as? FakeDataTask else {
            return XCTFail("Communicator should spawn a data task")
        }

        communicator.findAnimals(at: url) { _ in }

        XCTAssertTrue(firstTask.cancelWasCalled,
                      "Any outstanding retrieval tasks should be cancelled when a new request is made")
    }

    func testHandlingFindAnimalsNetworkFailure() {
        communicator.session = fakeSession
        communicator.findAnimals(at: url) { self.result = $0 }

        guard let task = fakeSession.currentDataTask as? FakeDataTask else {
            return XCTFail("Communicator should spawn a data task")
        }

        task.completionHandler(nil, nil, fakeNetworkError)

        XCTAssertEqual(result.error! as NSError, fakeNetworkError,
                       "The network error should be passed to the completion handler")
    }

    func testHandlingServiceFailure() {
        communicator.session = fakeSession
        communicator.findAnimals(at: url) { self.result = $0 }

        guard let task = fakeSession.currentDataTask as? FakeDataTask else {
            return XCTFail("Communicator should spawn a data task")
        }

        task.completionHandler(nil, response404, nil)

        XCTAssertTrue(result.isFailure, "Missing animal endpoint should result in a failure")
    }

    func testHandlingMissingDataWithValidResponseForFindAnimals() {
        communicator.session = fakeSession
        communicator.findAnimals(at: url) { self.result = $0 }

        guard let task = fakeSession.currentDataTask as? FakeDataTask else {
            return XCTFail("Communicator should spawn a data task")
        }

        task.completionHandler(nil, response200(), nil)

        XCTAssertTrue(result.isFailure, "Missing data and success code should result in a failure")
    }

    func testFindingAnimals() {
        let sampleData = try! JSONSerialization.data(withJSONObject: [:], options: [])

        communicator.session = fakeSession
        communicator.findAnimals(at: url) { self.result = $0 }

        guard let task = fakeSession.currentDataTask as? FakeDataTask else {
            return XCTFail("Communicator should spawn a data task")
        }

        task.completionHandler(sampleData, response200(), nil)

        XCTAssertEqual(result.value, sampleData,
                       "A successful task should pass the received data")
    }
}

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
