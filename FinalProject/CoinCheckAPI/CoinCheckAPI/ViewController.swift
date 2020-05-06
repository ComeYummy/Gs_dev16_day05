//
//  ViewController.swift
//  CoinCheckAPI
//
//  Created by Tatsuya Yamamoto on 2020/1/22.
//  Copyright © 2020 山本竜也. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    let formatter = DateFormatter()
    var lastPrice = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.locale = Locale(identifier: "ja_JP")
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(fetchTick))
        navigationItem.rightBarButtonItem = rightButton
        
        fetchTick()
    }
    
    @objc func fetchTick() {
        let requestURLString = "https://coincheck.com/api/ticker"
        AF.request(requestURLString)
            .responseJSON { response in
                switch(response.result) {
                    case .success:
                        guard let data = response.data else { return }
                        let tickerModel: TickerModel = try! JSONDecoder().decode(TickerModel.self, from: data)
                        let bid = tickerModel.bid
                        self.priceLabel.text = String(bid)
                        let now = Date(timeIntervalSince1970: TimeInterval(tickerModel.timeStamp))
                        self.dateLabel.text = self.formatter.string(from: now)

                        if bid > self.lastPrice {
                            self.view.backgroundColor = UIColor.red
                        } else if bid == self.lastPrice {
                            self.view.backgroundColor = UIColor.yellow
                        } else {
                            self.view.backgroundColor = UIColor.blue
                        }

                        self.lastPrice = bid
                    case .failure(let error):
                        print(error.errorDescription ?? "エラーが発生しました")
                    }
        }
    }
}


struct TickerModel: Codable {
    //https://coincheck.com/ja/documents/exchange/api#libraries
    let last: Int //最後の取引の価格
    let bid: Int //現在の買い注文の最高価格
    let ask: Int //現在の売り注文の最安価格
    let high: Int //24時間での最高取引価格
    let low: Int //24時間での最安取引価格
    let volume: Double //24時間での取引量
    let timeStamp: Int //現在の時刻
    
    enum CodingKeys: String, CodingKey {
        case last, bid, ask, high, low, volume
        case timeStamp = "timestamp" //　使う名前と受け取る名前が違う場合は名前を定義
    }
}

