//
//  WrtieViewController.swift
//  MemoList
//
//  Created by useok on 2022/08/31.
//

import UIKit
import RealmSwift

final class WriteViewController: BaseViewController, UITextFieldDelegate  {
    
    //MARK: 뷰 불러오기
    let writeView = WriteView()
    
    override func loadView() {
        super.view = writeView
    }
    
    //MARK: realm 관련
    let repository = RealmRepository()

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
        navigationController?.isToolbarHidden = true
        navigationController?.navigationBar.tintColor = Constants.button.color
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = UIColor(named: "bgColor") //다크모드대응
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        modify()
        allTasks = RealmRepository().fetch()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard select == false else {
            //MARK: 수정하기화면
            setNaviBarDesign(title: "수정", imageName: "square.and.arrow.up")
            return
        }
        //MARK: 작성하기화면
        setNaviBarDesign(title: "확인", imageName: "square.and.arrow.up")
    }
}
