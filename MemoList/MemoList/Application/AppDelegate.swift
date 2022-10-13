//
//  AppDelegate.swift
//  MemoList
//
//  Created by useok on 2022/08/31.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        migrate()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }


}


extension AppDelegate {
    func migrate() {
        let config = Realm.Configuration (
            schemaVersion: 6) { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 { // realm addData 추가
                }
                
                if oldSchemaVersion < 2 { // realm addData 삭제
                    
                }
                if oldSchemaVersion < 3 {  // content -> contentChanged로 수정시
                    migration.renameProperty(onType: RealmModel.className(), from: "content", to: "contentChanged")
                }
                if oldSchemaVersion < 4 { // 기존컬럼 합쳐서 새로운컬럼만듬.
                    migration.enumerateObjects(ofType: RealmModel.className()) { oldObject, newObject in
                        guard let old = oldObject else {return}
                        guard let new = newObject else {return}
                        new["titlePlusContentChaged"] = "\(old)+\(new)"
                    }
                }
                if oldSchemaVersion < 5 { //기본값(String값 넣기) 넣어서 DB에 저장
                    migration.enumerateObjects(ofType: RealmModel.className()) { _, newObject in
                        guard let new = newObject else {return}
                        new["defaultVal"] = "과제용으로 하는중"
                    }
                }
                if oldSchemaVersion < 6 { // addData1 타입 String -> Int
                    migration.enumerateObjects(ofType: RealmModel.className()) { oldObject, newObject in
                        guard let new = newObject else {return}
                        guard let old = oldObject else {return}
                        new["addData1"] = old["addData1"]
                    }
                }
                
            }
        Realm.Configuration.defaultConfiguration = config
        
    }
}
