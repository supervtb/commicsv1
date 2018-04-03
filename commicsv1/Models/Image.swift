//
//  Image.swift
//  commicsv1
//
//  Created by Альберт Чубаков on 30.03.2018.
//  Copyright © 2018 Альберт Чубаков. All rights reserved.
//

import Foundation

import RealmSwift

class Image: Object {
    
    @objc dynamic var imagePath = ""
    @objc dynamic var imageData : Data?
    @objc dynamic var x = 1.0
    @objc dynamic var y = 1.0
    @objc dynamic var width  = 0
    @objc dynamic var  height  = 0
    @objc dynamic var rotationA = 0.0
    @objc dynamic var rotationB = 0.0
    @objc dynamic var scale = 0.0
    @objc dynamic var changeX = 0.0
    @objc dynamic var changeY = 0.0
    @objc dynamic var tag = -1
    @objc dynamic var isChanged = false
    
    
    
    
    
    
    
    
    
}
