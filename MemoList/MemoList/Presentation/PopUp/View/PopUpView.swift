//
//  PopUpView.swift
//  MemoList
//
//  Created by useok on 2022/09/02.
//

import Foundation
import UIKit
import SnapKit
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
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    let textView: UITextView = {
        let textView = UITextView()
        textView.text = """
        처음 오셧군요!
        환영합니다 :)
        
        당신만의 메모를 작성하시고
        관리해보세요!
        """
        textView.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        textView.backgroundColor = .systemGray5
        return textView
    }()
    
    //MARK: 뷰등록
    override func configure() {
        [blackView,button,textView].forEach {
            self.addSubview($0)
        }
    }
    //MARK: 위치
    override func setConstraints() {
        blackView.snp.makeConstraints {
            $0.center.equalTo(self)
            $0.height.width.equalTo(250)
        }
        button.snp.makeConstraints {
            $0.height.equalTo(blackView.snp.height).multipliedBy(0.15)
            $0.bottom.equalTo(blackView.snp.bottom).offset(-20)
            $0.leading.equalTo(blackView.snp.leading).offset(10)
            $0.trailing.equalTo(blackView.snp.trailing).offset(-10)
        }
        textView.snp.makeConstraints {
            $0.bottom.equalTo(button.snp.top).offset(-10)
            $0.top.equalTo(blackView.snp.top).offset(10)
            $0.leading.equalTo(button.snp.leading)
            $0.trailing.equalTo(button.snp.trailing)
        }
    }
    
    
    
}
