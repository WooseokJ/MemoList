//
//  MemoListViewController.swift
//  MemoList
//
//  Created by useok on 2022/08/31.
//

import UIKit
import RealmSwift

class MemoListViewController: BaseViewController {
    
    
    let memoListView = MemoListView()
    let searchbar = SearchViewController()
    let realm = try! Realm()
    var writeButton: UIBarButtonItem!
    
    override func loadView() {
        super.view = memoListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        navigationItem.searchController = searchbar
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // toolbar 관련
        self.navigationController?.isToolbarHidden = false
        writeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(tapWriteButton))
        writeButton.tintColor = UIColor(red: 252/255, green: 204/255, blue: 29/255, alpha: 1)
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
        // realm 파일 경로 
        print(realm.configuration.fileURL!)
        
    }
    @objc func tapWriteButton(){
        let vc = WrtieViewController()
        transition(vc, transitionStyle: .push)
    }
    
    // 서치바+네비바
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색"
        searchController.hidesNavigationBarDuringPresentation = true
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "1000개의 메모"
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
}
