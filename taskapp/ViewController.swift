//
//  ViewController.swift
//  taskapp
//
//  Created by Taro Sakamoto on 9/2/16.
//  Copyright © 2016 Tarou Sakamoto. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UISearchBarDelegate{
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    //サーチバーで検索
    var searchFlag: Bool = false
    
    
    // Realmインスタンスを取得する
    let realm = try! Realm()  // ←追加
    
    // DB内のタスクが格納されるリスト。
    // 日付近い順\順でソート：降順
    // 以降内容をアップデートするとリスト内は自動的に更新される。
    var taskArray = try! Realm().objects(Task).sorted("date", ascending: false)   // ←追加
    //カテゴリーを検索
    var category = try! Realm().objects(Task).filter("category IN {%@, %@, %@, %@, %@}","1", "2", "3", "4", "5")
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
     * 入力画面から戻ってきた時に TableView を更新させる
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableview.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - TableView
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        if searchFlag == true {
            return category.count
        }else{
            return taskArray.count  // ←追加する
        }
    }
    func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath:NSIndexPath)
        -> UITableViewCell{
            
            
            let cell = tableView.dequeueReusableCellWithIdentifier(
                "Cell", forIndexPath: indexPath)
            // Cellに値を設定する.
            
            if searchFlag == true {
                let task = category[indexPath.row]
                cell.textLabel?.text = "\(task.title) \(task.category)"
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                
                let dateString:String = formatter.stringFromDate(task.date)
                cell.detailTextLabel?.text = dateString
            }else{
                
                
                let task = taskArray[indexPath.row]
                cell.textLabel?.text = task.title
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                
                let dateString:String = formatter.stringFromDate(task.date)
                cell.detailTextLabel?.text = dateString
            }
            return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        performSegueWithIdentifier("cellSegue", sender: nil)
        
        
        func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCellEditingStyle {
            return UITableViewCellEditingStyle.Delete
        }
    }
    /**
     * Delete ボタンが押された時に呼ばれるメソッド
     */
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            // ←以降追加する
            // ローカル通知をキャンセルする
            let task = taskArray[indexPath.row]
            
            for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
                if notification.userInfo!["id"] as! Int == task.id {
                    UIApplication.sharedApplication().cancelLocalNotification(notification)
                    break
                }
            }
            
            // データベースから削除する
            try! realm.write {
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
    }
    
    
    
    // MARK: - Segue
    
    /**
     * segue で画面遷移するに呼ばれる
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        let inputViewController:InputViewController = segue.destinationViewController as! InputViewController
        
        if segue.identifier == "cellSegue" {
            let IndexPath = self.tableview.indexPathForSelectedRow
            inputViewController.task = taskArray[IndexPath!.row]
        } else {
            let task = Task()
            task.date = NSDate()
            
            if taskArray.count != 0 {
                task.id = taskArray.max("id")! + 1
            }
            
            inputViewController.task = task
        }
    }
    
    
    
    // MARK: - SearchBar
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchbar.resignFirstResponder()
        
        searchFlag = true
        if let search = searchBar.text{
            category = try! Realm().objects(Task).filter("category = '\(search)'")
        }
        //let searchText = searchbar.text
        // searchText を元にリアルムの検索をかける
        // taskArrayの中身を入れ替える (検索した結果)
        
        
        // テーブルビュー 更新
        tableview.reloadData()
    }
}

