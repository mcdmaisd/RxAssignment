//
//  SimpleValidation.swift
//  RxAssignment
//
//  Created by ilim on 2024-08-01.
//

import UIKit
import RxSwift
import RxCocoa

class SimpleValidation: UIViewController {
    let minimalUsernameLength = 5
    let minimalPasswordLength = 5
    let nameLabel = UILabel()
    let passwordLabel = UILabel()
    let checkNameLabel = UILabel()
    let checkPasswordLabel = UILabel()
    let nameTextfield = UITextField()
    let passwordTextfield = UITextField()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Simple Validation Example"
        addUI()
        setUI()
        setConstraints()
        setObservable()
    }
    
    func setObservable() {
        checkNameLabel.text = "Username has to be at least \(minimalUsernameLength) characters"
        checkPasswordLabel.text = "Password has to be at least \(minimalPasswordLength) characters"

        let usernameValid = nameTextfield.rx.text.orEmpty
            .map { $0.count >= self.minimalUsernameLength }
            .share(replay: 1) // without this map would be executed once for each binding, rx is stateless by default

        let passwordValid = passwordTextfield.rx.text.orEmpty
            .map { $0.count >= self.minimalPasswordLength }
            .share(replay: 1)

        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)

        usernameValid
            .bind(to: passwordTextfield.rx.isEnabled)
            .disposed(by: disposeBag)

        usernameValid
            .bind(to: checkNameLabel.rx.isHidden)
            .disposed(by: disposeBag)

        passwordValid
            .bind(to: checkPasswordLabel.rx.isHidden)
            .disposed(by: disposeBag)

    }
    
    func addUI() {
        view.addSubview(nameLabel)
        view.addSubview(passwordLabel)
        view.addSubview(checkNameLabel)
        view.addSubview(checkPasswordLabel)
        view.addSubview(nameTextfield)
        view.addSubview(passwordTextfield)
    }
    
    func setUI() {
        nameLabel.text = "Username"
        nameLabel.sizeToFit()
        passwordLabel.text = "Password"
        passwordLabel.sizeToFit()
        nameTextfield.layer.borderWidth = 1
        nameTextfield.layer.cornerRadius = 10
        passwordTextfield.layer.borderWidth = 1
        passwordTextfield.layer.cornerRadius = 10
        checkNameLabel.textColor = .red
        checkPasswordLabel.textColor = .red
    }
    
    func setConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        nameTextfield.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.height.equalTo(44)
        }
        checkNameLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.top.equalTo(nameTextfield.snp.bottom).offset(5)
            make.height.equalTo(44)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(checkNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        passwordTextfield.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.top.equalTo(passwordLabel.snp.bottom).offset(5)
            make.height.equalTo(44)
        }
        checkPasswordLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.top.equalTo(passwordTextfield.snp.bottom).offset(5)
            make.height.equalTo(44)
        }
    }
}
