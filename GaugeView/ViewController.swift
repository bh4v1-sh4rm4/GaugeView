//
//  ViewController.swift
//  GaugeView
//
//  Created by Bhavishya Sharma on 15/11/24.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var gaugeView: UIView!
    
    @IBOutlet var tfValue: UITextField!
    let startAngle = CGFloat(-180).degreesToRadians // Start at 0° on the left
    let endAngle = CGFloat(0).degreesToRadians    // End at 180° on the right
    let needleImageView = UIImageView(image: UIImage(named: "polygon"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfValue.delegate = self
        setup()
    }
    
    func setup() {
        needleImageView.contentMode = .center
        needleImageView.center = CGPoint(x: gaugeView.bounds.minX + 50, y: gaugeView.bounds.maxY)
        gaugeView.addSubview(needleImageView)
    }
    
    @IBAction func btnAnimate(_ sender: Any) {
//        animateNeedle(to: 1, duration: 1.5)
        let WageConversion = (tfValue.text! as NSString).floatValue
        animateNeedle(to: CGFloat(WageConversion), duration: 1.5)
    }
    func animateNeedle(to value: CGFloat, duration: CFTimeInterval) {
        let startAngle2 = CGFloat(0).degreesToRadians // Start at 0° on the left
        let endAngle2 = CGFloat(180).degreesToRadians

        let targetAngle = startAngle2 + ((endAngle2 - startAngle2) * value)

        let rotation = CABasicAnimation(keyPath: "transform.rotation")

        rotation.fromValue = needleImageView.layer.presentation()?.value(forKeyPath: "transform.rotation") as? CGFloat ?? startAngle2

        rotation.toValue = targetAngle

        rotation.duration = 1.5
        rotation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        needleImageView.layer.add(rotation, forKey: "rotation")

        needleImageView.layer.setValue(targetAngle, forKeyPath: "transform.rotation")

        let needlePath = UIBezierPath(arcCenter: CGPoint(x: gaugeView.bounds.midX, y: gaugeView.bounds.maxY),
                                      radius: (gaugeView.bounds.width / 2 ) - 55,
                                      startAngle: startAngle,
                                      endAngle: startAngle + (endAngle - startAngle) * value,
                                      clockwise: true)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = needlePath.cgPath
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        needleImageView.layer.add(animation, forKey: "moveAlongPath")
        
        needleImageView.center = needlePath.currentPoint
       
    }
}
extension CGFloat {
    var degreesToRadians: CGFloat {
        return self * .pi / 180
    }
}

