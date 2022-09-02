//
//  WrtieViewController.swift
//  MemoList
//
//  Created by useok on 2022/08/31.
//

import UIKit
import RealmSwift

class WriteViewController: BaseViewController {
    
    let writeView = WriteView()
    
    override func loadView() {
        super.view = writeView
    }
    //MARK: realm 관련
    let localRealm = try! Realm()
    var allTasks: Results<RealmModel>! {
        didSet {
            print("Tasks Changed")
        }
    }
    
    var select: Bool? = nil // 작성하기,수정하기 판단
    var tag: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        writeView.textView.becomeFirstResponder() //키보드 자동으로 띄우기
        guard select == false else {
            // 수정하기화면
            let confirm = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(tapConfirm))
            let shared = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(tapShared))
            navigationItem.rightBarButtonItems = [confirm,shared]
            navigationItem.rightBarButtonItem?.tintColor = Constants.button.color
            return
        }
        //작성하기화면
        let confirm = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(tapConfirm))
        let shared = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(tapShared))
        navigationItem.rightBarButtonItems = [confirm,shared]
        navigationItem.rightBarButtonItem?.tintColor = Constants.button.color
    }
    
    
    
    //확인버튼 클릭시
    @objc func tapConfirm() {
        let text = writeView.textView.text.split(separator: "\n",maxSplits: 1)
        
        // 제목X 내용 X
        guard text.count != 0 else {
            addData(title: "", content: "")
            return
        }
        
        // 제목 O 내용 X
        guard text.count != 1 && text[1] != nil else {
            addData(title: String(text[0]), content: "")
            return
        }
        
        // 제목,내용 O
        let content = text[1].replacingOccurrences(of: "\n", with: " ")
        addData(title: String(text[0]), content: content)
        
        
        
    }
    // 작성하기로 데이터 삽입
    func addData(title: String, content: String) {
        let task = RealmModel(title: title, content: content, regDate: Date())
        do {
            try localRealm.write {
                localRealm.add(task)
            }
        } catch let error {
            print(error)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //공유하기버튼클릭
    @objc func tapShared() {
        
    }
    //수정하기 버튼 클릭
    @objc func tapModify() {
        let text = writeView.textView.text.split(separator: "\n",maxSplits: 1)
        
        // 제목X 내용 X
        guard text.count != 0 else {
            modifyData(title: "", content: "", text: text )
            return
        }
        
        // 제목 O 내용 X
        guard text.count != 1 && text[1] != nil else {
            modifyData(title: String(text[0]), content: "", text: text )
            return
        }
        
        // 제목,내용 O
        let content = text[1].replacingOccurrences(of: "\n", with: " ")
        modifyData(title: String(text[0]), content: content, text: text )
        
        
        //수정하기로 데이터 수정
        func modifyData(title: String, content: String, text:  [String.SubSequence] ) {
            do {
                try localRealm.write {
                    guard let tag = tag else {
                        return
                    }
                    allTasks[tag].title = String(text[0])
                    allTasks[tag].content = String(text[1])
                    allTasks[tag].regDate = Date()
                }
            } catch let error {
                print(error)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
}
