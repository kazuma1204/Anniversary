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
    
    var selectDate: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        myCalendar.delegate = self
        tableview.dataSource = self
        tableview.delegate = self
        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
