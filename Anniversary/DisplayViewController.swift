//
//  DisplayViewController.swift
//  Anniversary
//
//  Created by Kazuma Adachi on 2021/05/11.
//

import UIKit
import RealmSwift

class DisplayViewController: UIViewController {
    
    var date: String!
    var content: String!
    var selectId: Int!
    
  

    var itemList: Results<Item>!
    let realm = try! Realm()
    
//    コンテントが！だからワンチャンクラッシュする説
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentLabel.layer.borderColor = UIColor.orange.cgColor
               //線の太さ(太さ)
               self.contentLabel.layer.borderWidth = 2
        
//        //　ナビゲーションバーの背景色
//            self.navigationController?.navigationBar.barTintColor = .orange
            // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
            self.navigationController?.navigationBar.tintColor = .orange
//            // ナビゲーションバーのテキストを変更する
//            self.navigationController?.navigationBar.titleTextAttributes = [
//            // 文字の色
//                .foregroundColor: UIColor.white
//            ]

        // Do any additional setup after loading the view.
    }
    
//    テレキャスターボーイ
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        データの再取得
        let selectKB = realm.objects(Item.self).filter("id = \(selectId!)").first!
        
        content = selectKB.content
        title = selectKB.title
        date = selectKB.date
        
        contentLabel.text = content
        titleLabel.text = title
        dateLabel.text = date
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVC0" {
            let RecordViewController = segue.destination as!  RecordViewController
            RecordViewController.date = date
            RecordViewController.title = title
            RecordViewController.content = content
            RecordViewController.selectId = selectId
        }
    }
    
    @IBAction func edit(for segue: UIStoryboardSegue, sender: Any?) {
        performSegue(withIdentifier: "toVC0", sender: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
