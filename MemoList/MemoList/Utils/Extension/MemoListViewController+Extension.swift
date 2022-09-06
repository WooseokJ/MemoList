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
    //MARK: 검색창 따라 셀 내용 색상변화
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
    
    
    //MARK:  날짜 계산
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
}
