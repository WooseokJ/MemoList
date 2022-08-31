//
//  MemoListTableViewCell.swift
//  MemoList
//
//  Created by useok on 2022/08/31.
//

import UIKit

class MemoListTableViewCell: BaseTableViewCell {
    //MARK: 연결
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 크기
    let contentLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    //MARK: 테이블 뷰 등록
    override func configure() {
        [contentLabel].forEach {
            self.addSubview($0)
        }
    }
    //MARK: 위치
    override func setConstraints() {
        contentLabel.snp.makeConstraints {
            $0.center.equalTo(self)
        }
        
    }
    
}

