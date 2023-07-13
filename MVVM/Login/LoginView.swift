//
//  ViewController.swift
//  MVVM
//
//  Created by Eduardo Martinez Ibarra on 03/07/23.
//

import UIKit
import SnapKit
import Combine

class LoginView: UIViewController {
    
    private let loginViewModel = LoginViewModel(apiClient: APIClient())
    var cancellables = Set<AnyCancellable>()
   
    private let emailTextfield: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add email"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let passwordTextfield: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        
        var config = UIButton.Configuration.filled()
        config.title = "Login"
        config.subtitle = "¡Inicia sesión!"
        config.image = UIImage(systemName: "play.circle.fill")
        config.imagePadding = 8
        
        let button = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] action in
            self?.startLogin()
        }))
        
        button.configuration = config
        
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textColor = .red
        label.font = .systemFont(ofSize: 20, weight: .regular, width: .condensed)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBindingViewViewWithViewModel()
        setupUI()
    }
    
    func setupUI(){
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        view.addSubview(passwordTextfield)
        passwordTextfield.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(loginButton.snp.top).offset(-30)
            make.height.equalTo(50)
            make.width.equalTo(250)
        }
        
        view.addSubview(emailTextfield)
        emailTextfield.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(passwordTextfield.snp.top).offset(-10)
            make.height.equalTo(50)
            make.width.equalTo(250)
        }
        
        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginButton.snp.bottom).offset(20)
        }
    }
    
    private func startLogin(){
        loginViewModel.userLogin(withEmail: emailTextfield.text?.lowercased() ?? "", password: passwordTextfield.text?.lowercased() ?? "")
    }

    
    func createBindingViewViewWithViewModel(){
        
        emailTextfield.textPublisher.assign(to: \LoginViewModel.email, on: loginViewModel)
            .store(in: &cancellables)
        
        passwordTextfield.textPublisher.assign(to: \LoginViewModel.password, on: loginViewModel)
            .store(in: &cancellables)
        
        loginViewModel.$isEnabled.assign(to: \.isEnabled, on: loginButton)
            .store(in: &cancellables)
        
        loginViewModel.$showLoading.assign(to: \.configuration!.showsActivityIndicator, on: loginButton)
            .store(in: &cancellables)
        
        loginViewModel.$errorMessage.assign(to: \UILabel.text!, on: errorLabel)
            .store(in: &cancellables)
        
        loginViewModel.$userModel.sink{ [weak self] _ in
            print("Success navigateto home view controller")
            let homeView = HomeView()
            self?.present(homeView, animated: true)
        }.store(in: &cancellables)
    
    }

}

extension LoginView: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        return true
    }
}

extension UITextField{
    var textPublisher: AnyPublisher<String, Never>{
        return NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .map {
            notification in
            
            return (notification.object as? UITextField)?.text ?? ""
            }.eraseToAnyPublisher()
    }
}

