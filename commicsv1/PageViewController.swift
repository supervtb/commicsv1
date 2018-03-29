//
//  PageViewController.swift
//  commicsv1
//
//  Created by Альберт Чубаков on 22.03.2018.
//  Copyright © 2018 Альберт Чубаков. All rights reserved.
//

import UIKit
import RealmSwift


class PageViewController: UIPageViewController, UIPageViewControllerDelegate,
UIPageViewControllerDataSource, SecondVCDelegate {
    
    var index = 0
    
    var pages = [UIViewController]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
            
            let sb = UIStoryboard(name: "Main", bundle:nil)
            if let vc0 = sb.instantiateViewController(withIdentifier: "all") as? AllTypeListLayoutsViewController {
               vc0.delegate = self
                self.pages.append(vc0)
                
                
            }
            if let firstViewController = pages.first{
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
           }
        
        
     
        let pa = realm.objects(Page.self)
        
      
        
        if pages.count < 2 && pa.count > 0 {
        
        for p in pa {
            if let vc = sb.instantiateViewController(withIdentifier: p.name) as? TestViewController {
                vc.delegate = self
                self.pages.append(vc)
                }
            }
    }
        }
        
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0          else { return nil}
        
        guard pages.count > previousIndex else { return nil }
        
        index = previousIndex + 1
      
       
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        index = nextIndex - 1
        
        guard nextIndex < pages.count else { return nil }
        
        guard pages.count > nextIndex else { return nil }
        
        
      
        return pages[nextIndex]
    }
    
    func redirectToLayoutPage(){
        if let firstViewController = pages.first{
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func addNewPage() {
      setViewControllers([pages.first!],
                               direction: .forward, animated: true, completion: nil)
        }
    
   
    
    func addSelectedTemplate(identify: String){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let vc1 = sb.instantiateViewController(withIdentifier: identify) as? TestViewController{
            vc1.delegate = self
            self.pages.append(vc1)
            setViewControllers([vc1], direction: .forward, animated: true, completion: nil)
            index = index+1
            let newPage = Page()
            newPage.name = identify
            try! realm.write {
                realm.add(newPage)
            }
         }
    }
    
    func removeCurrentPage(){
        let allPages = realm.objects(Page.self)
        let removingPage = allPages[index-1]
        try! realm.write {
                        realm.delete(removingPage)
                    }
        
      pages.remove(at: index)
        setViewControllers([pages[index-1]], direction: .forward, animated: true, completion: nil)
        index = index-1
        
    
      
       
       
       
    }
    
    
    
    
    
    
   

}
