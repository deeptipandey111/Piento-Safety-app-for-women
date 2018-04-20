//
//  Helper.swift
//  PientoWithHeatmap
//
//  Created by Deepti Pandey on 19/04/18.
//  Copyright © 2018 Tapzo. All rights reserved.
//

import Foundation

extension UIViewController{
    func setUpTheme(){
        self.navigationController?.navigationBar.barTintColor = UIColor.theme()
        self.navigationController?.navigationBar.barTintColor = UIColor.theme()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
    }
}

extension UILabel{
    
    func jiggle(repeatCount : Float, duration : CFTimeInterval){
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
        
    }
}


extension UIColor {
    struct Rating {
        static var One: UIColor  { return UIColor.red }
        static var Two: UIColor { return UIColor.cyan }
        static var Three: UIColor { return UIColor.orange }
        static var Four: UIColor { return UIColor.yellow }
        static var Five: UIColor { return UIColor.green }
    }
    var Theme: UIColor { return UIColor.purple}
}

extension UIView{
    func animateView(_ viewToAnimate: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint.init(x: viewToAnimate.center.x - 5, y: viewToAnimate.center.y))
        animation.fromValue = NSValue(cgPoint: CGPoint.init(x: viewToAnimate.center.x + 5, y: viewToAnimate.center.y))
        viewToAnimate.layer.add(animation, forKey: "position")
    }
}

