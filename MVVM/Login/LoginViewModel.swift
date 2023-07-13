//
//  LoginViewModel.swift
//  MVVM
//
//  Created by Eduardo Martinez Ibarra on 03/07/23.
//

import UIKit
import Combine

class LoginViewModel{
    
    @Published var email = ""
    @Published var password = ""
    @Published var isEnabled = false
    @Published var showLoading = false
    @Published var errorMessage = ""
    @Published var userModel: User?
    
    var cancellables = Set<AnyCancellable>()
    
    let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        
        formValidation()
    }
    
    func formValidation(){
        
        Publishers.CombineLatest($email, $password)
            .filter { email, password in
                
                if email.count > 5 && password.count > 5{
                    return true
                }else{
                    self.isEnabled = false
                    return false
                }
                
            }.sink { value in
                
                print(value)
                self.isEnabled = true
                
        }.store(in: &cancellables)
    }
    
    @MainActor
    func userLogin(withEmail email: String, password: String){
        
        errorMessage = ""
        showLoading = true
        
        Task{
            do{
                
                userModel = try await apiClient.login(withEmail: email, password: password)
                
            }catch let error as BackendError{
                errorMessage = error.rawValue
            }
            
            showLoading = false
        }
    }
    
    

}
