//
//  SimpleAddingNumber.swift
//  RxAssignment
//
//  Created by ilim on 2024-08-01.
//

import UIKit
import RxSwift
import RxCocoa

class SimpleAddingNumbers: UIViewController {
    let number1 = UITextField()
    let number2 = UITextField()
    let number3 = UITextField()
    let plusLabel = UILabel()
    let separator = UIView()
    let resultLabel = UILabel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Simple Adding Example"
        addUI()
        setUI()
        setObservable()
    }
    
    func setObservable() {
        Observable.combineLatest(number1.rx.text.orEmpty,
                                 number2.rx.text.orEmpty,
                                 number3.rx.text.orEmpty) {
            textValue1, textValue2, textValue3 -> Int in
            return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
        }
        .map { $0.description }
        .bind(to: resultLabel.rx.text)
        .disposed(by: disposeBag)
    }
    
    func addUI() {
        view.addSubview(number1)
        view.addSubview(number2)
        view.addSubview(number3)
        view.addSubview(plusLabel)
        view.addSubview(separator)
        view.addSubview(resultLabel)
    }
    
    func setUI() {
        number1.layer.cornerRadius = 10
        number1.layer.borderWidth = 1
        number1.textAlignment = .center
        number1.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
            make.width.equalTo(100)
        }
        
        number2.layer.cornerRadius = 10
        number2.layer.borderWidth = 1
        number2.textAlignment = .center
        number2.snp.makeConstraints { make in
            make.top.equalTo(number1.snp.bottom).offset(5)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
            make.width.equalTo(100)
        }
        
        number3.layer.cornerRadius = 10
        number3.layer.borderWidth = 1
        number3.textAlignment = .center
        number3.snp.makeConstraints { make in
            make.top.equalTo(number2.snp.bottom).offset(5)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
            make.width.equalTo(100)
        }
        
        plusLabel.text = "+"
        plusLabel.font = .boldSystemFont(ofSize: 30)
        plusLabel.sizeToFit()
        plusLabel.snp.makeConstraints { make in
            make.trailing.equalTo(number3.snp.leading).offset(-50)
            make.top.equalTo(number2.snp.bottom).offset(5)
        }
        
        separator.layer.borderWidth = 1
        separator.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.height.equalTo(1)
            make.top.equalTo(number3.snp.bottom).offset(10)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        resultLabel.textAlignment = .center
        resultLabel.sizeToFit()
        resultLabel.font = .boldSystemFont(ofSize: 30)
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(10)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(100)
        }
    }
}
