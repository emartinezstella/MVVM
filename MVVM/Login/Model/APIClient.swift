//
//  APIClient.swift
//  MVVM
//
//  Created by Eduardo Martinez Ibarra on 03/07/23.
//

import Foundation

enum BackendError: String, Error{
    case invalidEmail = "Comprueba el Email"
    case invalidPassword = "Comprueba el password"
}

final class APIClient {
    
    func login(withEmail email: String, password: String) async throws -> User{
       try  await Task.sleep(nanoseconds: NSEC_PER_SEC * 2)
       return try simulateBackendlogic(email: email, password: password)
    }

}
func simulateBackendlogic(email: String, password: String) throws -> User{
    
    guard  email == "user01@gmail.com" else {
        
        print("El user es incorrecto")
        throw BackendError.invalidEmail
    }
    
    guard password == "12345678" else {
        
        print("El password es incorrecto")
        throw BackendError.invalidPassword
    }
    
    print("success")
    
    return .init(name: "Ricardo", token: "asodiqw_232134", sessionStart: .now)
    
}
