//
//  File.swift
//  MemoList
//
//  Created by useok on 2022/08/31.
//

import Foundation
import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
    }
    
    func setConstraints() {
        
    }
}
