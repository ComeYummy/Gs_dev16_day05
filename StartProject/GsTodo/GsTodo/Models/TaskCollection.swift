//
//  TaskCollection.swift
//  GsTodo
//
//  Created by yamamototatsuya on 2020/01/15.
//  Copyright © 2020 yamamototatsuya. All rights reserved.
//

import Foundation

protocol TaskCollectionDelegate: class {
    func saved()
    #warning("loaded を追加")

}

class TaskCollection {
    //初回アクセスのタイミングでインスタンスを生成
    static var shared = TaskCollection()
    //外部からの初期化を禁止
    private init(){}
    
    //外部からは参照のみ許可 // ここに全ての情報が持っている！！！
    private(set) var tasks: [Task] = []
    
    #warning("ここにUserDefaults で使うキーを置いておく。打ち間違いを減らすように。")

    
    //弱参照して循環参照を防ぐ
    weak var delegate: TaskCollectionDelegate?
    
    func addTask(_ task: Task) {
        tasks.append(task)
        save()
    }
    
    #warning("editTask を追加")
    
    
    
    #warning("removeTask を追加")
    
    
    
    func save() {
        #warning("UserDefaults の保存の処理")
        
        delegate?.saved()
    }
    
    
    #warning("load の処理")

}
