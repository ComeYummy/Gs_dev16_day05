//
//  TaskListViewController.swift
//  GsTodo
//
//  Created by yamamototatsuya on 2020/01/15.
//  Copyright © 2020 yamamototatsuya. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    // task情報の一覧。ここに全ての情報を保持しています！
    var tasks: [Task] = []

    // UserDefaults に使うキー
    let userDefaultsTasksKey = "user_tasks"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableViewのお約束その１。この ViewController で delegate のメソッドを使うために記述している。
        tableView.delegate = self
        // tableViewのお約束その２。この ViewController で datasouce のメソッドを使うために記述している。
        tableView.dataSource = self

        // CustomCellの登録。忘れがちになるので注意！！
        // nibの読み込み。nib と xib はほぼ一緒
        let nib = UINib(nibName: "CustomCell", bundle: nil)
        // tableView に使う xib ファイルを登録している。
        tableView.register(nib, forCellReuseIdentifier: "CustomCell")
        
        setupNavigationBar()
    }

    // 画面描画のたびにtableViewを更新
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("👿viewWillAppearが呼ばれたよ")
        // UserDefaultsから読み出し
        loadFromUserDefaults()
        dump(tasks)
        reloadTableView()
    }

    // navigation barの設定
    private func setupNavigationBar() {
        let rightButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddScreen))
        navigationItem.rightBarButtonItem = rightButtonItem
    }

    // navigation barのaddボタンをタップされたときの動作
    @objc func showAddScreen() {
        let vc = AddViewController()
        vc.tasks = tasks
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UITableView
    
    /// 1つの Section の中の Row　の数を定義する(セルの数を定義)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 登録したセルを使う。 as! CustomCell としないと、UITableViewCell のままでしか使えない。
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.titleLabel?.text = tasks[indexPath.row].title
        return cell
    }
    
    #warning("ここにタップした時の処理を入れる")
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddViewController()
        vc.selectIndex = indexPath.row
        vc.tasks = tasks
        navigationController?.pushViewController(vc, animated: true)
    }
    
    #warning("ここにスワイプして削除する時の処理を入れる")
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tasks.remove(at: indexPath.row)
        saveToUserDefaults()
        reloadTableView()
    }

    func reloadTableView() {
        tableView.reloadData()
    }

    #warning("UserDefaults の保存の処理")
    func saveToUserDefaults() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(tasks)
            UserDefaults.standard.set(data, forKey: userDefaultsTasksKey)
        } catch {
            print(error)
        }
    }

    #warning("UserDefaults から読むこむ処理")
    func loadFromUserDefaults() {
        let decoder = JSONDecoder()
        do {
            guard let data = UserDefaults.standard.data(forKey: userDefaultsTasksKey) else {
                return
            }
            tasks = try decoder.decode([Task].self, from: data)
        } catch {
            print(error)
        }
    }
    
}
