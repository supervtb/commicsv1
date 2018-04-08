//
//  TestViewController.swift
//  commicsv1
//
//  Created by Альберт Чубаков on 23.03.2018.
//  Copyright © 2018 Альберт Чубаков. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

import Realm 

import PhotoEditorSDK

protocol SecondVCDelegate {
    func addNewPage()
    func addSelectedTemplate(identify: String)
    func removeCurrentPage()
    func addPhotoToDB(commicsIndex: Int,image : UIImage, tag: Int)
    func removePhotoFromDb(commicsIndex: Int ,pageNumber : Int, tagPhoto: Int)
    func getCountAllLoadedPages() -> Int
    func getCurrentPageIndex() -> Int
    func saveChangesPan(commicsIndex: Int ,pageNumber : Int, tagPhoto: Int, changeX: Double, changeY : Double )
    func saveChangesRotationAngle(commicsIndex: Int ,pageNumber : Int, tagPhoto: Int, rotationA: Double, rotationB: Double )
    func saveChangesZoomValue(commicsIndex: Int ,pageNumber : Int, tagPhoto: Int, zoomX: Double, zoomY: Double )
    func saveChangesPhoto(commicsIndex: Int, pageNumber: Int, tagPhoto: Int, data: Data)
    func getCurrentIdCommics() -> Int
    func isOpenMode() -> Bool
   }




class LayoutVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PhotoEditViewControllerDelegate{
    
    
   
    @IBOutlet var popUp: UIView!
   
    var tappedImageTag = 0
    
    
    
    var changeX = 0.0
    var changeY = 0.0
    var rotationA = 0.0
     var rotationB = 0.0
    
    
    var longPressRecognizer = UILongPressGestureRecognizer()
    var pinchToZoomRecognizer = UIPinchGestureRecognizer()
    var rotationRecognizer = UIRotationGestureRecognizer()
    var moveRecognizer = UIPanGestureRecognizer()
    var tapRecognizer = UITapGestureRecognizer()
    
    var delegate: SecondVCDelegate?
    
   
    
    var currentViewOnPage = UIView()
    
     override func viewDidLoad() {
        super.viewDidLoad()
       

        let countOfLoadedPages = delegate?.getCountAllLoadedPages()

        let currentPageIndex = delegate?.getCurrentPageIndex()
        
        let commicsOpenMode = delegate?.isOpenMode()
        
        
        
        if !commicsOpenMode! {
        
        if  countOfLoadedPages! > 1 {

            
            
            let allViewsOnPage = view.subviews
            for viewOnPage in allViewsOnPage{

                if viewOnPage.tag > 0  {

                    let currentImageObject = getLoadedImageObject(tag: viewOnPage.tag, pageNumber: currentPageIndex!)


                    var imageView = getImageFromDB(tag: viewOnPage.tag, pageNumber: currentPageIndex! )
                    if imageView != nil {
                        
                     
                        
                        
                        imageView?.frame=CGRect(x:0, y: 0, width: (imageView?.bounds.width)!, height: (imageView?.bounds.height)!)
                       
                        

                        let ratio = (imageView?.bounds.width)! / (imageView?.bounds.height)!
                        if (viewOnPage.bounds.width) > (viewOnPage.bounds.height) {
                            let newHeight = (viewOnPage.frame.width) / ratio
                            imageView?.frame.size = CGSize(width: (viewOnPage.frame.width), height: newHeight)
                        }
                        else{
                            let newWidth = (viewOnPage.frame.height) * ratio
                            imageView?.frame.size = CGSize(width: newWidth, height: (viewOnPage.frame.height))
                        }
                        
                        

                        if currentImageObject?.isChanged == true {
                            let radians = atan2((currentImageObject?.rotationB)!, (currentImageObject?.rotationA)!)

                            imageView?.transform = CGAffineTransform.identity.rotated(by: CGFloat(radians))
                                .scaledBy(x: CGFloat((currentImageObject?.x)!), y: CGFloat((currentImageObject?.y)!))

                            if (currentImageObject?.changeX) != 0 && (currentImageObject?.changeY) != 0 {
                            imageView?.center = CGPoint(x: (currentImageObject?.changeX)!, y: (currentImageObject?.changeY)!)

                            }

                         }
                       viewOnPage.clipsToBounds = true
                        imageView = addRecognnizers(imageView: imageView!)
                        imageView?.isUserInteractionEnabled = true
                        viewOnPage.addSubview(imageView!)



                    }
                }
            

           }

            }
            
        } else {
          
            
           
            if  countOfLoadedPages! > 0 {

                let allViewsOnPage = view.subviews
                for viewOnPage in allViewsOnPage{
                    
                    if viewOnPage.tag > 0  {
                        for child in viewOnPage.subviews{

                            if child is UIButton{
                               child.isHidden = true
                            }
                            
                        }
                        
                        let currentImageObject = getLoadedImageObject(tag: viewOnPage.tag, pageNumber: currentPageIndex!)


                        let imageView = getImageFromDB(tag: viewOnPage.tag, pageNumber: currentPageIndex! )
                        if imageView != nil {
                            
                            
                            imageView?.frame=CGRect(x:0, y: 0, width: (imageView?.bounds.width)!, height: (imageView?.bounds.height)!)
                            
                            
                            let ratio = (imageView?.bounds.width)! / (imageView?.bounds.height)!
                            if (viewOnPage.bounds.width) > (viewOnPage.bounds.height) {
                                let newHeight = (viewOnPage.frame.width) / ratio
                                imageView?.frame.size = CGSize(width: (viewOnPage.frame.width), height: newHeight)
                            }
                            else{
                                let newWidth = (viewOnPage.frame.height) * ratio
                                imageView?.frame.size = CGSize(width: newWidth, height: (viewOnPage.frame.height))
                            }
                            

                            if currentImageObject?.isChanged == true {
                                let radians = atan2((currentImageObject?.rotationB)!, (currentImageObject?.rotationA)!)

                                imageView?.transform = CGAffineTransform.identity.rotated(by: CGFloat(radians))
                                    .scaledBy(x: CGFloat((currentImageObject?.x)!), y: CGFloat((currentImageObject?.y)!))

                                if (currentImageObject?.changeX) != 0 && (currentImageObject?.changeY) != 0 {
                                    imageView?.center = CGPoint(x: (currentImageObject?.changeX)!, y: (currentImageObject?.changeY)!)

                                }

                            }
                            viewOnPage.clipsToBounds = true
                            imageView?.isUserInteractionEnabled = false
                            viewOnPage.addSubview(imageView!)
                        
                           


                        }
                       

                    }

                    if viewOnPage.tag == 100{
                        viewOnPage.isHidden = true
                    }
                   


                }

            }



        }

    }

   
 
    @IBAction func addnewpage(_ sender: UIButton) {
        delegate?.addNewPage()
    }
   
   
    @IBAction func removeCurrentPage(_ sender: UIButton) {
        delegate?.removeCurrentPage()
    }
 
   
    
    @IBAction func addimage(_ sender: UIButton) {
        currentViewOnPage = sender.superview!
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        image.mediaTypes = ["public.image"]
        image.view.tag = sender.tag
        
        self.present(image, animated: true, completion: nil)
       
        
    }
    
   
    
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                 let imageView = UIImageView(image: image)
                let ratio = image.size.width / image.size.height
                if currentViewOnPage.bounds.width > currentViewOnPage.bounds.height {
                    let newHeight = currentViewOnPage.frame.width / ratio
                    imageView.frame.size = CGSize(width: currentViewOnPage.frame.width, height: newHeight)
                }
                else{
                    let newWidth = currentViewOnPage.frame.height * ratio
                    imageView.frame.size = CGSize(width: newWidth, height: currentViewOnPage.frame.height)
                }
                
                
                
           
                
          //  imageView.frame = CGRect(x: 0, y: 0, width: currentViewOnPage.bounds.width, height: currentViewOnPage.bounds.height)
            imageView.isUserInteractionEnabled = true

                
                let imageViewWithRecognizer = addRecognnizers(imageView: imageView)
                
               
                
                
                
                
                
           
            currentViewOnPage.clipsToBounds = true
            currentViewOnPage.addSubview(imageViewWithRecognizer)

              
                 let commicsIndex = delegate?.getCurrentIdCommics()
            
                delegate?.addPhotoToDB(commicsIndex: commicsIndex! ,image: image, tag: picker.view.tag)
                
             self.dismiss(animated: true, completion: nil)
          
               
           
                }
            
          
            
          
            
            }
    
    @IBAction func addVideo(_ sender: UIButton) {
       }
    
    @IBAction func callPopUp(_ sender: UIButton) {
        openPopUp()
    }
    
    @IBAction func dissmissPopUp(_ sender: UIButton) {
        closePopUp()
    }
    
    
    func openPopUp(){
       
    }
    
    func closePopUp(){
        self.popUp.removeFromSuperview()
    }
    
    @objc func handleTap(recognizer: UILongPressGestureRecognizer) {
        let myViews = recognizer.view as! UIImageView
        let currentPageIndex = ((delegate?.getCurrentPageIndex())! - 1)
        let currentCommicsId = delegate?.getCurrentIdCommics()
        delegate?.removePhotoFromDb(commicsIndex: currentCommicsId!, pageNumber: currentPageIndex, tagPhoto: (myViews.superview?.tag)! )
        recognizer.view?.removeFromSuperview()

    }
    
    @objc func handlePinch(recognizer: UIPinchGestureRecognizer) {
       recognizer.view?.transform = CGAffineTransform(scaleX: recognizer.scale, y: recognizer.scale)
        if recognizer.state == .ended{
            let currentPage = delegate?.getCurrentPageIndex()
            let currentCommicsId = delegate?.getCurrentIdCommics()
            delegate?.saveChangesZoomValue(commicsIndex: currentCommicsId!, pageNumber: currentPage!, tagPhoto: (recognizer.view?.superview?.tag)!,
                                           zoomX: Double(recognizer.scale),
                                           zoomY: Double(recognizer.scale) )
        }
    }
    
    @objc func handleRotate(recognizer: UIRotationGestureRecognizer) {
        recognizer.view?.transform =  (recognizer.view?.transform.rotated(by: recognizer.rotation))!
       
        if recognizer.state == .ended {
            let currentPage = delegate?.getCurrentPageIndex()
            let currentCommicsId = delegate?.getCurrentIdCommics()
            delegate?.saveChangesRotationAngle(commicsIndex: currentCommicsId!, pageNumber: currentPage!, tagPhoto: (recognizer.view?.superview?.tag)!,
                                               rotationA: Double((recognizer.view?.transform.a)!),
                                               rotationB: Double((recognizer.view?.transform.b)!))
            
         
            
        }
       
         recognizer.rotation = 0
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        
        if recognizer.state == .began || recognizer.state == .changed {
            let translation = recognizer.translation(in: recognizer.view)
            let changeX = (recognizer.view?.center.x)! + translation.x
            let changeY = (recognizer.view?.center.y)! + translation.y
            recognizer.view?.center = CGPoint(x: changeX, y: changeY)
            recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
            self.changeX = Double(changeX)
            self.changeY = Double(changeY)
        }
        if recognizer.state == .ended {
          
            let currentPage = delegate?.getCurrentPageIndex()
            let currentCommicsId = delegate?.getCurrentIdCommics()
            delegate?.saveChangesPan(commicsIndex: currentCommicsId!, pageNumber: currentPage!, tagPhoto: (recognizer.view?.superview?.tag)!,
                                  changeX: changeX, changeY: changeY )
            
            changeX = 0.0
            changeY = 0.0
        }
    }
    
    @objc func tapForSelectPhotoEditor(recognizer: UITapGestureRecognizer){
        if recognizer.state == .ended {
            let currentCommics = delegate?.getCurrentIdCommics()
             let currentPage = delegate?.getCurrentPageIndex()

            let allcommics = realm.objects(Pages.self)
            let currentcommics = allcommics[currentCommics!]
            let currentpage = currentcommics.arrayPages[currentPage! - 1]



            tappedImageTag = (recognizer.view?.superview?.tag)!

            let indexImg  = currentpage.arrayImages.index(where: { (item) -> Bool in
                item.tag == tappedImageTag
            })

            let data = currentpage.arrayImages[indexImg!].imageData
            
            let photo = Photo(image:  UIImage(data: data!)! )

            let photoEditViewController = PhotoEditViewController(photoAsset: photo)
            photoEditViewController.delegate = self

            present(photoEditViewController, animated: true, completion: {
                recognizer.view?.removeFromSuperview()
            })
            
            
            
          
            
            
            }
        
        
        
        
    }
    

    
   
    
    func  getImageFromDB(tag: Int, pageNumber: Int)-> UIImageView? {
         let indexCommics = delegate?.getCurrentIdCommics()
        let commics = realm.objects(Pages.self)[indexCommics!]
      
        if pageNumber < (commics.arrayPages.count) {
        
        
            let pages = commics.arrayPages[pageNumber]
            let indexImg  = pages.arrayImages.index(where: { (item) -> Bool in
            item.tag == tag
        })
        if indexImg != nil {
            let img = pages.arrayImages[indexImg!]
           
            let returned = UIImageView(image: UIImage(data: (img.imageData)!))
        return returned
        }
        else{
            return nil
        }
        }
        else {
            return nil
        }
    
        
    }
    
    func  getImageFromDBAfterEditing(tag: Int, pageNumber: Int)-> UIImageView? {
        let indexCommics = delegate?.getCurrentIdCommics()
        let commics = realm.objects(Pages.self)[indexCommics!]
        
        if pageNumber <= (commics.arrayPages.count) {
            
            
            let pages = commics.arrayPages[pageNumber-1]
            let indexImg  = pages.arrayImages.index(where: { (item) -> Bool in
                item.tag == tag
            })
            if indexImg != nil {
                let img = pages.arrayImages[indexImg!]
                
                let returned = UIImageView(image: UIImage(data: (img.imageData)!))
                return returned
            }
            else{
                return nil
            }
        }
        else {
            return nil
        }
        
        
    }
    
    
    func getLoadedImageObject(tag: Int, pageNumber: Int) -> Image? {
        let indexCommics = delegate?.getCurrentIdCommics()
        
        let commics = realm.objects(Pages.self)[indexCommics!]
        
        if pageNumber < (commics.arrayPages.count) {
            
            
            let pages = commics.arrayPages[pageNumber]
            let indexImg  = pages.arrayImages.index(where: { (item) -> Bool in
                item.tag == tag
            })
            if indexImg != nil {
                let img = pages.arrayImages[indexImg!]
                
             return img
            }
            else{
                return nil
            }
        }
        else {
            return nil
        }
        
    }
    
   
    
  
    func photoEditViewController(_ photoEditViewController: PhotoEditViewController, didSave image: UIImage, and data: Data) {
        let currentPage = delegate?.getCurrentPageIndex()
        let currentCommicsId = delegate?.getCurrentIdCommics()
        if data.count != 0 {
        delegate?.saveChangesPhoto(commicsIndex: currentCommicsId!, pageNumber: currentPage!, tagPhoto: tappedImageTag, data: data)
        self.reloadViewAfterEditingPhoto()
       
       
        self.dismiss(animated: true, completion: nil)
        } else {
            self.reloadViewAfterEditingPhoto()
            
            
            self.dismiss(animated: true, completion: nil)
        }
     
        
       
    }
    
    func photoEditViewControllerDidFailToGeneratePhoto(_ photoEditViewController: PhotoEditViewController) {
        
    }
    
    func photoEditViewControllerDidCancel(_ photoEditViewController: PhotoEditViewController) {
         self.reloadViewAfterEditingPhoto()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func reloadViewAfterEditingPhoto() {
       
        let currentPageIndex = delegate?.getCurrentPageIndex()
        
        
        for view in  view.subviews{
            if view.tag == tappedImageTag {
               
               
                
                var imageView = getImageFromDBAfterEditing(tag: view.tag, pageNumber: currentPageIndex!)
                imageView?.frame=CGRect(x:0, y: 0, width: (imageView?.bounds.width)!, height: (imageView?.bounds.height)!)
                imageView?.clipsToBounds = true
                imageView = addRecognnizers(imageView: imageView!)
                
                
                let ratio = (imageView?.bounds.width)! / (imageView?.bounds.height)!
                if (view.bounds.width) > (view.bounds.height) {
                    let newHeight = (view.frame.width) / ratio
                    imageView?.frame.size = CGSize(width: (view.frame.width), height: newHeight)
                }
                else{
                    let newWidth = (view.frame.height) * ratio
                    imageView?.frame.size = CGSize(width: newWidth, height: (view.frame.height))
                }
                
                
                view.addSubview(imageView!)
                imageView?.isUserInteractionEnabled = true
               
                
               
            }
        }
    }
    
    func addRecognnizers(imageView: UIImageView) -> UIImageView{
        longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                           action:#selector(handleTap(recognizer:)))
        pinchToZoomRecognizer = UIPinchGestureRecognizer(target: self,
                                                         action:#selector(handlePinch(recognizer:)))
        rotationRecognizer = UIRotationGestureRecognizer(target: self,
                                                         action:#selector(handleRotate(recognizer:)))
        moveRecognizer = UIPanGestureRecognizer(target: self,
                                                action:#selector(handlePan(recognizer:)))
        
        tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(tapForSelectPhotoEditor(recognizer:)))
        
        longPressRecognizer.delegate = self as? UIGestureRecognizerDelegate
        pinchToZoomRecognizer.delegate = self as? UIGestureRecognizerDelegate
        rotationRecognizer.delegate = self as? UIGestureRecognizerDelegate
        moveRecognizer.delegate = self as? UIGestureRecognizerDelegate
        tapRecognizer.delegate = self as? UIGestureRecognizerDelegate
        
        
        imageView.addGestureRecognizer(longPressRecognizer)
        imageView.addGestureRecognizer(pinchToZoomRecognizer)
        imageView.addGestureRecognizer(rotationRecognizer)
        imageView.addGestureRecognizer(moveRecognizer)
        imageView.addGestureRecognizer(tapRecognizer)
        
        
        
        return imageView
    }
    
 
    
}


