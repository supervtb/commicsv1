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
    
    var arrayNamesLayout = [TypeOfLayouts(nameLayout: "threeRow"), TypeOfLayouts(nameLayout: "threeRow")]

    var namesView = [String]()

    @IBOutlet weak var collection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
       for name in arrayNamesLayout {
            namesView.append(name.nameLayout)
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
        return cell
        
        // добавить кнопку на каждый тип лэйаута
    }
   
    @IBAction func addNewPage(_ sender: UIButton) {
        print()
        delegate?.addSelectedTemplate(identify: sender.accessibilityIdentifier!)
    }
    
}
