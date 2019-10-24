//
//  ImageDetailsVC.swift
//  Meme 01
//
//  Created by Ghadah on 08/10/2019.
//  Copyright © 2019 Ghadah. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailsVC: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var meme: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = meme.memedImage
    }
}
