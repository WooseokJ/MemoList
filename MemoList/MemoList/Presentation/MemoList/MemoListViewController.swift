//
//  MemoListViewController.swift
//  MemoList
//
//  Created by useok on 2022/08/31.
//

import UIKit
import RealmSwift
import SnapKit

final class MemoListViewController: BaseViewController {
    
    internal let memoListView = MemoListView()
    
    override func loadView() {
        super.view = memoListView
    }

    //MARK: 변수 선언
    internal var writeButton: UIBarButtonItem! //툴바 items
    
    //MARK: Realm관련
    internal let repository = RealmRepository()
    
    internal var allTasks: Results<RealmModel>! {
        didSet {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = Int.max
            let result = numberFormatter.string(for: allTasks.count)!
            self.navigationItem.title = "\(result)개의 메모"
            memoListView.tableView.reloadData()
            print("tasks 데이터 변경")
        }
    }

    internal let ifFixed = fixCheck.allCases[0].check


    internal var fixMemo: Results<RealmModel>! {
        didSet{
            memoListView.tableView.reloadData()
        }
    }
    internal var notfixMemo: Results<RealmModel>! {
        didSet{
            memoListView.tableView.reloadData()
        }
    }
    
    //MARK: 서치바 필터관련 변수선언
    internal let searchController = UISearchController(searchResultsController: nil)

    internal var filteredArr:  Results<RealmModel>! {
        didSet {
            memoListView.tableView.reloadData()
            print("tasks 데이터 변경")
        }
    }
    
    internal var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    
    //MARK: tableview ReLoad
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSearchController()
        allTasks = repository.fetch()
    }
    
    let localRealm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let version = try schemaVersionAtURL(localRealm.configuration.fileURL!) // url에 들어가는 스키마 버전이 몇버전이냐
            print(version)
        } catch {
            print(error)
        }


        
        // toolbar 디자인
        setToolbarDesign()
        
        fixMemo = repository.fixFetch()
        notfixMemo = repository.notFixFetch()
        
        //테이블뷰 연결
        memoListView.tableView.delegate = self
        memoListView.tableView.dataSource = self
        memoListView.tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.reuseIdentifier)
        
        // realm 파일 경로
        print(repository.localRealm.configuration.fileURL!)
        // popup 띄우기
        popupPresent()
    }


    
}


