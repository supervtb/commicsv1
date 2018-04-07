//
//  ShowPagesVC.swift
//  commicsv1
//
//  Created by Альберт Чубаков on 07.04.2018.
//  Copyright © 2018 Альберт Чубаков. All rights reserved.
//

import UIKit

class ShowPagesVC: UIPageViewController, UIPageViewControllerDelegate,
UIPageViewControllerDataSource {
  
 
   
    
     var commics = Pages()
  
    var pages = [UIViewController]()
    
     var indexLoadedCommics = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        realm.objects(Pages.self)[indexLoadedCommics]
        commics = realm.objects(Pages.self)[indexLoadedCommics]
        let sb = UIStoryboard(name: "Main", bundle:nil)
        for pageFromCommics in commics.arrayPages{
            if let vct = sb.instantiateViewController(withIdentifier: pageFromCommics.name) as? LayoutVC {
               self.pages.append(vct)
            }
        }
        
        if let firstViewController = pages.first{
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0          else { return nil}
        guard pages.count > previousIndex else { return nil }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return nil }
        guard pages.count > nextIndex else { return nil }
        return pages[nextIndex]
    }
    
   
    

}
