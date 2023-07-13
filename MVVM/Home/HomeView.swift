//
//  HomeView.swift
//  MVVM
//
//  Created by Eduardo Martinez Ibarra on 03/07/23.
//

import UIKit
import SnapKit

class HomeView: UIViewController {
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Bienvenido"
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 40, weight: .bold, width: .standard)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

    }
    
}
