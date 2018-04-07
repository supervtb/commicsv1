//
//  ShowCommicsVC.swift
//  commicsv1
//
//  Created by Альберт Чубаков on 07.04.2018.
//  Copyright © 2018 Альберт Чубаков. All rights reserved.
//

import UIKit

class ShowCommicsVC: UIViewController {

    @IBOutlet weak var commicsIndex: UILabel!
    var selectedComics = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        commicsIndex.text = String(selectedComics)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
