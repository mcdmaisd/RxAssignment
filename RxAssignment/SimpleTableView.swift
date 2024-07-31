//
//  SimpleTableView.swift
//  RxAssignment
//
//  Created by ilim on 2024-08-01.
//

import UIKit
import RxSwift
import RxCocoa

class SimpleTableView: UIViewController {
    
    let tableView = UITableView()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Simple TableView Example"
        setTableView()
        setObservable()
    }
    
    func setObservable() {
        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )
        
        items
            .bind(to: tableView.rx.items) { (row, element, cell) in
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(element). @ row \(element)"
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext:  { value in
                self.showAlert("Tapped `\(value)`")
            })
            .disposed(by: disposeBag)
    }
    
    func setTableView() {
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func showAlert(_ msg: String) {
        let alert = UIAlertController(
            title: "RxTableViewExample",
            message: msg,
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
