//
//  LocationViewController.swift
//  PientoWithHeatmap
//
//  Created by Deepti Pandey on 18/04/18.
//  Copyright © 2018 Tapzo. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces

enum LocationEnum : String{
    case Post = "post"
    case Put = "put"
    case GoogleSearches = "googleAddress"
    case Recent = "recent"
    case Home = "home"
    case Work = "work"
    case HomeWork = "HomeWork"
    case Destination = "Destination"
    case Source = "Source"
    case Blank = "blank"
}

protocol GetAddressProtocol : class {
    func getAddress(_ location : CLLocation? , address : String? )
    func didTapOnCurrentLocation()
    func didTapOnDestCurrentLocation()
}

class LocationViewController: UIViewController {
    
    @IBOutlet weak var tableView:  UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    @IBOutlet weak var errorView: UIView!
    weak var getAddressDelegate : GetAddressProtocol?
    let geoGMSCoder = GMSGeocoder()
    
    var screen = "Availabilty"
    var shouldFirstRespoder = true
    
    var searchBar:UISearchBar =     UISearchBar()
    var locationManger : CLLocationManager!
    var placeHolder = "Enter location manually"
    var openFrom : LocationEnum?
    
    var dataArray : [[String:AnyObject]] =      []
    var check = false
    var serverCheck = false
    var callfromViewDidLoad = true
    var firstTimeLoadBlankCell = true
    
    var selectedAddress : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0)
        view.needsUpdateConstraints()
        
        locationManger = CLLocationManager()
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        if openFrom == .Destination{
            placeHolder = "Enter Drop Location"
        }
        
        setupSearchBar()
        setInitialSetUp()
        
        
      
        
        NotificationCenter.default.addObserver(self, selector: #selector(LocationViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LocationViewController.keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
   
    func fetchGoogleQuery(_ searchText : String){
        let filter : GMSAutocompleteFilter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.noFilter
        filter.country = "in"
        var bounds: GMSCoordinateBounds? = nil
//        if let currentLat = LocationVader.sharedVader.currentLat, let currentLong = LocationVader.sharedVader.currentLong {
//
//            let locationCoordinate = CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong)
//
//            bounds = GMSCoordinateBounds(coordinate: CabsUtility.coordinateFromCoord(locationCoordinate, distanceKM: 50, bearingDegrees: 45), coordinate: CabsUtility.coordinateFromCoord(locationCoordinate, distanceKM: 50, bearingDegrees: 135))
//        }
//
//        let placeClient : GMSPlacesClient = GMSPlacesClient()
//        placeClient.autocompleteQuery(searchText, bounds: bounds, filter: filter){ (results, error: Error?) -> Void in
//            guard error == nil else {
//                print("Autocomplete error \(error)")
//                return
//            }
//
//
//            var recentSearchesArr:[HomeWorkAddressData] = []
//
//            for result in results! {
//                //print("placeID : \(result.placeID)")
//                recentSearchesArr.append(HomeWorkAddressData(id : nil, type: .GoogleSearches, address: result.attributedFullText.string, long: 0, lat: 0, companyId: nil , categoryId: nil, placeID : result.placeID))
//            }
//            if self.check {
//                self.dataArray = []
//                self.dataArray.append(["type":LocationEnum.GoogleSearches.rawValue as AnyObject,"data":recentSearchesArr as AnyObject])
//                self.tableView.reloadData()
//            }
//
//        }


    }
    
    
    
//    func getCordinatesFromAddress(_ selectedAddress : String?, placeID : String?){
//
//        if let selectedAddress = selectedAddress{
//            self.selectedAddress = selectedAddress
//            loadingView.startAnimating()
//            LocationDataProvider.sharedInstance.getCordinatesFromAddress(selectedAddress, placeID : placeID)
//            if openForCategory == .Cabs{
//                CabsUtility.sendAddressSelected(selectedAddress)
//            }
//        }
//    }
    
    func dismissVC(_ address : String? , long : NSNumber? , lat : NSNumber?){
        
        var location :CLLocation?
        
        if let lat = lat as? CLLocationDegrees{
            if let long = long as? CLLocationDegrees{
                location  = CLLocation(latitude: lat, longitude: long)
            }
        }
        getAddressDelegate?.getAddress(location, address: address)
        getAddressDelegate = nil
        if let navController = self.navigationController{
            
            navController.dismiss(animated: true, completion: nil)
        }
    }
    
    func openAddEditVC(_ ofPlace : LocationEnum , apiMethod : LocationEnum , id : NSNumber?){
        
        var title = ""
        
        if ofPlace == .Home{
            
            if apiMethod == .Post{
                title = "Add Home"
            }else if apiMethod == .Put{
                title = "Edit Home"
            }
            
        }else if ofPlace == .Work{
            if apiMethod == .Post{
                title = "Add Work"
            }else if apiMethod == .Put{
                title = "Edit Work"
            }
            
        }
    }
    @IBAction func cancelTapped(_ sender: AnyObject) {
        
        if let navController = self.navigationController{
            navController.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func AutoDetectTapped(_ sender: AnyObject) {
        
        if openFrom == .Source{
            if getAddressDelegate != nil{
                getAddressDelegate?.didTapOnCurrentLocation()
                if let navController = self.navigationController{
                    navController.dismiss(animated: true, completion: nil)
                }
            }
            
        }else if openFrom == .Destination{
            getAddressDelegate?.didTapOnDestCurrentLocation()
            if let navController = self.navigationController{
                navController.dismiss(animated: true, completion: nil)
            }
        }else{
            findCurrentLocation()
        }
      
    }
    
    func findCurrentLocation(){
        self.searchBar.resignFirstResponder()

        if CLLocationManager.locationServicesEnabled() {
            dataArray = []
            reloadTableViewAnimated()
            loadingView.startAnimating()
            locationManger.startUpdatingLocation()
        } else {

//            HelpchatVader.appVader.locationAlwaysAllow()
        }
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location : CLLocation = locations.first!
        
        geoGMScode(location)
        
        locationManger.stopUpdatingLocation()
    }
    
}

extension LocationViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        let dataHash = dataArray[indexPath.section]
//        let homeWorkArray = dataHash["data"] as! [HomeWorkAddressData]
//        let locationData = homeWorkArray[indexPath.row]
//        if locationData.type == .Home || locationData.type == .Work{
//            //if locationData.address != "" {
//            return 55
//            //}
//        }
//        if locationData.type == .Blank{
//            return 55
//        }
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if ServiceUtility.isNetworkAvailable(){
//            let dataHash = dataArray[indexPath.section]
//            let homeWorkArray = dataHash["data"] as! [HomeWorkAddressData]
//            let locationData = homeWorkArray[indexPath.row]
//            self.searchBar.resignFirstResponder()
//
//            if locationData.type == .Recent || locationData.type == .GoogleSearches{
//
//                getCordinatesFromAddress(locationData.address, placeID: locationData.placeID)
//
//            }else if locationData.type == .Home{
//                if locationData.address == ""{
//                    openAddEditVC(.Home, apiMethod: .Post , id: nil)
//                }else{
//                    if let long = locationData.long{
//                        if let lat = locationData.lat{
//                            dismissVC(locationData.address, long: long, lat: lat)
//
//                        }else{
//                            getCordinatesFromAddress(locationData.address, placeID: locationData.placeID)
//                        }
//
//                    }else{
//                        getCordinatesFromAddress(locationData.address, placeID: locationData.placeID)
//                    }
//
//                }
//
//            }else if locationData.type == .Work{
//
//                if locationData.address == ""{
//                    openAddEditVC(.Work, apiMethod: .Post , id : nil)
//                }else{
//                    if let long = locationData.long{
//                        if let lat = locationData.lat{
//                            dismissVC(locationData.address, long: long, lat: lat)
//
//                        }else{
//                            getCordinatesFromAddress(locationData.address, placeID: locationData.placeID)
//                        }
//
//                    }else{
//                        getCordinatesFromAddress(locationData.address, placeID: locationData.placeID)
//                    }
//                }
//
//            }
//        }else{
//            ServiceUtility.presentNoInternetToast()
//        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let locationDataArray = dataArray[section]["type"] as! String
        if locationDataArray == LocationEnum.Recent.rawValue {
            return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionName = "Recent Searches"
        
        let sectionHeader = UIView(frame: CGRect(x: 0,y: 0,width: tableView.frame.width,height: 40))
//        sectionHeader.backgroundColor = UIColor.tableViewBackground()
        let titleLabel = UILabel(frame: CGRect(x: 18,y: 14,width: sectionHeader.frame.width,height: sectionHeader.frame.height-20))
        
//        titleLabel.attributedText = SFUIAttributedText.mediumAttributedTextForString(sectionName , size: 17, color: UIColor.circleColor(at: 6))
        
        sectionHeader.addSubview(titleLabel)
        
        return sectionHeader
        
    }
    
}

extension LocationViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataHash = dataArray[indexPath.section]
//        let homeWorkArray = dataHash["data"] as! [HomeWorkAddressData]
//        let locationData = homeWorkArray[indexPath.row]
//        var cell : CabsLocationTableViewCell!
        var cell = UITableViewCell()
//        if locationData.type == .Home || locationData.type == .Work{
//
//
//
//            if locationData.type == .Home{
//
//                if locationData.address != "" {
//
//                    let cellIdentifier = "addHomeWorkIdentifier"
//                    cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CabsLocationTableViewCell
//
//                    cell.addHomeLabel.text = "Home"
//                    cell.addHomeAddressLabel.text = locationData.address
//                    cell.editAddress.isHidden = false
//                    cell.id = locationData.id
//                    cell.type = locationData.type
//                    cell.editAddressDelegate = self
//                    cell.topConstraintToAddress.constant = 3
//                    cell.chevronImage.isHidden = true
//
//
//                }
//
//                cell.addHomeImage.image = UIImage(named: "cab_home")
//
//            }
//
//            if indexPath.row == 0 {
//                cell.viewLeadingConstraint.constant = 18
//            }else{
//                cell.viewLeadingConstraint.constant = 0
//            }
//
//
//        }else if locationData.type == .Recent{
        
//            let cellIdentifier = "cellRecentID"
//            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CabsLocationTableViewCell
//            cell.recentAddressLabel.text = locationData.address
//
//        }else if locationData.type == .GoogleSearches{
//
//            let cellIdentifier = "cellID"
//            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CabsLocationTableViewCell
//            cell.googleSearchLabel.text = locationData.address
//        }else if locationData.type == .Blank{
////            let cellIdentifier = "blankAddressCellIdentifier"
//            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CabsLocationTableViewCell
//
//            if indexPath.row == 0 {
//                cell.placeholderViewConstraint.constant = 18
//            }else{
//                cell.placeholderViewConstraint.constant = 0
//            }
//
//        }
//        self.tableView.layoutIfNeeded()
        return cell
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        let locationDataArray = self.dataArray[section]["data"] as! [HomeWorkAddressData]
//
//        if let type = self.dataArray[section]["type"] as? String{
//            if type == LocationEnum.GoogleSearches.rawValue && locationDataArray.count == 0{
//                errorView.isHidden = false
//            }else{
//                errorView.isHidden = true
//            }
//        }
//
//        return locationDataArray.count
        return 5
    }
}
extension LocationViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            check = false
            
            setInitialSetUp()
            
            
        }else{
            check = true
            fetchGoogleQuery(searchText)
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
}

//extension LocationViewController : LocationViewProtocol{
//    func getHomeWorkAddress(_ data: [HomeWorkAddressData]) {
//        serverCheck = true
//        serverArray = data
//        setInitialSetUp()
//    }
//    func errorHomeWorkAddress(){
//        serverCheck = false
//        setInitialSetUp()
//        
//    }
//}
extension LocationViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
        
    }
}
//extension LocationViewController : EditAddressProtocol{
//    func editAddress(_ id: NSNumber , type : LocationEnum) {
//        openAddEditVC(type, apiMethod: .Put, id: id)
//    }
//}
//extension LocationViewController : GetCordinatesProtocol{
//    func recievedCordinates(_ location: CLLocation?, placeID : String?) {
//        loadingView.stopAnimating()
//
//        if let selectedAddress = self.selectedAddress{
//            dismissVC(selectedAddress, long: location?.coordinate.longitude as NSNumber?, lat: location?.coordinate.latitude as NSNumber?)
//            setRecentPlace(selectedAddress, placeID: placeID)
//
//        }
//
//
//    }
//    func errorRecievingCordinates() {
//        loadingView.stopAnimating()
//        loaderrorPopUP()
//    }
//}

// MARK :- Set up search bar
extension LocationViewController{
    
    
    func setupSearchBar(){
        
        self.navigationController!.navigationBar.tintColor = UIColor.white
        searchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width-100, height: 40.0))
        searchBar.delegate = self
        
        searchBar.barTintColor = UIColor.white
        searchBar.placeholder  = placeHolder
//        searchBar.tintColor    = UIColor.searchBarPlaceholder()
//        searchBar.backgroundImage = UIImage.getImageWithColor(UIColor.clear, size: CGSize(width: 1, height: 1))
//        searchBar.backgroundColor = UIColor.theme()
        searchBar.searchBarStyle = .minimal
        
        searchBar.setImage(UIImage(named: "search-white"), for: UISearchBarIcon.search, state: UIControlState())
        searchBar.setImage(UIImage(named: "search-white"), for: UISearchBarIcon.search, state: .highlighted)
        
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = UIColor.white
            let textFieldInsideSearchBarLabel = textFieldInsideSearchBar.value(forKey: "placeholderLabel") as? UILabel
            textFieldInsideSearchBarLabel?.textColor = UIColor.white
        }
        
        let leftnavButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftnavButton
        
        searchBar.showsCancelButton = false
        
        _ = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(LocationViewController.addFirstResponder), userInfo: nil , repeats: false)
        
        
    }
    
    @objc func addFirstResponder(){
        if shouldFirstRespoder{
            self.searchBar.becomeFirstResponder()
        }
    }
    
    
    
    func geoGMScode(_ location : CLLocation){
        
        let coordinate : CLLocationCoordinate2D = location.coordinate
        var address : String?
        
        geoGMSCoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let addressSent = response?.firstResult() {
                if let lines = addressSent.lines {
                    
                    address = lines.joined(separator: ", ")
                    
                    self.dismissVC(address, long: location.coordinate.longitude as NSNumber?, lat: location.coordinate.latitude as NSNumber?)
                    self.loadingView.stopAnimating()
                }
                
            }
            
            
        }
    }
    func addBlankCell(){
        if firstTimeLoadBlankCell{
            
//            var homeArray : [HomeWorkAddressData] = []
//            homeArray.append(HomeWorkAddressData(type: .Blank))
//            homeArray.append(HomeWorkAddressData(type: .Blank))
//            dataArray.append(["type":LocationEnum.Blank.rawValue as AnyObject, "data":homeArray as AnyObject])
        }
        firstTimeLoadBlankCell = false
        
    }
    
    func setInitialSetUp(){
        dataArray = []
        reloadTableViewAnimated()
    }
    
    func loaderrorPopUP(){
        self.searchBar.resignFirstResponder()
        
        let alert = UIAlertController(title: "UNKNOWN ADDRESS", message: "There was no address associated with this place. Please try another search.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK ", style: UIAlertActionStyle.cancel, handler:  {action in
            //            self.searchBar.resignFirstResponder()
            //            self.setInitialSetUp()
        }))
        
        alert.view.tintColor = UIColor.purple
        self.present(alert, animated: true, completion: nil)
    }
    
    func reloadTableViewAnimated(){
        
        UIView.transition(with: tableView,
                          duration:0.25,
                          options:.transitionCrossDissolve,
                          animations:
            { () -> Void in
                self.tableView.reloadData()
        },
                          completion: nil);
    }
    // MARK: - Keyboard notifications
    
    @objc func keyboardDidHide(_ notification: Notification) {
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        
        let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size
        
        UIView.animate(withDuration: 0.1, animations: { [unowned self] () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
}



