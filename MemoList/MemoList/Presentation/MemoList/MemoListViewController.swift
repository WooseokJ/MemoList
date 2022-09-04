//
//  MemoListViewController.swift
//  MemoList
//
//  Created by useok on 2022/08/31.
//

import UIKit
import RealmSwift
import SwiftUI
import SnapKit

final class MemoListViewController: BaseViewController {
    
    let memoListView = MemoListView()
    let searchController = UISearchController(searchResultsController: nil)

    var writeButton: UIBarButtonItem!
    
    override func loadView() {
        super.view = memoListView
    }
    
    
    //MARK: Realm관련
    let repository = RealmRepository()
    let localRealm = try! Realm()
    var allTasks: Results<RealmModel>! {
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
    

    var fixMemo: Results<RealmModel>! {
        didSet{
            print("fixMemo")
            memoListView.tableView.reloadData()
        }
    }
    var notfixMemo: Results<RealmModel>! {
        didSet{
            print("notfixMemo")
            memoListView.tableView.reloadData()
        }
    }
    
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
        //서치바+네비바
        setupSearchController()
        allTasks = repository.fetch()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // toolbar 관련
        writeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(tapWriteButton))
        writeButton.tintColor = Constants.button.color
        var items = [UIBarButtonItem]()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        [flexibleSpace,flexibleSpace,flexibleSpace,flexibleSpace,writeButton].forEach {
            items.append($0)
        }
        
        
        self.toolbarItems = items
        
        fixMemo = RealmRepository().fixFetch()
        notfixMemo = RealmRepository().notFixFetch()
        
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
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = UIColor(named: "bgColor") //다크모드대응
        vc.select = false //작성하기
    }
    
    // 서치바+네비바
    func setupSearchController() {
        searchController.searchBar.placeholder = "검색"
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.toolbar.backgroundColor = UIColor(named: "bgColor") //다크모드대응
        view.backgroundColor = UIColor(named: "bgColor")
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
            // 고정메모개수 0개
            if fixMemo.count == 0 {
                return 1
            }
            // 고정메모개수 1개 아닐떄
            else {
                if notfixMemo.count == 0 {
                    return 1
                }else{
                    return 2
                }
            }
        }
    }

    //색션 타이틀
    func tableView(_ : UITableView, titleForHeaderInSection section: Int) -> String? {
        // 서치바로 검색할떄 타이틀명
        if self.isFiltering{
            return "\(filteredArr.count)개 찾음"
        }
        
        // 처음화면 타이틀명
        else{
            if section == 0 {
                if fixMemo.count == 0 {return "메모"}
                else {return "고정된메모"}
            }
            else {return "메모"}
        }
    }
    
    // row 개수
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
    
    // row 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 14
    }
    
    // cell 그리기
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
    //MARK: 검색창 따라 셀 제목,내용 색상변화
    func searchTitleText(object:  Results<RealmModel>,index: Int, cell: MemoListTableViewCell) ->  NSMutableAttributedString {
        //MARK: 타이틀(제목)
        let title: String = object[index].title
        let titleString = NSMutableAttributedString(string: title)
        var titleFirstIndex: Int = 0
        if let titleFirstRange = title.range(of: "\(searchController.searchBar.text!)", options: .caseInsensitive) {
            titleFirstIndex = title.distance(from: title.startIndex, to: titleFirstRange.lowerBound)
            titleString.addAttribute(.foregroundColor, value: UIColor.systemOrange, range: NSRange(location: titleFirstIndex, length: searchController.searchBar.text?.count ?? 0))
        }
        return titleString
    }
    
    func searchContentColor(object:  Results<RealmModel>,index: Int, cell: MemoListTableViewCell) ->  NSMutableAttributedString {
        //MARK: 컨텐츠(내용)
        let content: String = object[index].content
        let contentString = NSMutableAttributedString(string: content)
        var contentFirstIndex: Int = 0
        if let contentFirstRange = content.range(of: "\(searchController.searchBar.text!)", options: .caseInsensitive) {
            contentFirstIndex = content.distance(from: content.startIndex, to: contentFirstRange.lowerBound)
            contentString.addAttribute(.foregroundColor, value: UIColor.systemOrange, range: NSRange(location: contentFirstIndex, length: searchController.searchBar.text?.count ?? 0))
        }
        return contentString
    }
    
    
    // 날짜 계산
    func dateCalc(date: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "ko_KR")// 한국 시간 지정
        dateFormat.timeZone = TimeZone(abbreviation: "KST") // 한국 시간대 지정
        let current = Calendar.current
       
        // 오늘 날짜이면
        if current.isDateInToday(date) {
            dateFormat.dateFormat  = "a hh:mm:ss"
            return dateFormat.string(from: date)
        }
        //MARK: 이번주구하기
        let nextWeekSunday = Calendar.current.nextWeekend(startingAfter: date)!.end // 다음주 일요일 시간
        var thisWeekmonday = Date(timeInterval: (-(86400) * 14) + 32400, since: nextWeekSunday) //이번주 월요일 밤12시
        var nextWeekMonday =  Date(timeInterval: 86400 * 7 , since: thisWeekmonday).timeIntervalSince1970 // 다음주 월요일 오전12시

        // 이번주월요일~ 이번주일요일(다음주 월요일 오전12시까지) 에 작성한날짜가 포함되있나?
        if current.dateIntervalOfWeekend(containing: date, start: &thisWeekmonday, interval: &nextWeekMonday) {
            dateFormat.dateFormat  = "EEEE"
            return dateFormat.string(from: date)
        }
        
        // 그이외이면
        else {
            dateFormat.dateFormat  = "yyyy.MM.dd a hh:mm"
            return dateFormat.string(from: date)
        }
    }
    
    // 테이블뷰 색션 텍스트 정보
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        header.textLabel?.textColor = UIColor(named: "sectionColor")

    }
    // 왼쪽 스와이핑(delete)
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
            }else{
                if editingStyle == .delete {
                    let item = notfixMemo[indexPath.row]
                    showDeleteAlert(message: "정말로 삭제할거냐?", item: item)
                }
            }
        }
    }
    // 삭제 앨럿 띄우기
    func showDeleteAlert(message: String, item: RealmModel) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { action in
            try! self.localRealm.write{
                self.localRealm.delete(item)
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
            let pinImage = filteredArr[indexPath.row].favorite ? "pin.slash.fill" : "pin.fill"
            favorite.image = UIImage(systemName: pinImage)
            return UISwipeActionsConfiguration(actions: [favorite])
        }
        
        else {
            if fixMemo.count == 0 {
                let pinImage = notfixMemo[indexPath.row].favorite ? "pin.slash.fill" : "pin.fill"
                favorite.image = UIImage(systemName: pinImage)
                return UISwipeActionsConfiguration(actions: [favorite])
            }
            else {
                if indexPath.section == 0 {
                    let pinImage = fixMemo[indexPath.row].favorite ? "pin.slash.fill" : "pin.fill"
                    favorite.image = UIImage(systemName: pinImage)
                    return UISwipeActionsConfiguration(actions: [favorite])
                } else {
                    let pinImage = notfixMemo[indexPath.row].favorite ? "pin.slash.fill" : "pin.fill"
                    favorite.image = UIImage(systemName: pinImage)
                    return UISwipeActionsConfiguration(actions: [favorite])
                }
            }
        }
    }
    
    
    // 셀 클릭시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isFiltering {
            modifyTextView(object: filteredArr, tag: indexPath.row)
        }
        else{
            if indexPath.section == 0 {
                if fixMemo.count == 0{modifyTextView(object: notfixMemo, tag: indexPath.row)}
                else{modifyTextView(object: fixMemo, tag: indexPath.row)}
                return
            }
            else {modifyTextView(object: notfixMemo, tag: indexPath.row)}
        }
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
extension MemoListViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        self.filteredArr = self.allTasks.filter("title CONTAINS[c] %@ OR content CONTAINS[c] %@",text,text)
              
    }
}


