//
//  RecordLength.swift
//  PetfinderSearch
//
//  Created by Joe Susnick on 9/16/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import Foundation

enum RecordLength: CustomStringConvertible {
    case short, long

    static let queryItemKey = "output"

    var description: String {
        switch self {
        case .short:
            return "basic"
        case .long:
            return "full"
        }
    }

    var queryItem: URLQueryItem {
        return URLQueryItem(
            name: RecordLength.queryItemKey,
            value: description
        )
    }
}
