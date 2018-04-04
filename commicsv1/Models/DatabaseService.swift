//
//  DatabaseService.swift
//  commicsv1
//
//  Created by Альберт Чубаков on 03.04.2018.
//  Copyright © 2018 Альберт Чубаков. All rights reserved.
//

import Foundation

  class DatabaseService {
    
    static func getAllNamesCommicsFromDB() -> [String]{
        var arrayOfNamesCommics = [String]()
        
        let allObjectCommics = realm.objects(Pages.self)
        for objectCommics in allObjectCommics{
            arrayOfNamesCommics.append(String(objectCommics.nameCommics))
        }
        return arrayOfNamesCommics
    }
    
    static func createNewCommics(nameCommics: String){
        let newCommics = Pages()
        newCommics.nameCommics = nameCommics
        try! realm.write {
            realm.add(newCommics)
        }
       
    }
    
    static func removeCommicsByID(idCommics: Int){
        let allObjectCommics = realm.objects(Pages.self)
        let removingobj = allObjectCommics[idCommics]
        try! realm.write {
           realm.delete(removingobj)
        }
        if allObjectCommics.count == 0  {
            try! realm.write {
                realm.deleteAll()
            }
        }
        
    }
    
    static func removePageByIndex(commics: Pages, removingPageIndex : Int) {
       
    }
    
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
