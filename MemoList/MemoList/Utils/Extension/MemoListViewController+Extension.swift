//
//  MemoListViewController+Extension.swift
//  MemoList
//
//  Created by useok on 2022/09/06.
//

import Foundation

import RealmSwift
import UIKit

extension MemoListViewController {
    
    //MARK: 검색창 따라 셀 제목 색상변화
    internal func searchTitleText(object:  Results<RealmModel>,index: Int, cell: MemoListTableViewCell) ->  NSMutableAttributedString {
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
    //MARK: 검색창 따라 셀 내용 색상변화
    internal func searchContentColor(object:  Results<RealmModel>,index: Int, cell: MemoListTableViewCell) ->  NSMutableAttributedString {
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
    
    
    //MARK:  날짜 계산
    internal func dateCalc(date: Date) -> String {
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
    //MARK: 툴바 디자인 설정
    internal func setToolbarDesign() {
        writeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(writeButtonClicked))
        writeButton.tintColor = Constants.button.color
        var items = [UIBarButtonItem]()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        [flexibleSpace,flexibleSpace,flexibleSpace,flexibleSpace,writeButton].forEach {
            items.append($0)
        }
        
        self.toolbarItems = items
        
    }
    
    //MARK: 작성하기 버튼 클릭시
    @objc internal func writeButtonClicked(){
        let vc = WriteViewController()
        transition(vc, transitionStyle: .push)
        navigationItem.backButtonTitle = navigationItem.title
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = UIColor(named: "bgColor") //다크모드대응
        vc.select = false //작성하기
    }
    
    //MARK:  서치바+네비바
    internal func setupSearchController() {
        searchController.searchBar.placeholder = "검색"
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController 
        self.navigationItem.hidesSearchBarWhenScrolling = false // 서치바스크롤 숨기기
        self.navigationController?.isToolbarHidden = false //툴바가리기여부
        self.navigationController?.navigationBar.prefersLargeTitles = true // 라지타이틀
        self.navigationController?.toolbar.backgroundColor = UIColor(named: "bgColor") //다크모드대응
        view.backgroundColor = UIColor(named: "bgColor")
    }
    
    //MARK: 팝업 화면 띄우기
    internal func popupPresent() {
        guard !UserDefaults.standard.bool(forKey: "first") else{
            return
        }
        let vc = PopUpViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        transition(vc, transitionStyle: .present)
    }
}

extension MemoListViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    //MARK: 서치바 검색할떄마다
    internal func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        self.filteredArr = self.allTasks.filter("title CONTAINS[c] %@ OR content CONTAINS[c] %@",text,text)
              
    }
}
