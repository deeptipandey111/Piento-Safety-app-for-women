//
//  RatingViewController.swift
//  PientoWithHeatmap
//
//  Created by Deepti Pandey on 19/04/18.
//  Copyright © 2018 Tapzo. All rights reserved.
//

import UIKit
import GooglePlaces
let ratingStackId: String = "ratingStack"

var kRatingData: String = "RatingData"

class RatingViewController: UIViewController {
    
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var headingLabel: UILabel!
    var location: GMSPlace!
    var rating: Int?
    
    @IBAction func didTapOnDone(_ sender: UIButton) {
        handleRating()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Rate"
        ratingControl.delegate = self
        headingLabel.text = "How safe did you feel at \(location.name) ?"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        handleRating()
    }
    
    func handleRating(){
        if let rating = rating{
            let ratingObject = RatingObject(location.coordinate.latitude, alon: location.coordinate.longitude, arating: Double(rating))
            let ratingDict = createDictArray([ratingObject]).first!
            if let data = UserDefaults.standard.object(forKey: kRatingData) as? Data{
                if let oldData = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[String: AnyObject]]{
                    if getRatingArrayFromDicts(oldData).count > 0{
                        var appendedData = oldData
                        
                        appendedData.append(createDictArray([ratingObject]).first!)
                        let ratings = getRatingArrayFromDicts(appendedData)
                        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: createDictArray(ratings)), forKey: kRatingData)
                    }else{
                        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: [ratingDict]), forKey: kRatingData)
                    }
                }else{
                    UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: [ratingDict]), forKey: kRatingData)
                }
            }else{
                UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: [ratingDict]), forKey: kRatingData)
            }
        }
    }
    func createDictArray(_ oldratings: [RatingObject]) -> [[String: AnyObject]] {
        var array: [[String: AnyObject]] = []
        for rating in oldratings{
            var roomParam: [String: AnyObject] = [:]
            roomParam[klat] = rating.lat as AnyObject
            roomParam[klong] = rating.lon as AnyObject
            roomParam[kRating] = rating.rating as AnyObject
            array.append(roomParam)
        }
        return array
    }
    
    func getRatingArrayFromDicts(_ dictArray: [[String: AnyObject]]) -> [RatingObject] {
        var ratings: [RatingObject] = []
        for roomParam in dictArray {
            if let nAdults = roomParam[klat] as? Double, let nChildren =  roomParam[klong] as? Double, let chAges =  roomParam[kRating] as? Double{
                ratings.append(RatingObject(nAdults, alon: nChildren, arating: chAges))
            }
        }
        return ratings
    }
}

extension RatingViewController: RatingProtocol{
    func didSelectRatingForPlace(_ rating: Int) {
        self.rating = rating
    }
}
