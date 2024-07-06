//
//  UserModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 6/7/24.
//

import Foundation

struct UserModel: Identifiable, Codable {
    let id: String
    let username: String
    let email: String
}
