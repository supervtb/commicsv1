//
//  ViewController.swift
//  commicsv1
//
//  Created by Альберт Чубаков on 22.03.2018.
//  Copyright © 2018 Альберт Чубаков. All rights reserved.
//

import UIKit
import RealmSwift



class AllCommicsCollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
 
    
   
    var isReadOnlyMode = false
    
    var selectedIndexOfCommics = 0
    
    @IBOutlet weak var collection: UICollectionView!
    
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
       collection.delegate = self
        collection.dataSource = self
        
     
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let allCommicsNames = DatabaseService.getAllNamesCommicsFromDB()
        return allCommicsNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let allCommicsNames = DatabaseService.getAllNamesCommicsFromDB()
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.selectCommics.accessibilityIdentifier = allCommicsNames[indexPath.item]
        cell.selectCommics.setTitle(String(indexPath.item), for: .normal  )
      
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
          
//        self.performSegue(withIdentifier: "toSelectedCommics", sender: self)
        
          selectedIndexOfCommics = indexPath.item
          self.performSegue(withIdentifier: "toSelectingMode", sender:self)
        
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! SelectingOpenModeVC
       dest.selectingCommics = selectedIndexOfCommics
    }
    
    
   
    
    @IBAction func createNewCommicsBttn(_ sender: UIButton) {
       
        DatabaseService.createNewCommics(nameCommics: "Create")
        collection.reloadData()
    }
    
    
   
}
