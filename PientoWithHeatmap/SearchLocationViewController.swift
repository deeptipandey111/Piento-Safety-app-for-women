//
//  SearchLocationViewController.swift
//  PientoWithHeatmap
//
//  Created by Deepti Pandey on 18/04/18.
//  Copyright © 2018 Tapzo. All rights reserved.
//

import UIKit
import GooglePlaces

protocol LocationSelectionProtocol: class {
    func didSelectLocation(_ location: GMSPlace, sentFrom: SentFrom)
    
}

class SearchLocationViewController: UIViewController {

    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var tableDataSource: GMSAutocompleteTableDataSource?
    var sentFrom: SentFrom!
    weak var delegate: LocationSelectionProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(SearchLocationViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SearchLocationViewController.keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        addResultsVC()
        navigationController?.navigationBar.isTranslucent = false
        searchController?.hidesNavigationBarDuringPresentation = false
        // This makes the view area include the nav bar even though it is opaque.
        // Adjust the view placement down.
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = .top
        let leftBarButtonItem = UIBarButtonItem(title: "DONE", style: UIBarButtonItemStyle.plain, target: self, action:#selector(SearchLocationViewController.cancelTapped))
        navigationItem.rightBarButtonItem = leftBarButtonItem
        self.searchController?.searchBar.becomeFirstResponder()
    }
    @objc func cancelTapped(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    func getAutocompleteResults(){
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }

    // MARK: - Keyboard notifications
    
    @objc func keyboardDidHide(_ notification: Notification) {
        self.searchController?.searchBar.showsCancelButton = false
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        
        _ = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size
        self.searchController?.searchBar.showsCancelButton = false
        UIView.animate(withDuration: 0.1, animations: { [unowned self] () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    func addResultsVC(){
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar

        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
    }
    
}


extension SearchLocationViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension SearchLocationViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        delegate?.didSelectLocation(place, sentFrom: self.sentFrom)
        self.dismiss(animated: true, completion: nil)
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
}


