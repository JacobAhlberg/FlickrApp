//
//  InformationVC.swift
//  FlickrApp
//
//  Created by Jacob Ahlberg on 2018-04-18.
//  Copyright © 2018 Jacob Ahlberg. All rights reserved.
//

import UIKit

class InformationVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var focusedImageView: UIImageView!
    
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        focusedImageView.image = photo.thumbNail
        imageView.image = photo.thumbNail
        titleLbl.text = photo.title
    }
    
    func setPhoto(clickedPhoto: Photo) {
        photo = clickedPhoto
    }

}
