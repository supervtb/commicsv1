//
//  SelectingOpenModeVC.swift
//  commicsv1
//
//  Created by Альберт Чубаков on 07.04.2018.
//  Copyright © 2018 Альберт Чубаков. All rights reserved.
//

import UIKit

class SelectingOpenModeVC: UIViewController {
    
    var selectingCommics = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

   
    @IBAction func toEditMode(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toEdit", sender: self)
    }
    
    @IBAction func toShowMode(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toShow", sender: self)
       
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShow" {
            let destination = segue.destination as! ShowCommicsVC
            destination.selectedComics = selectingCommics
        }
        else {
            let destination = segue.destination as! PageViewController
            destination.indexLoadedCommics = selectingCommics
        }
        
       
    }
}
