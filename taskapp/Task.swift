//
//  Task.swift
//  taskapp
//
//  Created by Taro Sakamoto on 9/5/16.
//  Copyright © 2016 Tarou Sakamoto. All rights reserved.
//

import UIKit
import RealmSwift

class Task: Object {
    dynamic var id = 0
    
    // タイトル
    dynamic var title = ""
    
    // 内容
    dynamic var contents = ""
    
    /// 日時
    dynamic var date = NSDate()
    // カテゴリー
    dynamic var category = String ("")
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
}
