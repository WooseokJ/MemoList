//
//  PopUpView.swift
//  MemoList
//
//  Created by useok on 2022/09/02.
//

import Foundation
import UIKit

class PopUpView: BaseView {
    //MARK: 연결
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 크기
    let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        return view
    }()
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("ㅇㅇㅇㅇㅇ", for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    //MARK: 뷰등록
    override func configure() {
        [blackView,button].forEach {
            self.addSubview($0)
        }
    }
    //MARK: 위치
    override func setConstraints() {
        blackView.snp.makeConstraints {
            $0.top.trailing.leading.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        button.snp.makeConstraints {
            $0.center.equalTo(self)
            
        }
    }
    
    
    
}
