//
//  MemeTableVC.swift
//  Meme 01
//
//  Created by Ghadah on 05/10/2019.
//  Copyright © 2019 Ghadah. All rights reserved.
//


import UIKit
import Foundation

class MemeTableVC:  UITableViewController {
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        self.title = "Sent Memes"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell_nr")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_nr")
        let meme = memes[indexPath.row]
        cell?.imageView?.image = meme.memedImage
        cell?.textLabel?.text = "\(meme.topText)...\(meme.bottomTxt)"
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = memes?[indexPath.row]
        let detailsViewController = UIStoryboard.init(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "MemeDetailsVC") as! MemeDetailsVC
        detailsViewController.meme = meme
       self.navigationController?.pushViewController(detailsViewController, animated: true)
      
    }
}
