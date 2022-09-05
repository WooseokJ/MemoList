//
//  WrtieViewController.swift
//  MemoList
//
//  Created by useok on 2022/08/31.
//

import UIKit
import RealmSwift

final class WriteViewController: BaseViewController ,UITextFieldDelegate {
    
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
    //MARK: 변수선언
    var select: Bool? = nil // 작성하기,수정하기 판단
    var objectid: ObjectId? // 객체아이디 받아와 수정시 사용
    
    override func viewWillAppear(_ animated: Bool) {
        self.writeView.textView.becomeFirstResponder() //키보드 자동으로 띄우기
        self.navigationController?.isToolbarHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        modify()
        allTasks = RealmRepository().fetch()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = Constants.button.color
        self.navigationItem.largeTitleDisplayMode = .never
        guard select == false else {
            //MARK: 수정하기화면
            setNaviBarDesign(title: "수정", imageName: "square.and.arrow.up")
            return
        }
        //MARK: 작성하기화면
        setNaviBarDesign(title: "확인", imageName: "square.and.arrow.up")

    }
    //MARK: 서치바 디자인
    func setNaviBarDesign(title: String, imageName: String) {
        let confirm = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(tapConfirm))
        let shared = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        confirm.tintColor = Constants.button.color
        shared.tintColor = Constants.button.color
        navigationItem.rightBarButtonItems = [confirm,shared]
    }
    
    
    
    //MARK: 확인버튼 클릭시
    @objc func tapConfirm() {
        let text = writeView.textView.text.split(separator: "\n",maxSplits: 1)
        // 제목X 내용 X
        guard text.count != 0  else {
            addData(title: "", content: "")
            self.navigationController?.popViewController(animated: true)

            return
        }
        // 제목 O 내용 X
        guard text.count != 1 else {
            addData(title: String(text[0]), content: "")
            self.navigationController?.popViewController(animated: true)

            return
        }
        let content = text[1...text.count-1].joined()
        
        // 제목,내용 O
        addData(title: String(text[0]), content: content)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: 작성하기로 데이터 삽입
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
    
    //MARK: 공유하기버튼클릭
    @objc func shareButtonClicked() {
        guard let text = WriteView().textView.text else { return }
        var shareObject: [String] = []
        shareObject.append(text)
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.mail]
        self.present(activityViewController, animated: true, completion: nil)
            
    }
    //MARK: 수정하기 버튼 클릭
    @objc func tapModify() {
        modify()
        self.navigationController?.popViewController(animated: true)

    }
    //MARK: 수정하기 기능
    func modify() {
        let text = writeView.textView.text.split(separator: "\n",maxSplits: 1)
        // 제목X 내용 X
        guard text.count != 0 else {
            modifyData(title: "", content: "", text: text)
            return
        }
        // 제목 O 내용 X
        guard text.count != 1 else {
            modifyData(title: String(text[0]), content: "", text: text)

            return
        }
        let content = text[1...text.count-1].joined()

        // 제목,내용 O
        modifyData(title: String(text[0]), content: content, text: text)
    }
    
    
    //MARK: 수정하기로 데이터 수정
    func modifyData(title: String, content: String, text:  [String.SubSequence]) {
        guard let objectid = objectid else {
            return
        }

        do {
            try localRealm.write {
                localRealm.create(RealmModel.self, value: ["objectId": objectid, "title": title, "content":content, "regDate": Date()], update: .modified)
            }
        } catch let error {
            print(error)
        }
    }
    
}
