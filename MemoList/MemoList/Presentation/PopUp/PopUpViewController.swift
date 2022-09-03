//
//  PopUpViewController.swift
//  MemoList
//
//  Created by useok on 2022/09/02.
//

import UIKit

final class PopUpViewController: BaseViewController {
    //MARK: 뷰 가져오기
    let popupView = PopUpView()
    
    override func loadView() {
        super.view = popupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    @objc func buttonClicked() {
        UserDefaults.standard.set(true, forKey: "first")
        dismiss(animated: true)
    }
    
}


