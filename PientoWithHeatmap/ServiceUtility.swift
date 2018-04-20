//
//  ServiceUtility.swift
//  PientoWithHeatmap
//
//  Created by Deepti Pandey on 18/04/18.
//  Copyright © 2018 Tapzo. All rights reserved.
//

import Foundation

class ServiceUtility: NSObject {
    
    
    class func isNetworkAvailable() -> Bool{
        if let reachability = Network.reachability{
            return reachability.isReachable
        }else{
            return false
        }
    }
    class func presentNoInternetToast(){
        let presentToast = UIApplication.shared.keyWindow
        if let toast = presentToast {
            toast.makeToast(message: "No Internet Connection!", duration: 3.0, position: HRToastPositionDefault as AnyObject)
        }
        
    }
    
    class func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
