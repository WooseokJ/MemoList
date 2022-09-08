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
        let notFixed = fixCheck.allCases[0].check

        //서치바로 필터링이 안되있으면 패스
        guard !self.isFiltering else {
            return 1
        }
        //고정된 메모 숫자가 0이 아니면 패스
        guard !(fixMemo.count == 0) else {
            return 1
        }
        
        switch notfixMemo.count == 0 { //고정되지않은거개수
            case notFixed : return 1
            default: return 2
        }
    }
    
    

    //MARK: 색션 타이틀
    func tableView(_ : UITableView, titleForHeaderInSection section: Int) -> String? {
        let ifFixed = fixCheck.allCases[0].check

        
        guard self.isFiltering else {
            switch section == 0 {
                case ifFixed :
                    switch fixMemo.count == 0 {
                        case ifFixed :  return "메모"
                        default: return "고정된메모"
                    }
            default :
                return "메모"
            }
        }
        return "\(filteredArr.count)개 찾음"
    }
    
    //MARK:  row 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 서치바로 검색할떄
        if self.isFiltering {
            return self.filteredArr.count
        }
        // 처음화면
        else {
            if section == 0 {
                if fixMemo.count == 0 {return notfixMemo.count}
                else {return fixMemo.count}
            }
            else {return notfixMemo.count}
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
        cell.backgroundColor = .systemGray2
        cell.selectionStyle = .none
        
        if self.isFiltering {
            cell.contentLabel.attributedText = searchContentColor(object:  filteredArr, index: indexPath.row, cell: cell)
            cell.title.attributedText = searchTitleText(object:  filteredArr, index: indexPath.row, cell: cell)
            cell.selectionStyle = .none

            return cell
        }
        
        else{
            if indexPath.section == 0  {
                if fixMemo.count == 0 {
                    cell.contentLabel.attributedText = searchContentColor(object:  notfixMemo, index: indexPath.row, cell: cell)
                    cell.title.attributedText = searchTitleText(object:  notfixMemo, index: indexPath.row, cell: cell)
                    cell.date.text = dateCalc(date: notfixMemo[indexPath.row].regDate)
                    cell.selectionStyle = .none

                    return cell
                }
                else{
                    cell.contentLabel.attributedText = searchContentColor(object:  fixMemo, index: indexPath.row, cell: cell)
                    cell.title.attributedText = searchTitleText(object:  fixMemo, index: indexPath.row, cell: cell)
                    cell.date.text = dateCalc(date: fixMemo[indexPath.row].regDate)
                    cell.selectionStyle = .none

                    return cell
                }
            }
            else{
                cell.contentLabel.attributedText = searchContentColor(object:  notfixMemo, index: indexPath.row, cell: cell)
                cell.title.attributedText = searchTitleText(object:  notfixMemo, index: indexPath.row, cell: cell)
                cell.date.text = dateCalc(date: notfixMemo[indexPath.row].regDate)
                cell.selectionStyle = .none

                return cell

            }
        }
    }
   
    //MARK:  테이블뷰 색션 텍스트 정보
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        header.textLabel?.textColor = UIColor(named: "sectionColor")

    }
    //MARK:  왼쪽 스와이핑(delete)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if self.isFiltering {
            let item = filteredArr[indexPath.row]
            showDeleteAlert(message: "정말로 삭제할거냐?", item: item)
        }
        else{
            if indexPath.section == 0 {
                if fixMemo.count == 0 {
                    if editingStyle == .delete {
                        let item = notfixMemo[indexPath.row]
                        showDeleteAlert(message: "정말로 삭제할거냐?", item: item)

                    }
                } else{
                    if editingStyle == .delete {
                        let item = fixMemo[indexPath.row]
                        showDeleteAlert(message: "정말로 삭제할거냐?", item: item)

                    }
                }
            }
            else{
                if editingStyle == .delete {
                    let item = notfixMemo[indexPath.row]
                    showDeleteAlert(message: "정말로 삭제할거냐?", item: item)

                }
            }

        }
        
    }

    //MARK: 삭제 앨럿 띄우기
    internal func showDeleteAlert(message: String, item: RealmModel) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { action in
            try! self.repository.localRealm.write{
                self.repository.localRealm.delete(item)
            }
            self.allTasks = self.repository.fetch()
        }
        alert.addAction(ok)
        alert.addAction(delete)
        self.present(alert, animated: true)
    }
    
    //MARK: 오른쪽 스와이핑(고정핀 고정)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favorite = UIContextualAction(style: .normal, title: "즐찾") {[self] action, view, completionHandler in
            
            if self.isFiltering {
                guard fixMemo.count <= 5  else {
                    showAlert(message: "고정핀 5개 이상 불가")
                    return
                }
                if fixMemo.count == 0 {
                    repository.updateFavorite(item: filteredArr[indexPath.row])
                    notfixMemo = repository.notFixFetch()
                }
                else{
                    repository.updateFavorite(item: filteredArr[indexPath.row])
                    fixMemo = repository.fixFetch()
                }
            }
            else{
                if indexPath.section == 0 {
                    // 고정핀이 5개이하일떄
                    guard fixMemo.count <= 5  else {
                        showAlert(message: "고정핀 5개 이상 불가")
                        return
                    }
                    if fixMemo.count == 0 {
                        repository.updateFavorite(item: notfixMemo[indexPath.row])
                        fixMemo = repository.fixFetch()
                    }
                    else{
                        repository.updateFavorite(item: fixMemo[indexPath.row])
                        notfixMemo = repository.notFixFetch()
                    }
                }
                else{
                    // 고정핀이 5개이하일떄
                    guard fixMemo.count < 5  else {
                        showAlert(message: "고정핀 5개 이상 불가")
                        return
                    }
                    repository.updateFavorite(item: notfixMemo[indexPath.row])}
                    fixMemo = repository.fixFetch()
            }
        }
        
        
        
        if self.isFiltering {
           
            return pinImageSelect(object: filteredArr, favorite: favorite, tag: indexPath.row)
        }
        
        else {
            if fixMemo.count == 0 {
                return pinImageSelect(object: notfixMemo, favorite: favorite, tag: indexPath.row)
            }
            else {
                if indexPath.section == 0 {
                    
                    return pinImageSelect(object: fixMemo, favorite: favorite, tag: indexPath.row)
                } else {
                    
                    return pinImageSelect(object: notfixMemo, favorite: favorite, tag: indexPath.row)
                }
            }
        }
    }
    // 고정 이미지 설정
    private func pinImageSelect(object: Results<RealmModel>!, favorite: UIContextualAction ,tag: Int) -> UISwipeActionsConfiguration? {
        let pinImage = filteredArr[tag].favorite ? "pin.slash.fill" : "pin.fill"
        favorite.image = UIImage(systemName: pinImage)
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
    
    //MARK: 셀 클릭시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isFiltering {
            modifyTextView(object: filteredArr, tag: indexPath.row,backTitle: "검색")
        }
        else{
            if indexPath.section == 0 {
                if fixMemo.count == 0{modifyTextView(object: notfixMemo, tag: indexPath.row, backTitle: "메모")}
                else{modifyTextView(object: fixMemo, tag: indexPath.row,backTitle: "메모")}
                return
            }
            else {modifyTextView(object: notfixMemo, tag: indexPath.row,backTitle: "메모")}
        }
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
