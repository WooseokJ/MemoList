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
//        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
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
        //realm관련
        
        // realm 파일 경로 
        print(repository.localRealm.configuration.fileURL!)
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
        searchController.searchBar.placeholder = "검색"
        searchController.hidesNavigationBarDuringPresentation = true
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "1000개의 메모"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    func showAlert() {
        let alert = UIAlertController(title: "주의", message: "고정된 메모 5개이상불가", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
}

//MARK: 테이블뷰 관련
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
        let fixMemoCount =  localRealm.objects(RealmModel.self).sorted(byKeyPath: "regDate", ascending: false).filter("favorite = true")
        let notfixMemoCount = localRealm.objects(RealmModel.self).sorted(byKeyPath: "regDate", ascending: false).filter("favorite = false")
        let select = (section == 0) ? fixMemoCount.count : notfixMemoCount.count
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

        let fixMemo = localRealm.objects(RealmModel.self).sorted(byKeyPath: "regDate", ascending: false).filter("favorite = true")


                
                
        guard indexPath.section != 0  else {
            // selection 0 고정된메모 내용넣기
               
            cell.backgroundColor = .systemGray2
    //            cell.title.text = fixMemo[indexPath.row].title
    //            let dateformat = DateFormatter()
    //            dateformat.dateFormat  = "yyyy-MM-dd"
    //            cell.date.text = dateformat.string(from: fixMemo[indexPath.row].regDate)
            cell.contentLabel.text = fixMemo[indexPath.row].content
            return cell
        }
        let notfixMemoCount = localRealm.objects(RealmModel.self).sorted(byKeyPath: "regDate", ascending: false).filter("favorite = false")
        // section 1 메모 내용넣기
        cell.backgroundColor = .systemGray2
        cell.contentLabel.text = notfixMemoCount[indexPath.row].content
//        cell.title.text = allTasks[indexPath.row].title
//        let dateformat = DateFormatter()
//        dateformat.dateFormat  = "yyyy-MM-dd"
//        cell.date.text = dateformat.string(from: allTasks[indexPath.row].regDate)
      
        return cell
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
        
        let favorite = UIContextualAction(style: .normal, title: "즐찾") { action, view, completionHandler in
            let fixMemo = self.repository.localRealm.objects(RealmModel.self).filter("favorite = true")
            
            //고정핀이 5개이하일떄 패스
            guard fixMemo.count <= 4  else {
                self.showAlert()
                return
            }
            self.repository.updateFavorite(item: self.allTasks[indexPath.row])
            self.allTasks = self.repository.fetch()
            
        }
        let pinImage = allTasks[indexPath.row].favorite ? "pin" : "pin.fill"
        favorite.image = UIImage(systemName: pinImage)
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
    // 셀 클릭시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WriteViewController()
        transition(vc, transitionStyle: .push)
        navigationItem.backButtonTitle = "검색"
        vc.select = true //수정하기
        
        let notfixMemoCount = localRealm.objects(RealmModel.self).sorted(byKeyPath: "regDate", ascending: false).filter("favorite = false")
        print(notfixMemoCount)
        vc.writeView.textView.text = notfixMemoCount[indexPath.row].title + "\n" + allTasks[indexPath.row].content
        vc.tag = indexPath.row
        
    }
    
    
}

