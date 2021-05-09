//
//  ListViewController.swift
//  Anniversary
//
//  Created by Kazuma Adachi on 2021/01/31.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableview: UITableView!
    
    var itemList: Results<Item>!
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.itemList = realm.objects(Item.self).sorted(byKeyPath: "date", ascending: true)
        tableview.reloadData()

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    
    
    //追加④ セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let dateLabel = cell.contentView.viewWithTag(1) as! UILabel
        dateLabel.text = itemList[indexPath.row].date
        
        let titleLabel = cell.contentView.viewWithTag(2) as! UILabel
        titleLabel.text = itemList[indexPath.row].title
        
        // セルに表示する値を設定する
        
        return cell
    }

    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            do{
                let realm = try Realm()
                try realm.write {
                    realm.delete(self.itemList[indexPath.row])
                }
                
            }catch{
            }
            tableView.reloadData()
        }
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

