//
//  ViewController.swift
//  TestChatApp
//
//  Created by Creator-$ on 6/19/19.
//  Copyright © 2019 tiwariammit@mail.com. All rights reserved.
//

import UIKit

class ChatNameListVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    private let dataSource : [String : String] = ["Amrit": "Hello Amrit", "Shyam" : "Hello shyam how are you?", "Hari" : "Hello Hari, how are you? Where do you live?"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.tableFooterView = UIView()
    }


}



//MARK:- table view data source and delagate
extension ChatNameListVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int{
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.dataSource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatNameListTVCell", for: indexPath) as! ChatNameListTVCell
        
        cell.cellConfigiration(self.dataSource, index: indexPath.row)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 1000
    }
}

