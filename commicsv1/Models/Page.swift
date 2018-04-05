//
//  Page.swift
//  commicsv1
//
//  Created by Альберт Чубаков on 28.03.2018.
//  Copyright © 2018 Альберт Чубаков. All rights reserved.
//

import Foundation

import RealmSwift

class Page: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var index = 0
    let arrayImages =  List<Image>()
    
   
    
    
    
    
    
}
