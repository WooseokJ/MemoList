//
//  RealmModel.swift
//  MemoList
//
//  Created by useok on 2022/08/31.
//

import Foundation
import RealmSwift

class RealmModel: Object {
    @Persisted(primaryKey: true) var objectId: ObjectId // 객체id(개인키)
    @Persisted var title: String // 제목
    @Persisted var contentChanged: String // 내용
    @Persisted var regDate: Date //날짜
    
//    @Persisted var addData1: Int // 추가 데이터
    @Persisted var titlePlusContentChaged: String
    @Persisted var defaultVal: String
    
    @Persisted var favorite: Bool // 고정핀
    
    convenience init(title: String, content: String, regDate: Date) {
        self.init()
        self.title = title
        self.contentChanged = content
        self.regDate = regDate
        self.favorite = false
    }
}
