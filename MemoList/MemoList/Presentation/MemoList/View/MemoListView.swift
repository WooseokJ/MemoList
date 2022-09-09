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
    
    // 테이블뷰
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
            $0.top.equalTo(0)
            $0.trailing.leading.equalTo(0)
            $0.bottom.equalTo(-100)
            
        }
    }
}

//MARK: 테이블뷰 그리기
extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: 색션 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        
        //서치바로 필터링이 안되있으면 패스
        guard !self.isFiltering else {
            return 1
        }
        
        //고정된 메모 숫자가 0이 아니면 패스
        guard !(fixMemo.count == 0) else {
            return 1
        }
        
        switch notfixMemo.count == 0 { //고정되지않은거개수
        case ifFixed : return 1 // 열거형쓸필요없지만 연습삼아 사용 case true로 대체해도 가능
        default: return 2
        }
    }
    
    
    
    //MARK: 색션 타이틀
    func tableView(_ : UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard !self.isFiltering else {
            return "\(filteredArr.count)개 찾음"
        }
        
        guard (section == 0) else {
            return "메모"
        }
        
        switch fixMemo.count == 0 {
            case ifFixed :  return "메모"
            default: return "고정된메모"
        }
    }
    
    //MARK:  row 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard !self.isFiltering else {
            return self.filteredArr.count
        }
        
        guard (section == 0) else{
            return notfixMemo.count
        }
        
        switch fixMemo.count == 0 {
            case ifFixed : return notfixMemo.count
            default: return fixMemo.count
        }
    }
    
    
    
    //MARK:  row 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 14
    }
    
    //MARK: cell 그리기
    @discardableResult
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.reuseIdentifier, for: indexPath) as? MemoListTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .systemGray4
        cell.selectionStyle = .none
        guard !self.isFiltering else{
            return searchTextColorChanged(object: filteredArr, index: indexPath.row, cell: cell)
        }
        
        guard !(indexPath.section == 0) else {
            switch fixMemo.count == 0 {
            case ifFixed :
                return searchTextColorChanged(object: notfixMemo, index: indexPath.row, cell: cell)
            default:
                return searchTextColorChanged(object: fixMemo, index: indexPath.row, cell: cell)
            }
        }
        return searchTextColorChanged(object: notfixMemo, index: indexPath.row, cell: cell)
        
    }
    
    //MARK:  테이블뷰 색션 텍스트 정보
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        header.textLabel?.textColor = UIColor(named: "sectionColor")
        
    }
    
    //MARK:  왼쪽 스와이핑(delete)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard !self.isFiltering else{
            deleteCheck(object: filteredArr,tag: indexPath.row )
            return
        }
        
        guard indexPath.section == 0 else {
            if editingStyle == .delete {
                deleteCheck(object: notfixMemo,tag: indexPath.row )
            }
            return
        }
        
        guard fixMemo.count == 0 else {
            if editingStyle == .delete {
                deleteCheck(object: fixMemo,tag: indexPath.row )
            }
            return
        }
        
        if editingStyle == .delete {
            deleteCheck(object: notfixMemo,tag: indexPath.row )
        }
        return
    }
    
    //MARK: 오른쪽 스와이핑(고정핀 고정)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favorite = UIContextualAction(style: .normal, title: "즐찾") {[self] action, view, completionHandler in
            
            guard !self.isFiltering else {
                guard fixMemo.count <= 5  else {
                    showAlert(message: "고정핀 5개 이상 불가")
                    return
                }
                guard fixMemo.count == 0 else {
                    repository.updateFavorite(item: filteredArr[indexPath.row])
                    fixMemo = repository.fixFetch()
                    return
                }
                repository.updateFavorite(item: filteredArr[indexPath.row])
                notfixMemo = repository.notFixFetch()
                return
            }
            
            guard indexPath.section == 0 else {
                // 고정핀이 5개이하일떄
                guard fixMemo.count < 5  else {
                    showAlert(message: "고정핀 5개 이상 불가")
                    return
                }
                repository.updateFavorite(item: notfixMemo[indexPath.row])
                fixMemo = repository.fixFetch()
                return
            }
            
            
            // 고정핀이 5개이하일떄
            guard fixMemo.count <= 5  else {
                showAlert(message: "고정핀 5개 이상 불가")
                return
            }
            guard fixMemo.count == 0 else {
                repository.updateFavorite(item: fixMemo[indexPath.row])
                notfixMemo = repository.notFixFetch()
                return
            }
            
            repository.updateFavorite(item: notfixMemo[indexPath.row])
            fixMemo = repository.fixFetch()
            return
        }
        
        guard !self.isFiltering else {
            return pinImageSelect(object: filteredArr, favorite: favorite, tag: indexPath.row)
        }
        guard !(fixMemo.count == 0) else {
            return pinImageSelect(object: notfixMemo, favorite: favorite, tag: indexPath.row)
        }
        guard indexPath.section == 0 else {
            return pinImageSelect(object: notfixMemo, favorite: favorite, tag: indexPath.row)
        }
        return pinImageSelect(object: fixMemo, favorite: favorite, tag: indexPath.row)
    }
    
    // 고정 이미지 설정
    private func pinImageSelect(object: Results<RealmModel>!, favorite: UIContextualAction ,tag: Int) -> UISwipeActionsConfiguration? {
        let pinImage = object[tag].favorite ? "pin.slash.fill" : "pin.fill"
        favorite.image = UIImage(systemName: pinImage)
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
    
    //MARK: 셀 클릭시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard !self.isFiltering else {
            modifyTextView(object: filteredArr, tag: indexPath.row,backTitle: "검색")
            return
        }
        guard indexPath.section == 0 else {
            modifyTextView(object: notfixMemo, tag: indexPath.row,backTitle: "메모")
            return
        }
        guard fixMemo.count == 0 else {
            modifyTextView(object: fixMemo, tag: indexPath.row,backTitle: "메모")
            return
        }
        modifyTextView(object: notfixMemo, tag: indexPath.row, backTitle: "메모")
        return
    }
    
    
    //MARK: 셀 클식시 textview 함수구현
    private func modifyTextView(object: Results<RealmModel>, tag: Int, backTitle: String) {
        let vc = WriteViewController()
        transition(vc, transitionStyle: .push)
        navigationItem.backButtonTitle = backTitle
        vc.select = true //수정하기
        vc.writeView.textView.text = object[tag].title + "\n" + object[tag].content
        vc.objectid = object[tag].objectId
    }
    
}
