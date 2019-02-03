//
//  ViewController.swift
//  3D Carousel
//
//  Created by Nolan Fuchs on 2/3/19.
//  Copyright © 2019 Nolan Fuchs. All rights reserved.
//

import UIKit

func degreeToRadians(degree: CGFloat) -> CGFloat {
    return (degree * CGFloat.pi)/180
}

class ViewController: UIViewController {
    
    let transfromLayer = CATransformLayer()
    var currentAngle: CGFloat = 0
    var currentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 1.0)
        
        transfromLayer.frame = self.view.bounds
        view.layer.addSublayer(transfromLayer)
        
        // Add all images from assets
        for i in 1...6 {
            addImage(name: "\(i)")
        }
        
        turnCarousel()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.performAction(recognizer:)))
        view.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    // Light Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
   
    func addImage(name: String) {
        
        let imageCardSize = CGSize(width: 200, height: 300)
        let imageLayer = CALayer()
        imageLayer.frame = CGRect(x: view.frame.size.width / 2 - imageCardSize.width / 2 , y: view.frame.size.height / 2 - imageCardSize.height / 2, width: imageCardSize.width, height: imageCardSize.height)
        
        imageLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        guard let imageCardImage = UIImage(named: name)?.cgImage else { return }
        
        imageLayer.contents = imageCardImage
        imageLayer.contentsGravity = .resizeAspectFill
        imageLayer.masksToBounds = true
        imageLayer.isDoubleSided = true
        
        imageLayer.borderColor = UIColor(white: 1, alpha: 1.0).cgColor
        imageLayer.borderWidth = 5
        imageLayer.cornerRadius = 10
        
        transfromLayer.addSublayer(imageLayer)
        
    }
    
    func turnCarousel() {
        guard let transformSubLayers = transfromLayer.sublayers else { return }
        
        let segmentForImageCard = CGFloat(360 / transformSubLayers.count)
        
        var angleOffset = currentAngle
        
        for layer in transformSubLayers {
            var transform = CATransform3DIdentity
            transform.m34 = -1 / 500
            
            transform = CATransform3DRotate(transform, degreeToRadians(degree: angleOffset), 0, 1, 0)
            transform = CATransform3DTranslate(transform, 0, 0, 200)
            
            CATransaction.setAnimationDuration(0)
            
            angleOffset += segmentForImageCard
            
            layer.transform = transform
        }
        
        
        
    }
    
    
    @objc func performAction(recognizer: UIPanGestureRecognizer) {
        
        let xOffset = recognizer.translation(in: self.view).x
        
        if recognizer.state == .began {
            currentOffset = 0
        }
        
        let xDifference = xOffset * 0.6 - currentOffset
        
        currentOffset += xDifference
        currentAngle += xDifference
        
        turnCarousel()
        
    }

}

