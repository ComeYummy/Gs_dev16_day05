//
//  AddViewController.swift
//  GsTodo
//
//  Created by yamamototatsuya on 2020/01/15.
//  Copyright © 2020 yamamototatsuya. All rights reserved.
//

import UIKit
#warning("ここに PKHUD を import しよう！")
import PKHUD

class AddViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!

    // TaskListViewControllerからコピーしたtasks
    var tasks: [Task] = []
    #warning("selectIndex を追加")
    var selectIndex: Int?

    // UserDefaults に使うキー
    let userDefaultsTasksKey = "user_tasks"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMemoTextView()
        setupNavigationBar()

        // 編集のときTask内容を表示させる
        configureTask()
    }
    
    // MARK: - UISetup
    private func setupMemoTextView() {
        memoTextView.layer.borderWidth = 1
        memoTextView.layer.borderColor = UIColor.lightGray.cgColor
        memoTextView.layer.cornerRadius = 3
    }
    
    private func setupNavigationBar() {
        title = "Add"
        let rightButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(tapSaveButton))
        navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    
    // MARK: - Other Method
    #warning("ここにEditかどうかの判定を入れる")
    private func configureTask() {
        if let index = selectIndex {
            title = "編集"
            titleTextField.text = tasks[index].title
            memoTextView.text = tasks[index].memo
        }
    }

    @objc func tapSaveButton() {
        print("Saveボタンを押したよ！")
        
        guard let title = titleTextField.text else {
            return
        }

        // titleが空白のときのエラー処理
        if title.isEmpty {
            print(title, "👿titleが空っぽだぞ〜")
            
            #warning("showAlert を PKHUD に変更しよう！")
            HUD.flash(.labeledError(title: nil, subtitle: "👿 タイトルが入力されていません！！！"), delay: 1)
            // showAlert("👿 タイトルが入力されていません！！！")
            return // return を実行すると、このメソッドの処理がここで終了する。
        }
        
        #warning("ここにEditかどうかの判定を入れる")
        // ここで Edit か Add　かを判定している
        if let index = selectIndex {
            // Edit
            tasks[index] = Task(title: title, memo: memoTextView.text)
            UserDefaultsRepository.saveToUserDefaults(tasks)
        } else {
            // Add
            let task = Task(title: title, memo: memoTextView.text)
            tasks.append(task)
            UserDefaultsRepository.saveToUserDefaults(tasks)
        }
        
        #warning("ここにHUD.flash の success を入れる")
        HUD.flash(.success, delay: 0.3)
        // 前の画面に戻る
        navigationController?.popViewController(animated: true)
    }

    // アラートを表示するメソッド
    func showAlert(_ text: String){
        let alertController = UIAlertController(title: "エラー", message: text , preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
}
