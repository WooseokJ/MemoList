//
//  MemoListViewController.swift
//  MemoList
//
//  Created by useok on 2022/08/31.
//

import UIKit
import RealmSwift
import SwiftUI

class MemoListViewController: BaseViewController {
    
    let memoListView = MemoListView()
    let searchbar = SearchViewController()
    
    var writeButton: UIBarButtonItem!
    
    override func loadView() {
        super.view = memoListView
    }
    
    //MARK: Realm관련
    let repository = RealmRepository()
    let localRealm = try! Realm()
    var allTasks: Results<RealmModel>! {
        didSet {
            memoListView.tableView.reloadData()
            print("tasks 데이터 변경")
        }
    }
    
    let fixMemo =  RealmRepository().localRealm.objects(RealmModel.self).sorted(byKeyPath: "regDate", ascending: false).filter("favorite = true")
    let notfixMemo = RealmRepository().localRealm.objects(RealmModel.self).sorted(byKeyPath: "regDate", ascending: false).filter("favorite = false")
    
    //MARK: 서치바 필터관련
    var filteredArr:  Results<RealmModel>! {
        didSet {
            memoListView.tableView.reloadData()
            print("tasks 데이터 변경")
        }
    }
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    //MARK: tableview ReLoad
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        allTasks = repository.fetch()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchbar
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // toolbar 관련
        self.navigationController?.isToolbarHidden = false
        writeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(tapWriteButton))
        writeButton.tintColor = Constants.button.color
        var items = [UIBarButtonItem]()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        [flexibleSpace,flexibleSpace,flexibleSpace,flexibleSpace,writeButton].forEach {
            items.append($0)
        }
        self.toolbarItems = items
        //서치바+네비바
        setupSearchController()
        //테이블뷰 연결
        memoListView.tableView.delegate = self
        memoListView.tableView.dataSource = self
        memoListView.tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: "MemoListTableViewCell")
        
        // realm 파일 경로
        print(repository.localRealm.configuration.fileURL!)
        popupPresent()
    }
    @objc func buttonClicked() {
        dismiss(animated: true)
    }
    
    
    //작성하기 버튼 클릭시
    @objc func tapWriteButton(){
        let vc = WriteViewController()
        transition(vc, transitionStyle: .push)
        navigationItem.backButtonTitle = navigationItem.title
        navigationItem.leftBarButtonItem?.tintColor = Constants.button.color
        vc.select = false //작성하기
    }
    
    // 서치바+네비바
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "100개의 메모"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchResultsUpdater = self
        
    }
    //고정메모 5개 초과 알람
    func showAlert() {
        let alert = UIAlertController(title: "주의", message: "고정된 메모 5개이상불가", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    //팝업 화면 띄우기
    func popupPresent() {
        guard !UserDefaults.standard.bool(forKey: "first") else{
            return
        }
        let vc = PopUpViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        transition(vc, transitionStyle: .present)
    }
    
}

//MARK: 테이블뷰 관련
extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    //색션 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        // 서치바로 검색할떄
        if self.isFiltering {
            return 1
        }
        // 처음화면
        else{
            
            guard fixMemo.count == 0 else {
                // 픽스메모개수 0 개 아니면
                return 2
            }
            return 1 // 픽스메모개수 0개일떄
        }
    }
    
    
    //색션 타이틀
    func tableView(_ : UITableView, titleForHeaderInSection section: Int) -> String? {
        // 서치바로 검색할떄 타이틀명
        if self.isFiltering{
            return "\(filteredArr.count)개 찾음"
        }
        
        //처음화면 타이틀명
        else{
            guard fixMemo.count == 0 && section != 0 else {
                // 픽스메모개수 0개 아닐떄 타이틀명
                return "고정된 메모"
            }
            return "메모" // 픽스메모개수 0개일떄
        }
    }
    
    // row 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 서치바로 검색할떄
        if self.isFiltering {
            print("filteredArr.count:",filteredArr.count)
            return self.filteredArr.count
        }
        // 처음화면
        else {
            guard fixMemo.count == 0 else {
                return fixMemo.count
            }
            return notfixMemo.count //픽스메모 0개일떄
        }
    }
    
    // row 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 14
    }
    
    // cell 그리기
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.reuseIdentifier, for: indexPath) as? MemoListTableViewCell else {
            return UITableViewCell()
        }
        if self.isFiltering{
 
            cell.backgroundColor = .systemGray2
            cell.contentLabel.text = filteredArr[indexPath.row].content
            cell.title.text = filteredArr[indexPath.row].title
            let dateformat = DateFormatter()
            dateformat.dateFormat  = "yyyy-MM-dd"
            cell.date.text = dateformat.string(from: filteredArr[indexPath.row].regDate)
            
            return cell
        }
        else{
            print(fixMemo.description)
            print(notfixMemo.count)
            print(indexPath.section, indexPath.row)
            
            guard indexPath.section != 1 else {
                // 색션 0 이 메모일떄
                // selection 0 고정된메모 내용넣기
                cell.backgroundColor = .systemGray2
                print(fixMemo.description)
                cell.title.text = fixMemo[indexPath.row].title
                let dateformat = DateFormatter()
                dateformat.dateFormat  = "yyyy-MM-dd"
                cell.date.text = dateformat.string(from: fixMemo[indexPath.row].regDate)
                cell.contentLabel.text = fixMemo[indexPath.row].content
                return cell
            }
            // section 1 메모 내용넣기
            cell.backgroundColor = .systemGray2
            cell.contentLabel.text = notfixMemo[indexPath.row].content
            cell.title.text = notfixMemo[indexPath.row].title
            let dateformat = DateFormatter()
            dateformat.dateFormat  = "yyyy-MM-dd"
            cell.date.text = dateformat.string(from: notfixMemo[indexPath.row].regDate)
            
            return cell
            
        }
    }
    
    // 테이블뷰 색션 텍스트 정보
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont.systemFont(ofSize: 23, weight: .bold)
    }
    // 왼쪽 스와이핑(delete)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let item = allTasks?[indexPath.row] else {return}
        if editingStyle == .delete {
            try! localRealm.write{
                localRealm.delete(item)
            }
            allTasks = repository.fetch()
        }
    }
    //오른쪽 스와이핑(고정핀 고정)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favorite = UIContextualAction(style: .normal, title: "즐찾") {[self] action, view, completionHandler in
         
            if indexPath.section != 0 {
                // 메모 고정핀 누를시
                // 고정핀이 5개이하일떄
                guard fixMemo.count+1 <= 5  else {
                    showAlert()
                    return
                }
                repository.updateFavorite(item: fixMemo[indexPath.row])
                allTasks = repository.fetch()
            }else{
                //
                repository.updateFavorite(item: notfixMemo[indexPath.row])
                allTasks = repository.fetch()
            }
            
        }
        let pinImage = allTasks[indexPath.row].favorite ? "pin" : "pin.fill"
        favorite.image = UIImage(systemName: pinImage)
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
    // 셀 클릭시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section != 0 else {
            // 메모선택시
            modifyTextView(object: notfixMemo, tag: indexPath.row)
            return
        }
        //고정된 메모에서 선택시
        modifyTextView(object: fixMemo, tag: indexPath.row)
    }
    // 셀 클식시 textview 함수구현
    func modifyTextView(object: Results<RealmModel>, tag: Int) {
        let vc = WriteViewController()
        transition(vc, transitionStyle: .push)
        navigationItem.backButtonTitle = "검색"
        vc.select = true //수정하기
        vc.writeView.textView.text = object[tag].title + "\n" + object[tag].content
        vc.objectid = object[tag].objectId
    }
    
}
extension MemoListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        self.filteredArr = self.allTasks.filter("title CONTAINS[c] %@ OR content CONTAINS[c] %@",text,text)
        print(filteredArr)
    }
}

