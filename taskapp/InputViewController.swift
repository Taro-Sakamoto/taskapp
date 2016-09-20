//
//  InputViewController.swift
//  taskapp
//
//  Created by Taro Sakamoto on 9/3/16.
//  Copyright © 2016 Tarou Sakamoto. All rights reserved.
//

import UIKit
import RealmSwift

class InputViewController: UIViewController {
    
    
    @IBOutlet weak var titletextfield: UITextField!
    @IBOutlet weak var contentstextview: UITextView!
    @IBOutlet weak var categorytextfield: UITextField!
    @IBOutlet weak var datepicker: UIDatePicker!
    
    
    let realm = try! Realm()
    var task:Task!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titletextfield.text = task.title
        contentstextview.text = task.contents
        datepicker.date = task.date
        categorytextfield.text = task.category
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        try! realm.write {
            self.task.title = self.titletextfield.text!
            self.task.contents = self.contentstextview.text
            self.task.date = self.datepicker.date
            self.task.category = self.categorytextfield.text!
            self.realm.add(self.task, update: true)
        }
        
        setNotification(task)
        
        super.viewWillDisappear(animated)
    }
    func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    
    // タスクのローカル通知を設定する
    func setNotification(task: Task) {
        
        // すでに同じタスクが登録されていたらキャンセルする
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if notification.userInfo!["id"] as! Int == task.id {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break   // breakに来るとforループから抜け出せる
            }
        }
        
        let notification = UILocalNotification()
        
        notification.fireDate = task.date
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "\(task.title)"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["id":task.id]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
