//
//  TypeOfLayouts.swift
//  commicsv1
//
//  Created by Альберт Чубаков on 24.03.2018.
//  Copyright © 2018 Альберт Чубаков. All rights reserved.
//

import Foundation
class TypeOfLayouts {
    var nameLayout = ""
    var nameIconLayout = ""
    
    init(nameLayout: String) {
        self.nameLayout = nameLayout
    }
    
    init(nameLayout: String, nameIconLayout: String) {
        self.nameLayout = nameLayout
        self.nameIconLayout = nameIconLayout
    }
}
