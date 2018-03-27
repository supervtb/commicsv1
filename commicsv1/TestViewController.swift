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
       // self.view.addSubview(popUp)
       // popUp.center = self.view.center
        
       
       
        
    }
    
    func closePopUp(){
        self.popUp.removeFromSuperview()
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
    
    
    
   
  
    
}
