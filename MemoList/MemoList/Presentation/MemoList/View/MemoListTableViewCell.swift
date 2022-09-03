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
    //컨텐츠 라벨
    let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    // 제목
    let title: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    // 날짜
    let date: UILabel = {
       let date = UILabel()
        return date
    }()
    
    
    //MARK: 테이블 뷰 등록
    override func configure() {
        [contentLabel,title,date].forEach {
            self.addSubview($0)
        }
    }
    //MARK: 위치
    override func setConstraints() {
        
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(date.snp.trailing).offset(20)
            $0.trailing.equalTo(-10)
            $0.top.equalTo(date.snp.top)
            $0.bottom.equalTo(0)
        }
        
        title.snp.makeConstraints {
            $0.top.equalTo(10)
            $0.leading.equalTo(10)
            $0.height.equalTo(self.snp.height).multipliedBy(0.2)
            $0.trailing.equalTo(contentLabel.snp.trailing)
        }
        
        date.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(20)
            $0.leading.equalTo(title.snp.leading)
            $0.height.equalTo(self.snp.height).multipliedBy(0.25)
            $0.width.equalTo(200)
        }
        
    }
    
}

