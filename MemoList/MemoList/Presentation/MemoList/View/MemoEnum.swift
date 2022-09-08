//
//  MemoEnum.swift
//  MemoList
//
//  Created by useok on 2022/09/08.
//

import Foundation

enum FilterCheck: CaseIterable { // 열거형 타입 배열처럼 다루기

    case filter, notfilter
    var check: Bool {
        switch self {
        case .filter:
            return true
        case .notfilter:
            return false
        }
    }
}



enum fixCheck: CaseIterable {
    case fix,notfix
    var check: Bool {
        switch self {
        case .fix:
            return true
        case .notfix:
            return false
        }
    }
}
