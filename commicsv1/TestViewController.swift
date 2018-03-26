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
    
    var delegate: SecondVCDelegate?
    
     var currentViewOnPage = UIView()

    override func viewDidLoad() {
     
        super.viewDidLoad()
        tapRecognizer = UILongPressGestureRecognizer(target: self,
                                                action:#selector(handleTap(recognizer:)))
        
        pinchToZoomRecognizer = UIPinchGestureRecognizer(target: self,
                                                         action:#selector(handlePinch(recognizer:)))
     
       tapRecognizer.delegate = self as? UIGestureRecognizerDelegate
       pinchToZoomRecognizer.delegate = self as? UIGestureRecognizerDelegate
       
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
            imageView.addGestureRecognizer(pinchToZoomRecognizer)
            currentViewOnPage.addSubview(imageView)
                
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
    
    
    
   
  
    
}
