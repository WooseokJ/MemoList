//
//  WriteViewController+Extension.swift
//  MemoList
//
//  Created by useok on 2022/09/09.
//

import Foundation
import UIKit

extension WriteViewController {
    
    //MARK: 네비바 디자인
    internal func setNaviBarDesign(title: String, imageName: String) {
        let confirm = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(tapConfirm))
        let shared = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        confirm.tintColor = Constants.button.color
        shared.tintColor = Constants.button.color
        navigationItem.rightBarButtonItems = [confirm,shared]
    }
    

    
    //MARK: 공유하기버튼클릭
    @objc internal func shareButtonClicked() {
        guard let text = writeView.textView.text else { return }
        var shareObject: [String] = []
        shareObject.append(text)
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.mail]
        self.present(activityViewController, animated: true, completion: nil)
            
    }
  
    
    //MARK: 수정하기 버튼 클릭
    @objc internal func tapModify() {
        modify()
        self.navigationController?.popViewController(animated: true)

    }
    //MARK: 수정하기 기능
    internal func modify() {
        let text = writeView.textView.text.split(separator: "\n",maxSplits: 1)
        // 제목X 내용 X
        guard text.count != 0 else {
            repository.modifyData(title: "", content: "", text: text, objectid: objectid)
            return
        }
        // 제목 O 내용 X
        guard text.count != 1 else {
            repository.modifyData(title: String(text[0]), content: "", text: text,objectid: objectid)

            return
        }
        let content = text[1...text.count-1].joined()

        // 제목,내용 O
        repository.modifyData(title: String(text[0]), content: content, text: text, objectid: objectid)
    }
    
    //MARK: 확인버튼 클릭시
    @objc internal func tapConfirm() {
        let text = writeView.textView.text.split(separator: "\n",maxSplits: 1)
        // 제목X 내용 X
        guard text.count != 0  else {
            repository.addData(title: "", content: "")
            self.navigationController?.popViewController(animated: true)

            return
        }
        // 제목 O 내용 X
        guard text.count != 1 else {
            repository.addData(title: String(text[0]), content: "")
            self.navigationController?.popViewController(animated: true)

            return
        }
        let content = text[1...text.count-1].joined()
        
        // 제목,내용 O
        repository.addData(title: String(text[0]), content: content)
        self.navigationController?.popViewController(animated: true)
    }
}
