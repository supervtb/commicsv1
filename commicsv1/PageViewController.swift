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
        
        
        var commics = Pages()
        
        var index = 0
        
        var indexLoadedCommics = -1
        
        var pages = [UIViewController]()
        override func viewDidLoad() {
            super.viewDidLoad()
            self.dataSource = self
            
            if realm.objects(Pages.self)[indexLoadedCommics] != nil {
                commics = realm.objects(Pages.self)[indexLoadedCommics]
            }
            else {
                DatabaseService.createNewCommics(nameCommics: "bla")
                commics = realm.objects(Pages.self).last!
                
            }
            
            let sb = UIStoryboard(name: "Main", bundle:nil)
                if let vc0 = sb.instantiateViewController(withIdentifier: "all") as? AllTypeListLayoutsViewController {
                   vc0.delegate = self
                    self.pages.append(vc0)
                    
                    
                }
                if let firstViewController = pages.first{
               self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
               }
            
            if pages.count < 2 && commics.arrayPages.count > 0 {
                for pageFromCommics in commics.arrayPages{
                    if let vc = sb.instantiateViewController(withIdentifier: pageFromCommics.name) as? TestViewController {
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
            
          
              index = viewControllerIndex
            
           
          
            
            
            
           
            return pages[previousIndex]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
            
            let nextIndex = viewControllerIndex + 1
            
           
            
            index = viewControllerIndex
            
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
                newPage.index = index
                
               
                try! realm.write {
                     commics.arrayPages.append(newPage)
                }
               
                

             }
        }
        
        func removeCurrentPage(){
            let allPages = realm.objects(Page.self)
            try! realm.write {
                 commics.arrayPages.remove(at: index-1)
            }
            pages.remove(at: index)
            setViewControllers([pages.first!], direction: .forward, animated: true, completion: nil)
            index = index-1
            
           
            
            
            
        }
        
        func addPhotoToDB(image: UIImage, tag: Int) {
            let newImage = Image()
           newImage.imageData = UIImageJPEGRepresentation(image, 0)! as Data
            newImage.tag = tag
          
             try! realm.write {
             
                commics.arrayPages[index-1].arrayImages.append(newImage)
            }
            
           
        }
        
        
        
        func removePhotoFromDb(pageNumber: Int, tagPhoto: Int){
         
            let commics = realm.objects(Pages.self).first
            let pages = commics?.arrayPages[pageNumber]
            let indexImg  = pages?.arrayImages.index(where: { (item) -> Bool in
                item.tag == tagPhoto
            })
            if indexImg != nil {
                let removableImage = commics?.arrayPages[index-1].arrayImages[indexImg!]
            try! realm.write {
                commics?.arrayPages[index - 1].arrayImages.remove(at: indexImg!)
                realm.delete(removableImage!)
            }

            }

        

            
        }
        
        func saveChangesPan(pageNumber: Int, tagPhoto: Int, changeX: Double, changeY: Double) {
            DatabaseService.savePanPosition(pageNumber: pageNumber, tagPhoto: tagPhoto, changeX: changeX, changeY: changeY)
        }
        
        func saveChangesRotationAngle(pageNumber: Int, tagPhoto: Int, rotationA: Double, rotationB: Double) {
            DatabaseService.saveChangesRotationAngle(pageNumber: pageNumber, tagPhoto: tagPhoto, rotationA: rotationA, rotationB: rotationB)
            
        }
        
        func saveChangesZoomValue(pageNumber: Int, tagPhoto: Int, zoomX: Double, zoomY: Double) {
          DatabaseService.saveChangesZoomValue(pageNumber: pageNumber, tagPhoto: tagPhoto, pinchX: zoomX, pinchY: zoomY)
        }
        
       
        
        func getCountAllLoadedPages() -> Int {
            return pages.count
        }
        
        
        
        func getCurrentPageIndex() -> Int {
           
           return index
            
        
        }
        
        func getCurrentIdCommics() -> Int {
         return indexLoadedCommics
        }
        
      
    
       

    }
