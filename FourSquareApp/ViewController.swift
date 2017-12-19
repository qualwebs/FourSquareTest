//
//  ViewController.swift
//  FourSquareApp
//
//  Created by Manisha  Sharma on 19/12/2017.
//  Copyright © 2017 Qualwebs. All rights reserved.
//

import UIKit
import GooglePlaces
//import GoogleMaps

class ViewController: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var buttonSearchLocation: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonSearchLocation.layer.borderColor = UIColor.black.cgColor
        buttonSearchLocation.layer.borderWidth = 1.0
    }
    
    func setAutoCompleteController() {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        present(autoCompleteController, animated: true, completion: nil)
    }

    //MARK: IBAction
    @IBAction func SelectVenueAction(_ sender: UIButton) {
        setAutoCompleteController()
    }
}
extension ViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: false) {
            print("place: \(place)")
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "VenueViewController") as! VenueViewController
            VC.latitude = place.coordinate.latitude
            VC.longitude = place.coordinate.longitude
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Autocomplete Error: ",error.localizedDescription)
    }
}
