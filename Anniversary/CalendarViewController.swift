//
//  CalendarViewController.swift
//  Anniversary
//
//  Created by Kazuma Adachi on 2021/01/31.
//

import UIKit
import RealmSwift
import FSCalendar

class CalendarViewController: UIViewController, UITableViewDelegate, FSCalendarDelegate, FSCalendarDataSource, UITableViewDataSource {
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet var myCalendar: FSCalendar!
    
    var itemList: Results<Item>!
    let realm = try! Realm()
    
    

//    これ、一個したのやつとバッティングするかも.カレンダー下セルから移動用
    var selectItem: Item?
    
    
    var selectDate: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        myCalendar.delegate = self
        tableview.dataSource = self
        tableview.delegate = self
        // Do any additional setup after loading the view.
    }
    
//    カレンダー下セルから移動用
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVC2" {
            let RecordViewController = segue.destination as!  RecordViewController
            RecordViewController.date = selectItem?.date
            RecordViewController.title = selectItem?.title
            RecordViewController.content = selectItem?.content
            RecordViewController.selectId = selectItem?.id
        }
    }
    
//    カレンダー下セルから移動用
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectItem = itemList[indexPath.row]
        performSegue(withIdentifier: "toVC2", sender: nil)
        selectItem = nil
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let date = "\(formatter.string(from: selectDate))"
        self.itemList = realm.objects(Item.self).filter("date == %@", date)
        tableview.reloadData()
    }
    
    // 選択した日付が変更されるたびに呼ばれる
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
         print("select")
        selectDate = date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let date = "\(formatter.string(from: date))"
        self.itemList = realm.objects(Item.self).filter("date == %@", date)
        tableview.reloadData()
     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        let titleLabel = cell.contentView.viewWithTag(1) as! UILabel
        titleLabel.text = itemList[indexPath.row].title
        
        let contentLabel = cell.contentView.viewWithTag(2) as! UILabel
        contentLabel.text = itemList[indexPath.row].content
        
        
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
