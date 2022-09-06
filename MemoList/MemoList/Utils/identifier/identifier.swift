//
//  identidier.swift
//  MemoList
//
//  Created by useok on 2022/08/31.
//

import Foundation
import UIKit

protocol ReuseIdentifier {
    static var reuseIdentifier: String { get }
}

extension NSObject: ReuseIdentifier {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
