//
//  WriteView.swift
//  MemoList
//
//  Created by useok on 2022/08/31.
//

import Foundation
import UIKit
import SnapKit

class WriteView: BaseView {
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
    var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .black
        textView.font = UIFont.systemFont(ofSize: 30)
        return textView
    }()
    
    
    //MARK: 뷰등록
    override func configure() {
        [textView].forEach {
            self.addSubview($0)
        }
    }
    
    //MARK: 위치
    override func setConstraints() {
        textView.snp.makeConstraints {
            $0.top.leading.equalTo(self.safeAreaLayoutGuide).offset(10)
            $0.bottom.trailing.equalTo(self.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    
}
