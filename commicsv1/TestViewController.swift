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

protocol SecondVCDelegate {
    func addNewPage()
    func addSelectedTemplate(identify: String)
     func removeCurrentPage()
   }


class TestViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
   
    var tapRecognizer = UILongPressGestureRecognizer()
    
    var pinchToZoomRecognizer = UIPinchGestureRecognizer()
    
    
    var rotationRecognizer = UIRotationGestureRecognizer()
    
    var moveRecognizer = UIPanGestureRecognizer()
    
    var delegate: SecondVCDelegate?
    
     var currentViewOnPage = UIView()
    
    var arrayOfPinchRecognizers = [UIPinchGestureRecognizer()]

    override func viewDidLoad() {
        super.viewDidLoad()
        tapRecognizer = UILongPressGestureRecognizer(target: self,
                                                action:#selector(handleTap(recognizer:)))
        
        for _ in 0..<self.view.subviews.count{
            pinchToZoomRecognizer = UIPinchGestureRecognizer(target: self,
                                                                 action:#selector(handlePinch(recognizer:)))
            arrayOfPinchRecognizers.append(pinchToZoomRecognizer)
            
        }
    
        
      
        
        rotationRecognizer = UIRotationGestureRecognizer(target: self,
                                                         action:#selector(handleRotate(recognizer:)))
        
        moveRecognizer = UIPanGestureRecognizer(target: self,
                                                         action:#selector(handlePan(recognizer:)))
        
        
      
     
       tapRecognizer.delegate = self as? UIGestureRecognizerDelegate
       pinchToZoomRecognizer.delegate = self as? UIGestureRecognizerDelegate
       rotationRecognizer.delegate = self as? UIGestureRecognizerDelegate
       moveRecognizer.delegate = self as? UIGestureRecognizerDelegate
        
       
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
        image.mediaTypes = ["public.image", "public.movie"]
        self.present(image, animated: true, completion: nil)
        
        
    }
    
   
    
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: currentViewOnPage.bounds.width, height: currentViewOnPage.bounds.height)
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapRecognizer)
          
                imageView.addGestureRecognizer(arrayOfPinchRecognizers.last!)
                
               
           
                imageView.addGestureRecognizer(rotationRecognizer)
            imageView.addGestureRecognizer(moveRecognizer)
                currentViewOnPage.clipsToBounds = true
            currentViewOnPage.addSubview(imageView)
                arrayOfPinchRecognizers.removeLast()
                }
           self.dismiss(animated: true, completion: nil)
            
           
            
            }
    
    @IBAction func addVideo(_ sender: UIButton) {
       }
    

    @objc func handleTap(recognizer: UITapGestureRecognizer) {
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
    
    
    
   
  
    
}
