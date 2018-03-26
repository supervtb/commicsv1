//
//  PopUpVC.swift
//  commicsv1
//
//  Created by Альберт Чубаков on 26.03.2018.
//  Copyright © 2018 Альберт Чубаков. All rights reserved.
//

import UIKit

class PopUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func closePopUp(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
