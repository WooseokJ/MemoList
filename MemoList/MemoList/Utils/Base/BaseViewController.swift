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

}
