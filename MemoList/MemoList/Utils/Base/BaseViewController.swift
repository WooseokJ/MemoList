//
//  BaseViewController.swift
//  MemoList
//
//  Created by useok on 2022/08/31.
//

import UIKit
import Zip
import RealmSwift

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
    }

    func configure() { }
    func setConstraints() { }
    
    //고정메모 5개 초과 알람
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func documentDirectoryPath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil} //Document 경로
        return documentDirectory
    }
    
    // 백업관련
    func backupButtonClickedStart() {
        
        var urlPaths = [URL]() // 빈배열 타입이 URL
        
        //  도큐먼트 위치에 백업파일 확인
        guard let path = documentDirectoryPath() else { // path는 도큐먼트 경로
            showAlert(message: "documnet 위치에 오류가있음")
            return
        }
        let realFile = path.appendingPathComponent("default.realm") // 도큐먼트경로/default.realm
        guard FileManager.default.fileExists(atPath: realFile.path) else { // 경로에 파일이 존재하는지 확인
            showAlert(message: "백업할 파일이 없습니다.")
            return
        }
        let backUpFileURL = URL(string: realFile.path)! //realFile와 같은경로라서 backUpFileURL과 동일
        urlPaths.append(backUpFileURL) //
        // 백업파일압축: URL   (https://github.com/marmelroy/Zip.git)
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "memoInfo") // Zip
            print("Archive location: \(zipFilePath)")
            // activityviewController
            showActivityViewController()
        } catch {
            showAlert(message: "압축실패")
        }

    }
    // activityviewController 성공할떄
    func showActivityViewController() {
        guard let path = documentDirectoryPath() else {
            showAlert(message: "도큐먼트 위치 오류 ")
            return
        }
        let backupFileURL = path.appendingPathComponent("memoInfo.zip")
        
        let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: [] ) //activityItems: 어떤거보낼래?
        self.present(vc,animated: true)
    }
    
   

}

extension MemoListViewController {
//    func searchColorText(object:  Results<RealmModel>,index: Int, cell: MemoListTableViewCell) ->  MemoListTableViewCell {
//        let filtering = object[index]
//        //MARK: 컨텐츠(내용)
//        let content: String = filtering.content
//        
//        let contentString = NSMutableAttributedString(string: content)
//        cell.contentLabel.text = filtering.content
//        cell.title.text = filtering.title
//        cell.date.text = dateCalc(date: filtering.regDate)
//        
//        var contentFirstIndex: Int = 0
//        if let contentFirstRange = content.range(of: "\(searchController.searchBar.text!)", options: .caseInsensitive) {
//            contentFirstIndex = content.distance(from: content.startIndex, to: contentFirstRange.lowerBound)
//            contentString.addAttribute(.foregroundColor, value: UIColor.systemOrange, range: NSRange(location: contentFirstIndex, length: searchController.searchBar.text?.count ?? 0))
//        }
//        //MARK: 타이틀(제목)
//        let title: String = filtering.title
//        let titleString = NSMutableAttributedString(string: title)
//        var titleFirstIndex: Int = 0
//        if let titleFirstRange = title.range(of: "\(searchController.searchBar.text!)", options: .caseInsensitive) {
//            titleFirstIndex = title.distance(from: title.startIndex, to: titleFirstRange.lowerBound)
//            titleString.addAttribute(.foregroundColor, value: UIColor.systemOrange, range: NSRange(location: titleFirstIndex, length: searchController.searchBar.text?.count ?? 0))
//        }
//
//        cell.contentLabel.attributedText = contentString
//        cell.title.attributedText = titleString
//        cell.selectionStyle = .none
//        return cell
//    }
//    
//    // 날짜 계산
//    func dateCalc(date: Date) -> String {
//        let dateformat = DateFormatter()
//        dateformat.locale = Locale(identifier: "ko_KR")
//        
//        let current = Calendar.current
//        if current.isDateInToday(date) { //오늘 날짜이면
//            dateformat.dateFormat  = "a hh:ss"
//            return dateformat.string(from: date)
//        }
//        else if current.isDateInWeekend(date) { //이번주 이면
//            dateformat.dateFormat  = "EEEE"
//            return dateformat.string(from: date)
//        }
//        else { //그이외이면
//            dateformat.dateFormat  = "yyyy:mm:dd a hh:ss"
//            return dateformat.string(from: date)
//        }
//        
//    }
}
