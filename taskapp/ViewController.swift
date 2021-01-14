//
//  ViewController.swift
//  taskapp
//
//  Created by Yu iwawaki on 2020/12/22.
//  Copyright © 2020 Yu iwawaki. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let realm = try! Realm()
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
    
//    var dateList: [String] = []
//    var searchResults: [String] = []
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
    
        super.viewDidLoad()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    //セルの値を設定するデリゲードメソッド(必須)
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            //セルを取得
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            let task = taskArray[indexPath.row]
            cell.textLabel?.text = task.title
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let dateString: String = formatter.string(from: task.date)
            cell.detailTextLabel?.text = dateString
            
            return cell
            
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        	performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        
        return .delete
    }
    
    
    func tableView(_ tableView: UITableView, commiteditingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){

        if commiteditingStyle == .delete {
            let task = self.taskArray[indexPath.row]
            
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
            
            try! realm.write  {
                self.realm.delete(task)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            center.getPendingNotificationRequests { (requets: [UNNotificationRequest]) in for request in requets {
                print("/---------------")
                print(request)
                print("/---------------")
                }
            }
            
        }
        
    }
    
    //検索結果ボタン押下時のメソッド
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchText.isEmpty {
            taskArray = realm.objects(Task.self)
        } else {
            taskArray = realm
                .objects(Task.self)
                .filter("category BEGINSWITH %@", searchText)
        }
        
        tableView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.searchBar.endEditing(true)
            searchBar.showsCancelButton = false;
//            } else{
//
//            searchBar.showsCancelButton = true;
//        }

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.searchBar.endEditing(true)
    }
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true;
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
           searchBar.resignFirstResponder()
           searchBar.showsCancelButton = false;
    }
    
    
    
//  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//            self.searchBar.endEditing(true)
//            searchBar.showsCancelButton = false;
//        }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
           let inputViewController:InputViewController = segue.destination as! InputViewController

           if segue.identifier == "cellSegue" {
               let indexPath = self.tableView.indexPathForSelectedRow
               inputViewController.task = taskArray[indexPath!.row]
           } else {
               let task = Task()

               let allTasks = realm.objects(Task.self)
               if allTasks.count != 0 {
                   task.id = allTasks.max(ofProperty: "id")! + 1
               }

               inputViewController.task = task
           }
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
}
    
