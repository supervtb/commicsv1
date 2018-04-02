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



protocol SecondVCDelegate {
    func addNewPage()
    func addSelectedTemplate(identify: String)
    func removeCurrentPage()
    func addPhotoToDB(image : UIImage, tag: Int)
    func removePhotoFromDb(pageNumber : Int, tagPhoto: Int)
    func getCountAllLoadedPages() -> Int
    func getCurrentPageIndex() -> Int
   }


class TestViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
   
    @IBOutlet var popUp: UIView!
   
    
    
    
    
    var longPressRecognizer = UILongPressGestureRecognizer()
    var pinchToZoomRecognizer = UIPinchGestureRecognizer()
    var rotationRecognizer = UIRotationGestureRecognizer()
    var moveRecognizer = UIPanGestureRecognizer()
    
    var delegate: SecondVCDelegate?
    
    var currentViewOnPage = UIView()
    
    var arrayOfLongPressRecognizers = [UILongPressGestureRecognizer()]
    var arrayOfPinchRecognizers = [UIPinchGestureRecognizer()]
    var arrayOfRotationRecognizers = [UIRotationGestureRecognizer()]
    var arrayOfMoveRecognizers = [UIPanGestureRecognizer()]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        generateRecognizers(amountOfRecognizers: self.view.subviews.count)
        
        let countOfLoadedPages = delegate?.getCountAllLoadedPages()
        
        let r = delegate?.getCurrentPageIndex()
       
        if  countOfLoadedPages! > 1 {
    
            let allViewsOnPage = view.subviews
            for viewOnPage in allViewsOnPage{

                if viewOnPage.tag > 0  {

                    
                   

                    let imageView = getImageFromDB(tag: viewOnPage.tag, pageNumber: r! )
                    if imageView != nil {
                        imageView?.frame=CGRect(x: 0, y: 0, width: viewOnPage.bounds.width, height: viewOnPage.bounds.height)
                        viewOnPage.clipsToBounds = true

                        viewOnPage.addSubview(imageView!)

                        imageView?.isUserInteractionEnabled = true

                        imageView?.addGestureRecognizer(arrayOfMoveRecognizers.last!)
                        arrayOfMoveRecognizers.removeLast()
                        imageView?.addGestureRecognizer(arrayOfPinchRecognizers.last!)
                        arrayOfPinchRecognizers.removeLast()
                        imageView?.addGestureRecognizer(arrayOfLongPressRecognizers.last!)
                        arrayOfLongPressRecognizers.removeLast()

                    }
                }
            }
   
        }


        
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
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
            imageView.frame = CGRect(x: 0, y: 0, width: currentViewOnPage.bounds.width, height: currentViewOnPage.bounds.height)
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(arrayOfLongPressRecognizers.last!)
            imageView.addGestureRecognizer(arrayOfPinchRecognizers.last!)
            imageView.addGestureRecognizer(arrayOfRotationRecognizers.last!)
            imageView.addGestureRecognizer(arrayOfMoveRecognizers.last!)
           
               
            currentViewOnPage.clipsToBounds = true
            currentViewOnPage.addSubview(imageView)
            arrayOfLongPressRecognizers.removeLast()
            arrayOfPinchRecognizers.removeLast()
            arrayOfRotationRecognizers.removeLast()
            arrayOfMoveRecognizers.removeLast()
                
                
               
                
                delegate?.addPhotoToDB(image: image, tag: picker.view.tag)
           
                
            }
           self.dismiss(animated: true, completion: nil)
            
           
            
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
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {

        let myViews = recognizer.view as! UIImageView
      
        let im = myViews.image
        var tt = (delegate?.getCurrentPageIndex())! - 1
        delegate?.removePhotoFromDb(pageNumber: tt, tagPhoto: (myViews.superview?.tag)! )
        recognizer.view?.removeFromSuperview()

    }
    
    @objc func handlePinch(recognizer: UIPinchGestureRecognizer) {
       recognizer.view?.transform = CGAffineTransform(scaleX: recognizer.scale, y: recognizer.scale)
      
    }
    
    @objc func handleRotate(recognizer: UIRotationGestureRecognizer) {
        recognizer.view?.transform =  (recognizer.view?.transform.rotated(by: recognizer.rotation))!
        recognizer.rotation = 0
        
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed {
            let translation = recognizer.translation(in: recognizer.view)
            let changeX = (recognizer.view?.center.x)! + translation.x
            let changeY = (recognizer.view?.center.y)! + translation.y
            recognizer.view?.center = CGPoint(x: changeX, y: changeY)
            recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
        }
    }
    
    func generateRecognizers(amountOfRecognizers: Int){
        for _ in 0..<amountOfRecognizers {
            longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                         action:#selector(handleTap(recognizer:)))
            pinchToZoomRecognizer = UIPinchGestureRecognizer(target: self,
                                                             action:#selector(handlePinch(recognizer:)))
            rotationRecognizer = UIRotationGestureRecognizer(target: self,
                                                             action:#selector(handleRotate(recognizer:)))
            moveRecognizer = UIPanGestureRecognizer(target: self,
                                                    action:#selector(handlePan(recognizer:)))
            
            arrayOfLongPressRecognizers.append(longPressRecognizer)
            arrayOfPinchRecognizers.append(pinchToZoomRecognizer)
            arrayOfRotationRecognizers.append(rotationRecognizer)
            arrayOfMoveRecognizers.append(moveRecognizer)
            
        }
        
        longPressRecognizer.delegate = self as? UIGestureRecognizerDelegate
        pinchToZoomRecognizer.delegate = self as? UIGestureRecognizerDelegate
        rotationRecognizer.delegate = self as? UIGestureRecognizerDelegate
        moveRecognizer.delegate = self as? UIGestureRecognizerDelegate
        
    }
    
   
    
    func  getImageFromDB(tag: Int, pageNumber: Int)-> UIImageView? {
        let commics = realm.objects(Pages.self).first
      
        if pageNumber < (commics?.arrayPages.count)! {
        
        
        let pages = commics?.arrayPages[pageNumber]
        let indexImg  = pages?.arrayImages.index(where: { (item) -> Bool in
            item.tag == tag
        })
        if indexImg != nil {
        let img = pages?.arrayImages[indexImg!]
        let returned = UIImageView(image: UIImage(data: (img?.imageData)!))
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
    
    
  
    
    
    
   
  
    
}


