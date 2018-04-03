//
//  DatabaseService.swift
//  commicsv1
//
//  Created by Альберт Чубаков on 03.04.2018.
//  Copyright © 2018 Альберт Чубаков. All rights reserved.
//

import Foundation

  class DatabaseService {
    static func savePanPosition(pageNumber: Int, tagPhoto: Int,
                                changeX: Double, changeY: Double ){
        let commics = realm.objects(Pages.self).first
        let pages = commics?.arrayPages[pageNumber-1]
        let indexImg  = pages?.arrayImages.index(where: { (item) -> Bool in
            item.tag == tagPhoto
        })
        if indexImg != nil {
            let changedImage = commics?.arrayPages[pageNumber-1].arrayImages[indexImg!]
            try! realm.write {
                changedImage?.changeX = changeX
                changedImage?.changeY = changeY
                changedImage?.isChanged = true
            }
            
        }
        
    }

    static func saveChangesRotationAngle(pageNumber: Int, tagPhoto: Int,
                                rotationA: Double, rotationB: Double ){
        let commics = realm.objects(Pages.self).first
        let pages = commics?.arrayPages[pageNumber-1]
        let indexImg  = pages?.arrayImages.index(where: { (item) -> Bool in
            item.tag == tagPhoto
        })
        if indexImg != nil {
            let changedImage = commics?.arrayPages[pageNumber-1].arrayImages[indexImg!]
            try! realm.write {
                changedImage?.rotationA = rotationA
                changedImage?.rotationB = rotationB
                changedImage?.isChanged = true
            }
            
        }
        
    }
    
    static func saveChangesZoomValue(pageNumber: Int, tagPhoto: Int,
                                         pinchX: Double, pinchY: Double ){
        let commics = realm.objects(Pages.self).first
        let pages = commics?.arrayPages[pageNumber-1]
        let indexImg  = pages?.arrayImages.index(where: { (item) -> Bool in
            item.tag == tagPhoto
        })
        if indexImg != nil {
            let changedImage = commics?.arrayPages[pageNumber-1].arrayImages[indexImg!]
            try! realm.write {
                changedImage?.x = pinchX
                changedImage?.y = pinchY
                changedImage?.isChanged = true
            }
            
        }
        
    }

    
}
