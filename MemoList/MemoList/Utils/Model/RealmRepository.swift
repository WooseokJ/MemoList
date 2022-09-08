
import Foundation
import RealmSwift

protocol RealmRepositoryType { //만든이유:  1.어떤메서드들이 있는지 보기편하기위함.
                                    //   2.Realm테이블이 여러개가 되면 CRUD는 잇는데 같은메서드를사용하기떄문에
    func fetch() -> Results<RealmModel>

}

class RealmRepository: RealmRepositoryType {

    let localRealm = try! Realm() //


    func fetch() -> Results<RealmModel> {
        return localRealm.objects(RealmModel.self).sorted(byKeyPath: "regDate", ascending: false)
    }
    func fixFetch() -> Results<RealmModel> {
        return localRealm.objects(RealmModel.self).filter("favorite = true").sorted(byKeyPath: "regDate", ascending: false)
    }
    func notFixFetch() -> Results<RealmModel> {
        return localRealm.objects(RealmModel.self).filter("favorite = false").sorted(byKeyPath: "regDate", ascending: false)
    }
    
    func updateFavorite(item: RealmModel) {
        try! self.localRealm.write {   
            item.favorite.toggle()
        }
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
  
     }
    
    //MARK: 수정하기로 데이터 수정
    func modifyData(title: String, content: String, text:  [String.SubSequence], objectid: ObjectId?) {
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
