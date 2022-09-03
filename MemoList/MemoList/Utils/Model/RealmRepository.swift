
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
    func fixFetch() -> Results<RealmModel> {
        return localRealm.objects(RealmModel.self).sorted(byKeyPath: "regDate", ascending: false)
    }
    func notFixFetch() -> Results<RealmModel> {
        return localRealm.objects(RealmModel.self).sorted(byKeyPath: "regDate", ascending: false)
    }
    
    
    func updateFavorite(item: RealmModel) {
        try! self.localRealm.write {
            
            item.favorite.toggle()
        }
    }
    
}
