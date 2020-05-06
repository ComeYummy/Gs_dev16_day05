//
//  UserDefaultsRepository.swift
//  GsTodo
//
//  Created by Naoki Kameyama on 2020/05/06.
//  Copyright © 2020 yamamototatsuya. All rights reserved.
//

import Foundation

class UserDefaultsRepository {
    // UserDefaults に使うキー
    static let userDefaultsTasksKey = "user_tasks"

    #warning("UserDefaults の保存の処理")
    static func saveToUserDefaults(_ tasks: [Task]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(tasks)
            UserDefaults.standard.set(data, forKey: userDefaultsTasksKey)
        } catch {
            print(error)
        }
    }

    #warning("UserDefaults から読むこむ処理")
    static func loadFromUserDefaults() -> [Task] {
        let decoder = JSONDecoder()
        do {
            guard let data = UserDefaults.standard.data(forKey: userDefaultsTasksKey) else {
                return []
            }
            let tasks = try decoder.decode([Task].self, from: data)
            return tasks
        } catch {
            print(error)
            return []
        }
    }
}
