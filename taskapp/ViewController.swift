//
//  ViewController.swift
//  taskapp
//
//  Created by Yu iwawaki on 2020/12/22.
//  Copyright © 2020 Yu iwawaki. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
        
    }
        func tableView(_ tableView: UITableView, cellForRowAt indexpath: IndexPath) -> UITableViewCell{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexpath)
            
            return cell
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        	performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        
        return .delete
    }
    func tableView(_ tableView: UITableView, commiteditingStyle: UITableViewCell.EditingStyle, forRowAt indexpath: IndexPath){

}

}
