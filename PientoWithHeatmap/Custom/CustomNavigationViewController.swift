//
//  CustomNavigationViewController.swift
//  Tapzo, Coraza
//
//  Created by Rahul Meena on 31/10/15.
//  Copyright © 2015 Akosha. All rights reserved.
//

import UIKit

class CustomNavigationViewController: UINavigationController {
    
//    let customNavigationAnimationController = CustomNavigationAnimationController()
//    let customInteractionController = CustomInteractionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isBeingPresented {
//            ScreenVader.sharedScreen.modallyPresentedViewController(self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func tabViewSetupWithTitle(_ title: String) {
        self.title = title
        
        let dashedTitle = title.replacingOccurrences(of: " ", with: "_")
        
        tabBarItem.image = UIImage(named: dashedTitle)
        tabBarItem.selectedImage = UIImage(named: "\(dashedTitle)_Selected")
    }
    
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        super.dismiss(animated: flag, completion: completion)
        if isBeingDismissed {
//            ScreenVader.sharedScreen.removeDismissedViewController(self)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
