//
//  RecordViewController.swift
//  Anniversary
//
//  Created by Kazuma Adachi on 2021/01/31.
//

import UIKit
import RealmSwift

class RecordViewController: UIViewController {
    
    var date: Date!
    var content: String?
    
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var textview: UITextView!
    @IBOutlet var titleTextField: UITextField!
    
   
    var datePicker: UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // ピッカー設定
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        dateTextField.inputView = datePicker
        
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビュー設定
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar
        
        
        // デフォルト日付　付け足した
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy年MM月dd日"
        let dateText: String = formatter.string(from: date)
        dateTextField.text = dateText
//        付け足した
        textview.text = content
        titleTextField.text = title
        
        
        //        datePicker.date = formatter.date(from: "2021-4-14")!
        
        
        // Do any additional setup after loading the view.
    }
    
    // 決定ボタン押下
    @objc func done() {
        dateTextField.endEditing(true)
        
        // 日付のフォーマット
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        dateTextField.text = "\(formatter.string(from: datePicker.date))"
    }
    
    
    
    @IBAction func save() {
        var maxId: Int { return try! Realm().objects(Item.self).sorted(byKeyPath: "id").last?.id ?? 0 }
        let item:Item = Item()
        item.date = self.dateTextField.text
        item.title = self.titleTextField.text
        item.content = self.textview.text
        item.id = maxId + 1
        
        // 保存
        let realm = try! Realm()
        try! realm.write {
            realm.add(item)
        }
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func back() {
        self.dismiss(animated: true, completion: nil)
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
