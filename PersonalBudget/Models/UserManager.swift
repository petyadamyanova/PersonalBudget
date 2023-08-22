//
//  UserManager.swift
//  PersonalBudget
//
//  Created by Student on 14.08.23.
//

import Foundation

final class UsersManager {
    static var shared = UsersManager()
    private var currentUser: User?
    private var currentAccount: Account?
    var users: [User] = []
    
    private init() {
        loadCurrentUser()
    }
    
    func addUser(_ user: User) {
        users.append(user)
    }
    
    func setCurrentUser(_ user: User) {
        currentUser = user
        saveCurrentUser()
    }
    
    func setCurrentAccount(_ account: Account){
        currentAccount = account
    }
    
    func getCurrentAccount() -> Account? {
        return currentAccount
    }
    
    func getCurrentUser() -> User? {
        return currentUser
    }
    
    func userExists(username: String) -> Bool {
        return users.contains { $0.username == username }
    }
    
    func updateCurrentUser(_ user: User) {
        currentUser = user
        saveCurrentUser()
    }
    
    private func loadCurrentUser() {
        if let userData = UserDefaults.standard.data(forKey: "currentUserKey"),
            let user = try? JSONDecoder().decode(User.self, from: userData) {
            currentUser = user
        }
    }
    
    private func saveCurrentUser() {
        if let encodedUser = try? JSONEncoder().encode(currentUser) {
            UserDefaults.standard.set(encodedUser, forKey: "currentUserKey")
        }
    }
    
    func removeCurrentUser() {
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: "currentUserKey")
    }
}

