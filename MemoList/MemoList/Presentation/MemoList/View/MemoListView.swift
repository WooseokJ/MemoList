//
//  MemoListView.swift
//  MemoList
//
//  Created by useok on 2022/08/31.
//

import Foundation
import UIKit

import SnapKit

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
        view.backgroundColor = .black
        return view
    }()
    
    // 작성하기 버튼
    let writeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = UIColor(red: 252/255, green: 204/255, blue: 29/255, alpha: 1)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return button
    }()
    

    
    //MARK: 뷰등록
    override func configure() {
        [tableView].forEach {
            self.addSubview($0)
        }
    }
    
    
    
    //MARK: 위치
    override func setConstraints() {
        //테이블뷰
        tableView.snp.makeConstraints {
            $0.top.equalTo(220)
            $0.trailing.leading.equalTo(0)
            $0.bottom.equalTo(-100)
        }
    }
}



extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    //색션 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    //색션 타이틀
    func tableView(_ : UITableView, titleForHeaderInSection section: Int) -> String? {
        let select = (section == 0) ? "고정된 메모" : "메모"
        return select
    }
    
    // row 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let select = (section == 0) ? 3 : 4
        return select
    }
    // row 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 15
    }
    // cell 그리기
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.reuseIdentifier, for: indexPath) as? MemoListTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .systemGray2
        cell.contentLabel.text = "ddd"
        
        return cell
    }
    // 테이블뷰 색션 텍스트 정보
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont.systemFont(ofSize: 23, weight: .bold)
    }
    
  
}
