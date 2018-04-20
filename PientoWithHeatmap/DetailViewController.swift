//
//  DetailViewController.swift
//  PientoWithHeatmap
//
//  Created by Deepti Pandey on 16/04/18.
//  Copyright © 2018 Tapzo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import SafariServices
import GooglePlaces
import Alamofire
import SwiftyJSON

enum SentFrom: String{
    case Source = "Source",
    Destination = "Destination"
}

let klat: String = "lat"
let klong: String = "lon"
let kRating: String = "ratingForRatingObject"
let kplaceId: String = "placeid"
let kname: String = "name"
let kaddress: String = "address"


var placesClient: GMSPlacesClient = GMSPlacesClient.shared()

let ratingId: String = "RatingViewControllerid"
class DetailViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!

    
    @IBAction func didTapOnSourceLocation(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = storyBoard.instantiateViewController(withIdentifier: "LocationViewControllerid") as! UINavigationController
        let vc = rootVC.viewControllers[0] as! SearchLocationViewController
        vc.delegate = self
        vc.sentFrom = SentFrom.Source
        self.present(rootVC, animated: true, completion: nil)

    }
    @IBAction func didTapOnDestinationLocation(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = storyBoard.instantiateViewController(withIdentifier: "LocationViewControllerid") as! UINavigationController
        let vc = rootVC.viewControllers[0] as! SearchLocationViewController
        vc.delegate = self
        vc.sentFrom = SentFrom.Destination
        self.present(rootVC, animated: true, completion: nil)
        
    }
    
    @IBAction func didTapOnShowDirections(_ sender: UIButton) {
        guard let asource = source else {
            jiggleView(sourceLabel)
            return
        }
        guard let adestination = destination else {
            jiggleView(destinationLabel)
            return
        }
        let sourceCL = CLLocation(latitude: asource.coordinate.latitude, longitude: asource.coordinate.longitude)
        let destCL = CLLocation(latitude: adestination.coordinate.latitude, longitude: adestination.coordinate.longitude)
        drawPath(startLocation: sourceCL, endLocation: destCL)
    }
    
    
    @IBAction func didTapOnRateSourceButton(_ sender: UIButton) {
        openRatingScreen(SentFrom.Source)
    }
    @IBAction func didTapOnRateDestinationButton(_ sender: UIButton) {
        openRatingScreen(SentFrom.Destination)
    }
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var source: GMSPlace? {
        didSet{
            if let source = source{
                mapView.clear()
                sourceLabel.text = source.name
//                self.createMarker(titleMarker: "Start Point", iconMarker: UIImage(named: "startMarker")!, coord: source.coordinate)
            }
        }
    }
    var destination: GMSPlace?{
        didSet{
            if let destination = destination{
                mapView.clear()
                destinationLabel.text = destination.name
//                self.createMarker(titleMarker: "Start Point", iconMarker: UIImage(named: "endMarker")!, coord: destination.coordinate)
            }
        }
    }
    func drawPath(startLocation: CLLocation, endLocation: CLLocation){
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&alternatives=true&provideRouteAlternatives=true"
        
        Alamofire.request(url).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            do{
                let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                // print route using Polyline
                for (index,route) in routes.enumerated() {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 4
                    if index == 0{
                        polyline.strokeColor = UIColor.red
                    }
                    if index == 1{
                        polyline.strokeColor = UIColor.green
                    }
                    if index == 2{
                        polyline.strokeColor = UIColor.yellow
                    }
                    polyline.map = self.mapView
                }
            } catch{
                print("error")
            }
        }
    }
    private var heatmapLayer: GMUHeatmapTileLayer!
    private var gradientColors = [UIColor.Rating.One, UIColor.Rating.Two, UIColor.Rating.Three, UIColor.Rating.Four, UIColor.Rating.Five]
    private var gradientStartPoints = [0.2, 0.4, 0.6, 0.8, 1.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTheme()
        self.title = "Pick your location"
        fetchSavedData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addHeatmap()
    }
    func createMarker(titleMarker: String, iconMarker: UIImage, coord: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = coord
        marker.title = titleMarker
        marker.icon = iconMarker
        marker.map = mapView
    }
    
    func fetchSavedData(){
        if let savedSourceId = UserDefaults.standard.object(forKey: SentFrom.Source.rawValue) as? String{
            getPlaceFromPlaceId(savedSourceId, sentFrom: SentFrom.Source)
        }
        if let savedDestinationid = UserDefaults.standard.object(forKey: SentFrom.Destination.rawValue) as? String{
            getPlaceFromPlaceId(savedDestinationid, sentFrom: SentFrom.Destination)
        }
    }
    func openRatingScreen(_ sentfrom: SentFrom){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ratingId) as! RatingViewController
        switch sentfrom {
        case SentFrom.Source:
            if let source = self.source{
                vc.location = source
            }else{
                jiggleView(sourceLabel)
                return
            }
            break
        case SentFrom.Destination:
            if let destination = self.destination{
                vc.location = destination
            }else{
                jiggleView(destinationLabel)
                return
            }
            break
        }
        navigationController?.pushViewController(vc, animated: true)

    }
    func jiggleView(_ viewToAnimate: UIView){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint.init(x: viewToAnimate.center.x - 5, y: viewToAnimate.center.y))
        animation.fromValue = NSValue(cgPoint: CGPoint.init(x: viewToAnimate.center.x + 5, y: viewToAnimate.center.y))
        viewToAnimate.layer.add(animation, forKey: "position")
    }
    
    func getPlaceFromPlaceId(_ placeID: String, sentFrom: SentFrom) {
        var savedPlace: GMSPlace?
        placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details for \(placeID)")
                return
            }
            savedPlace = place
            if sentFrom == SentFrom.Source{
                self.source = place
            }
            if sentFrom == SentFrom.Destination{
                self.destination = savedPlace
            }
            print("Place name \(place.name)")
        })
        
    }
    func addHeatmap()  {
        let camera = GMSCameraPosition.camera(withLatitude: 12.9, longitude: 77.6, zoom: 12.0)
        mapView.camera = camera
        heatmapLayer = GMUHeatmapTileLayer()
        // Add the latlngs to the heatmap layer.
        heatmapLayer.weightedData = createData()
        heatmapLayer.gradient = GMUGradient(colors: gradientColors,
                                            startPoints: gradientStartPoints as [NSNumber],
                                            colorMapSize: 100)
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.isMyLocationEnabled = false

        do {
            // Set the map style by passing the URL of the local file.
            
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        

        heatmapLayer.map = mapView
        heatmapLayer = GMUHeatmapTileLayer()
//        heatmapLayer.opacity = 0.7
//        heatmapLayer.radius = 50
    }
    func createData() -> [GMUWeightedLatLng]{
        var list : [GMUWeightedLatLng] = []
        if let data = UserDefaults.standard.object(forKey: kRatingData) as? Data{
            if let oldData = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[String: AnyObject]]{
                for dict in oldData{
                    if let item = getGMUWeightedLatLongFromDict(dict){
                        list.append(item)
                    }
                }
            }
        }
        return list

//        list.append(GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(12.9279 , 77.6271), intensity: 5))
//        list.append(GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(12.9105 , 77.5857), intensity: 4))
//        list.append(GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(12.9698 , 77.7499), intensity: 3))
//        list.append(GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(24.9164 , 79.5812), intensity: 2))
//        list.append(GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(28.6506 , 77.2303 ), intensity: 1))
//        list.append(GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(28.67 , 77.2303 ), intensity: 1))
//        list.append(GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(28.8 , 77.2303 ), intensity: 1))
//        list.append(GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(28.9 , 77.2303 ), intensity: 1))
//        list.append(GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(28.6506 , 77.2304 ), intensity: 1))
//        list.append(GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(28.6806 , 77.2305 ), intensity: 1))
//        list.append(GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(28.6906 , 77.2302 ), intensity: 1))
//        list.append(GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(28.1506 , 77.243 ), intensity: 1))
//        list.append(GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(28.4506 , 77.2463 ), intensity: 1))
    }
    
    func getGMUWeightedLatLongFromDict(_ dict:[String: AnyObject]) -> GMUWeightedLatLng?{
        if let lat = dict[klat] as? Double, let lon = dict[klong] as? Double, let rating = dict[kRating] as? Double{
            return GMUWeightedLatLng(coordinate: CLLocationCoordinate2D(latitude: lat,longitude: lon), intensity: Float(rating))
        }
        return nil
    }
}

extension DetailViewController: LocationSelectionProtocol{
    func didSelectLocation(_ location: GMSPlace, sentFrom: SentFrom) {
        switch sentFrom {
        case SentFrom.Source:
            self.source = location
            

            UserDefaults.standard.set(location.placeID, forKey: SentFrom.Source.rawValue)
            break
        case SentFrom.Destination:
            self.destination = location
            UserDefaults.standard.set(location.placeID, forKey: SentFrom.Destination.rawValue)
            break
        }
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 12.0)
        self.mapView.camera = camera
    }
}
extension GMSPlace{
    // MARK: - GMSMapViewDelegate
    
    
    func fetchDictionary() -> [String: AnyObject]{
        var params: [String: AnyObject] = [:]
        params[klat] = self.coordinate.latitude as AnyObject
        params[klong] = self.coordinate.latitude as AnyObject
        params[kplaceId] = self.placeID as AnyObject
        params[kname] = self.name as AnyObject
        params[kaddress] = self.formattedAddress as AnyObject

        return params
    }
}
class RatingObject : NSObject{
    var lat: Double
    var lon: Double
    var rating: Double
    
    init(_ alat : Double, alon: Double, arating: Double) {
        self.lat = alat
        self.lon = alon
        self.rating = arating
        super.init()
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


extension DetailViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.mapView.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.mapView.isMyLocationEnabled = true
        
        if (gesture) {
            self.mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.mapView.isMyLocationEnabled = true
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("COORDINATE \(coordinate)") // when you tapped coordinate
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        self.mapView.isMyLocationEnabled = true
        self.mapView.selectedMarker = nil
        return false
    }
}
