//
//  Logout.swift
//  tanomeal
//
//  Created by 北野正樹 on 2022/08/10.
//

import Foundation
import FirebaseAuth

struct Logout {
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("SignOut Error: %@", signOutError)
        }
    }
}
