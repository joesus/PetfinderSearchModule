//
//  NetworkTestingConstants.swift
//  PetfinderSearchTests
//
//  Created by Joe Susnick on 9/30/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import Foundation

let fakeNetworkError = NSError(domain: "CatPalaceTesting", code: 101, userInfo: nil)

let response404 = HTTPURLResponse(
    url: URL(string: "http://example.com")!,
    statusCode: 404,
    httpVersion: nil,
    headerFields: nil
)

func response200(url: URL = URL(string: "http://example.com")!) -> HTTPURLResponse {
    return HTTPURLResponse(
        url: url,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
        )!
}
