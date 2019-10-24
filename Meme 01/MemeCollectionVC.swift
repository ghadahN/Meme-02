//
//  MemeCollectionVC.swift
//  Meme 01
//
//  Created by Ghadah on 05/10/2019.
//  Copyright © 2019 Ghadah. All rights reserved.
//

import UIKit


class MemeCollectionVC: UICollectionViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
          self.title = "Sent Memes"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return memes.count
    }
    
 
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let meme = memes?[indexPath.row]
        let detailsViewController = UIStoryboard.init(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "MemeDetailsVC") as! MemeDetailsVC
        detailsViewController.meme = meme
        self.navigationController?.pushViewController(detailsViewController, animated: true)
       
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell_id", for: indexPath) as! MemeCell
        
        let meme = memes[indexPath.row]
       cell.imageView.image = meme.memedImage
        return cell
    }
}
