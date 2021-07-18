//
//  ListViewController.swift
//  Anniversary
//
//  Created by Kazuma Adachi on 2021/01/31.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var itemList: Results<Item>!
    let realm = try! Realm()
    
    var selectItem: Item?
    
    

    var searchResult: [Item]!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        searchBar.delegate = self
        searchBar?.enablesReturnKeyAutomatically = false
        
 
        itemList = realm.objects(Item.self)
        searchResult = Array(itemList)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        レルム内の並び替え（sort）
        self.itemList = realm.objects(Item.self).sorted(byKeyPath: "date", ascending: true)
        print(itemList)
        searchResult = Array(itemList)
        tableview.reloadData()
        print(searchResult)
    }
    
//    再編集のために入れてみた。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVC" {
            let DisplayViewController = segue.destination as!  DisplayViewController
            DisplayViewController.date = selectItem?.date
            DisplayViewController.title = selectItem?.title
            DisplayViewController.content = selectItem?.content
            DisplayViewController.selectId = selectItem?.id
        }
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    
     
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //検索結果配列を空にする。
        searchResult.removeAll()

            if searchBar.text == "" {
                //検索文字列が空の場合はすべてを表示する。
                searchResult = Array(itemList)
            } else {
                //検索文字列を含むデータを検索結果配列に追加する。
                for data in itemList {
                    if data.title!.contains(searchBar.text!) {
                        searchResult.append(data)
                    }
                }
            }

            //テーブルを再読み込みする。
            tableview.reloadData()
        //キーボードを閉じる。
        view.endEditing(true)
        if let word = searchBar.text {
                    // デバッグエリアに出力
                    print(word)
    }
    }
    
    
    //追加④ セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let dateLabel = cell.contentView.viewWithTag(1) as! UILabel
        dateLabel.text = searchResult[indexPath.row].date
        
        let titleLabel = cell.contentView.viewWithTag(2) as! UILabel
        titleLabel.text = searchResult[indexPath.row].title
        
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectItem = itemList[indexPath.row]
        performSegue(withIdentifier: "toVC", sender: nil)
        selectItem = nil
    }
    
    
   
    
    
    
    @IBAction func plus(for segue: UIStoryboardSegue, sender: Any?) {
        performSegue(withIdentifier: "toVC", sender: nil)
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

 
