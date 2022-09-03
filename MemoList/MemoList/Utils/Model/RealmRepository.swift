
import Foundation
import RealmSwift

protocol RealmRepositoryType { //만든이유:  1.어떤메서드들이 있는지 보기편하기위함.
                                    //   2.Realm테이블이 여러개가 되면 CRUD는 잇는데 같은메서드를사용하기떄문에
    func fetch() -> Results<RealmModel>
//    func fetchSort(_ sort: String) -> Results<RealmModel>
//    func fetchFilter() -> Results<RealmModel>
//    func updateFavorite(item: RealmModel)
//    func deleteItem(item: RealmModel)
//    func addItem(item: RealmModel)
//    func fetchDate(date: Date) -> Results<RealmModel>
}

class RealmRepository: RealmRepositoryType {

    let localRealm = try! Realm() //


    func fetch() -> Results<RealmModel> {
        return localRealm.objects(RealmModel.self).sorted(byKeyPath: "regDate", ascending: false)
    }
    
    func updateFavorite(item: RealmModel) {
        try! self.localRealm.write {
            
            item.favorite.toggle()
        }
    }
//    func deleteItem(item: UserDiary) {
//        removeImageFromDocument(fileName: "\(item.objectId).jpg") //도큐먼트의 이미지 삭제 10
//        try! localRealm.write{
//            localRealm.delete(item) // 레코드 삭제
//        }
//
//
//
//    }
//    func removeImageFromDocument(fileName: String) {
//        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } //Document 경로
//        let fileURL = documentDirectory.appendingPathComponent(fileName) // 세부 경로. 이미지 저장할 위치
//        do {
//            try FileManager.default.removeItem(at: fileURL)
//        } catch let error {
//            print(error)
//        }
//    }
//    func addItem(item: UserDiary) {
//
//    }
//    func fetchDate(date: Date) -> Results<UserDiary> {
//        return localRealm.objects(UserDiary.self).filter("diaryDate >= %@ AND diaryDate < %@", date, Date(timeInterval: 86400, since: date)) // %@ 는 NSPredicate 서식문자같은거
//    }
//
}
