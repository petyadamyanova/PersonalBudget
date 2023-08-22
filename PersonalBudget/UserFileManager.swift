//
//  UserFileManager.swift
//  PersonalBudget
//
//  Created by Petia Damyanova on 22.08.23.
//

import Foundation

import Foundation

class UserFileManager {
    static func saveUsersData(_ users: [User]) {
        let encoder = JSONEncoder()
        do {
            let encodedUsers = try encoder.encode(users)
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentsDirectory.appendingPathComponent("userData.json")
                try encodedUsers.write(to: fileURL)
            }
        } catch {
            print("Error encoding and storing user data: \(error)")
        }
    }

    static func loadUsersData() -> [User]? {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent("userData.json")
            do {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let users = try decoder.decode([User].self, from: data)
                return users
            } catch {
                print("Error loading user data: \(error)")
            }
        }
        return nil
    }
}
