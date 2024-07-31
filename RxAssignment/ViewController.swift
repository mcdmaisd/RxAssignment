//
//  ViewController.swift
//  RxAssignment
//
//  Created by ilim on 2024-07-31.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let simplePickerView = UIPickerView()
    let simpleLabel = UILabel()
    let simpleTableView = UITableView()
    let simpleSwitch = UISwitch()
    let signName = UITextField()
    let signEmail = UITextField()
    let signButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addUI()
        setUI()
        setConstraints()
        setTableView()
        setPickerView()
        setSwitch()
        setSign()
    }
    
    func addUI() {
        view.addSubview(simpleLabel)
        view.addSubview(simplePickerView)
        view.addSubview(simpleTableView)
        view.addSubview(simpleSwitch)
        view.addSubview(signName)
        view.addSubview(signEmail)
        view.addSubview(signButton)
    }
    
    func setUI() {
        signName.backgroundColor = .lightGray
        signName.placeholder = "input name"
        signEmail.backgroundColor = .lightGray
        signEmail.placeholder = "input email"
        signButton.backgroundColor = .lightGray
        signButton.setTitle("button", for: .normal)
    }
    
    func setConstraints() {
        simpleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.height.equalTo(44)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalToSuperview()
        }
        
        simpleSwitch.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.top.equalTo(simpleLabel.snp.bottom).offset(5)
        }
        
        simplePickerView.snp.makeConstraints { make in
            make.top.equalTo(simpleSwitch.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(200)
        }
        
        simpleTableView.snp.makeConstraints { make in
            make.top.equalTo(simplePickerView.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        
        signName.snp.makeConstraints { make in
            make.top.equalTo(simpleTableView.snp.bottom).offset(10)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
        }
        
        signEmail.snp.makeConstraints { make in
            make.top.equalTo(signName.snp.bottom).offset(10)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
        }
        
        signButton.snp.makeConstraints { make in
            make.top.equalTo(signEmail.snp.bottom).offset(10)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
        }
    }
    
    func showAlert() {
        print(#function)
        testOf()
        testFrom()
        testJust()
        testRepeat()
    }
    
    func setSwitch() {
        Observable.of(false)
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    
    func setSign() {
        Observable.combineLatest (signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
            return "name은 \(value1)이고, 이메일은 \(value2)입니다"
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)
        
        signName.rx.text.orEmpty //String
            .map { $0.count < 4 } // Int
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmail.rx.text.orEmpty
            .map { $0.count > 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton.rx.tap
            .subscribe { _ in
                self.showAlert()
            }
            .disposed(by: disposeBag)
    }
    
    func setPickerView() {
        let items = Observable.just(["영화", "애니메이션", "드라마", "기타"])
        items
            .bind(to: simplePickerView.rx.itemTitles) { _, items in
                return "\(items)"
            }
            .disposed(by: disposeBag)

        simplePickerView.rx.modelSelected(String.self)
            .subscribe(onNext: { models in
                print("models selected 1: \(models)")
            })
            .disposed(by: disposeBag)
    }
    
    func setTableView() {
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])
        
        items
        .bind(to: simpleTableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)//subcribe가 취소되는 부분

        simpleTableView.rx.modelSelected(String.self)
            .map { data in
                "\(data)를 클릭했습니다."
            }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func testJust() {
        Observable.just([3.3, 4.0, 5.0, 2.0, 3.6, 4.8]) // finite observable sequence
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: { //event는 아님
                print("just disposed")
            }
            .disposed(by: disposeBag)
    }
    
    func testOf() {
        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        let itemsB = [2.3, 2.0, 1.3]
        Observable.of(itemsA, itemsB) // finite observable sequence
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: { //event는 아님
                print("just disposed")
            }
            .disposed(by: disposeBag)
    }
    
    func testFrom() {
        Observable.from([3.3, 4.0, 5.0, 2.0, 3.6, 4.8]) // finite observable sequence
            .subscribe { value in
                print("next: \(value)")
            } onError: { error in
                print(error)
            } onCompleted: {
                print("complete")
            } onDisposed: { //event는 아님
                print("dispose")
            }
            .disposed(by: disposeBag)
    }
    
    func testRepeat() {
        Observable.repeatElement("Jack")
            .take (5)
            .subscribe { value in
                print("repeat — \(value)")
            } onError: { error in
                print("repeat - \(error)")
            } onCompleted: {
                print("repeat completed")
            } onDisposed: {
                print("repeat disposed")
            }
            .disposed(by: disposeBag)
    }
    
}

