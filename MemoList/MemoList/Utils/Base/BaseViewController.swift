//
//  BaseViewController.swift
//  MemoList
//
//  Created by useok on 2022/08/31.
//

import UIKit
import Zip
import RealmSwift

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
    }

    func configure() { }
    func setConstraints() { }
    
    //고정메모 5개 초과 알람
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    
    
    

}

