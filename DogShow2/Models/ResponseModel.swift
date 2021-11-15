//
//  ResponseModel.swift
//  DogShow2
//
//  Created by Surgeont on 07.11.2021.
//

import Foundation

struct Response: Decodable {
    let message: [String: [String]]
    let status: String
}

