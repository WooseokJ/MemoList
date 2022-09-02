//
//  MemoListView.swift
//  MemoList
//
//  Created by useok on 2022/08/31.
//

import Foundation
import UIKit

import SnapKit
import RealmSwift

class MemoListView: BaseView {
    
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
    let searchbar = SearchViewController()
    
    //테이블뷰
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.register(MemoListTableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.reuseIdentifier)
        return view
    }()
    
    //MARK: 뷰등록
    override func configure() {
        [tableView].forEach {
            self.addSubview($0)
        }
    }
    
    //MARK: 위치
    override func setConstraints() {
        // 테이블뷰
        tableView.snp.makeConstraints {
            $0.top.equalTo(220)
            $0.trailing.leading.equalTo(0)
            $0.bottom.equalTo(-100)
        }
    }
}

