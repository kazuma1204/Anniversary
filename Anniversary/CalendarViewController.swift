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

        myCalendar.dataSource = self
        myCalendar.delegate = self
        tableview.dataSource = self
        tableview.delegate = self
        
        self.myCalendar.appearance.headerDateFormat = "YYYY/MM"
        self.myCalendar.calendarWeekdayView.weekdayLabels[0].text = "日"
        self.myCalendar.calendarWeekdayView.weekdayLabels[1].text = "月"
        self.myCalendar.calendarWeekdayView.weekdayLabels[2].text = "火"
        self.myCalendar.calendarWeekdayView.weekdayLabels[3].text = "水"
        self.myCalendar.calendarWeekdayView.weekdayLabels[4].text = "木"
        self.myCalendar.calendarWeekdayView.weekdayLabels[5].text = "金"
        self.myCalendar.calendarWeekdayView.weekdayLabels[6].text = "土"
        // Do any additional setup after loading the view.
    }
    
//    カレンダー下セルから移動用
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVC3" {
            let DisplayViewController = segue.destination as!  DisplayViewController
            DisplayViewController.date = selectItem?.date
            DisplayViewController.title = selectItem?.title
            DisplayViewController.content = selectItem?.content
            DisplayViewController.selectId = selectItem?.id
        } else if segue.identifier == "toVC2" {
            let RecordViewController = segue.destination as!  RecordViewController
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd"
            let date = "\(formatter.string(from: selectDate))"
            RecordViewController.date = date
        }
        
    }
    
//    カレンダー下セルから移動用
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectItem = itemList[indexPath.row]
        performSegue(withIdentifier: "toVC3", sender: nil)
        selectItem = nil
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        let date = "\(formatter.string(from: selectDate))"
        self.itemList = realm.objects(Item.self).filter("date == %@", date)
        tableview.reloadData()
        myCalendar.reloadData()
        
    }
    
    // 選択した日付が変更されるたびに呼ばれる
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
         print("select")
        selectDate = date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
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
    
    // イベントの数を決めている
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int{
           var tmpList: Results<Item>!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        let datetext = "\(formatter.string(from: date))"
        
           // 対象の日付が設定されているデータを取得する
           do {
               let realm = try Realm()
               tmpList = realm.objects(Item.self).filter("date == %@", datetext)
           } catch {
           }
           return tmpList.count
       }

       // 日の始まりと終わりを取得
       private func getBeginingAndEndOfDay(_ date:Date) -> (begining: Date , end: Date) {
           let begining = Calendar(identifier: .gregorian).startOfDay(for: date)
           let end = begining + 24*60*60
           return (begining, end)
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
