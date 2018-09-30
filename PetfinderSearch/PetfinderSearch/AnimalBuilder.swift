//
//  AnimalBuilder.swift
//  PetfinderSearch
//
//  Created by Joe Susnick on 9/30/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import AnimalData

enum AnimalBuilder {

    static func buildAnimals(from response: [String: Any]) -> [Animal] {
        guard let root = extractRootObject(from: response) else {
            return []
        }

        let petList = extractPetList(from: root)

        return petList.compactMap(buildAnimal(from:))
    }

    private static func buildAnimal(from values: [String: Any]) -> Animal? {
        guard let name = extractName(from: values),
            let species = extractSpecies(from: values)
            else {
                return nil
        }

        return Animal(name: name, species: species)
    }

    private static func extractRootObject(from response: [String: Any]) -> [String: Any]? {
        return response[Keys.root] as? [String: Any]
    }

    private static func extractPetList(from values: [String: Any]) -> [[String: Any]] {
        let outerList = values[Keys.outerPetList] as? [String: Any]
        return outerList?[Keys.innerPetList] as? [[String: Any]] ?? []
    }

    private static func extractName(from values: [String: Any]) -> String? {
        guard let container = values[Keys.name] as? [String: Any] else {
            return nil
        }

        return extractText(from: container)
    }

    private static func extractSpecies(from values: [String: Any]) -> Species? {
        guard let container = values[Keys.species] as? [String: Any],
            let rawSpecies = extractText(from: container)
            else {
                return nil
        }

        switch rawSpecies {
        case "cat": return .cat
        case "dog": return .dog
        default: return nil
        }
    }

    private static func extractText(from container: [String: Any]) -> String? {
        return container[Keys.primaryText] as? String
    }

    private enum Keys {
        static let root = "petfinder"
        static let primaryText = "$t"
        static let outerPetList = "pets"
        static let innerPetList = "pet"

        static let name = "name"
        static let species = "animal"
    }

}
