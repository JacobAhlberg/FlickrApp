//
//  Photo.swift
//  FlickrApp
//
//  Created by Jacob Ahlberg on 2018-04-18.
//  Copyright © 2018 Jacob Ahlberg. All rights reserved.
//

import UIKit

class Photo {
    private(set) public var id: String?
    private(set) public var secret: String?
    private(set) public var serverId: String?
    private(set) public var farm: Int?
    private(set) public var title: String?
    var thumbNail: UIImage?
    
    init(id: String, secret: String, serverId: String, farm: Int, title: String) {
        self.id = id
        self.secret = secret
        self.serverId = serverId
        self.farm = farm
        self.title = title
    }
}
