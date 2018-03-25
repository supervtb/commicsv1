//
//  AllTypeListLayoutsViewController.swift
//  commicsv1
//
//  Created by Альберт Чубаков on 24.03.2018.
//  Copyright © 2018 Альберт Чубаков. All rights reserved.
//

import UIKit

class AllTypeListLayoutsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var delegate: SecondVCDelegate?
    
    var arrayNamesLayout = [TypeOfLayouts(nameLayout: "threeRow", nameIconLayout: "threeRow"),
                            TypeOfLayouts(nameLayout: "twoRow", nameIconLayout: "threeRow")]

    var namesView = [String]()
    var namesIconView = [String]()

    @IBOutlet weak var collection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
       for name in arrayNamesLayout {
            namesView.append(name.nameLayout)
            namesIconView.append(name.nameIconLayout)
        }
        collection.delegate = self
        collection.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return namesView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CellCollectionViewCell
        cell.label.text = namesView[indexPath.row]
        cell.bttnLayout.setImage(UIImage(named: namesIconView[indexPath.row]), for: .normal)
        cell.bttnLayout.accessibilityIdentifier = namesView[indexPath.row]
        return cell
        
    }
   
    @IBAction func addNewPage(_ sender: UIButton) {
       
        delegate?.addSelectedTemplate(identify: sender.accessibilityIdentifier!)
    }
    
    @IBAction func selectingLayout(_ sender: UIButton) {
         delegate?.addSelectedTemplate(identify: sender.accessibilityIdentifier!)
    }
}
