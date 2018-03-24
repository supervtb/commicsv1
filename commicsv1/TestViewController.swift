//
//  TestViewController.swift
//  commicsv1
//
//  Created by Альберт Чубаков on 23.03.2018.
//  Copyright © 2018 Альберт Чубаков. All rights reserved.
//

import UIKit

protocol SecondVCDelegate {
    func addNewPage()
    func addSelectedTemplate(identify: String)
     func removeCurrentPage()
   }


class TestViewController: UIViewController{

    var delegate: SecondVCDelegate?

    override func viewDidLoad() {
     
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
   
 
    @IBAction func addnewpage(_ sender: UIButton) {
        delegate?.addNewPage()
    }
   
   
    @IBAction func removeCurrentPage(_ sender: UIButton) {
        delegate?.removeCurrentPage()
    }
    
   
  
    
}
