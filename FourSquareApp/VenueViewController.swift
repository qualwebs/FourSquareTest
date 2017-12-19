//
//  VenueViewController.swift
//  FourSquareApp
//
//  Created by Manisha  Sharma on 19/12/2017.
//  Copyright © 2017 Qualwebs. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class VenueViewController: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var tableViewVenue: UITableView!
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var arrayVenue = [Venue]()
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = "https://api.foursquare.com/v2/venues/search?ll=\(String(describing: latitude!)),\(String(describing: longitude!))&client_secret=DNQQT0USFFYJWGZTGKFBUTKV5DXLCENALTIAZQFM5YCQ3CAO&client_id=ASV0GQH1PGYMLMUORSFPCZVQA2RD02JSID5LDWMY51CISWWK&v=20171212&limit=50"
        callApi(url: url)
        showActivityIndicatory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = "Venues"
    }
    
    func showActivityIndicatory() {
        actInd = UIActivityIndicatorView()
        actInd.frame.size = CGSize(width: 50.0, height: 50.0)
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.gray
        self.view.addSubview(actInd)
        actInd.startAnimating()
    }
    
    func attributedString(text: String, boldString: String) -> NSMutableAttributedString
    {
        let attribute = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
        let boldAttribute = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15)]
        let attributedString = NSMutableAttributedString(string: text, attributes: attribute)
        let range = (text as NSString).range(of: boldString)
        attributedString.addAttributes(boldAttribute, range: range)
        return attributedString
    }
    
    func callApi(url: String) {
        Alamofire.request(url).responseJSON { (dataResponse) in
            print(dataResponse)
            switch dataResponse.result {
            case .success(_):
                let dictResponse = dataResponse.result.value as AnyObject
                let response = dictResponse.value(forKey: "response") as AnyObject
                let venueResponse = response.value(forKey: "venues") as AnyObject
                for index in 0..<venueResponse.count {
                    let id = String(describing: ((venueResponse.value(forKey: "id") as AnyObject).object(at: index)))
                    let name = String(describing: ((venueResponse.value(forKey: "name") as AnyObject).object(at: index)))
                    let contactInfo = (venueResponse.value(forKey: "contact") as AnyObject).object(at: index) as AnyObject
                    let phone = String(describing:(contactInfo.value(forKey: "phone") as AnyObject))
                    let formattedPhone = String(describing:(contactInfo.value(forKey: "formattedPhone") as AnyObject))
                    let twitter = String(describing:(contactInfo.value(forKey: "twitter") as AnyObject))
                    let instagram = String(describing:(contactInfo.value(forKey: "instagram") as AnyObject))
                    let facebook = String(describing:(contactInfo.value(forKey: "facebook") as AnyObject))
                    let facebookUserName = String(describing:(contactInfo.value(forKey: "facebookUsername") as AnyObject))
                    let facebookName = String(describing:(contactInfo.value(forKey: "facebookName") as AnyObject))
                    let location = (venueResponse.value(forKey: "location") as AnyObject).object(at: index) as AnyObject
                    let labeledLatLngs = (location.value(forKey: "labeledLatLngs") as AnyObject)
                    let lat = String(describing:(location.value(forKey: "lat") as AnyObject))
                    let lng = String(describing:(location.value(forKey: "lng") as AnyObject))
                    let address = String(describing:(location.value(forKey: "address") as AnyObject))
                    let venue = Venue(name: name, address: address, contactNumber: "", id: id, lat: lat, lng: lng)
                    if phone != "<null>" {
                        venue.contactNumber = phone
                    } else if formattedPhone != "<null>" {
                        venue.contactNumber = formattedPhone
                    } else if facebook != "<null>" {
                        venue.contactNumber = "By Facebook"
                    } else if facebookName != "<null>" {
                        venue.contactNumber = "By Facebook"
                    } else if facebookUserName != "<null>" {
                        venue.contactNumber = "By Facebook"
                    } else if instagram != "<null>" {
                        venue.contactNumber = "By Instagram"
                    } else if twitter != "<null>" {
                        venue.contactNumber = "By Twitter"
                    } else {
                        venue.contactNumber = "Not Found"
                    }
                    self.arrayVenue.append(venue)
                }
                self.actInd.stopAnimating()
                self.tableViewVenue.reloadData()
                break
            case .failure(_):
                break
            }
        }
    }
    
}
extension VenueViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayVenue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VenueTableViewCell", for: indexPath) as! VenueTableViewCell
        let venue = arrayVenue[indexPath.row]
        
        cell.labelName.attributedText = attributedString(text: "Name: \(venue.name)", boldString: "Name:")
        if venue.address == "<null>" {
            cell.labelAddress.attributedText = attributedString(text: "Address: Not Found", boldString: "Address:")
        } else {
            cell.labelAddress.attributedText = attributedString(text: "Address: \(venue.address)", boldString: "Address:")
        }
        cell.labelContactNumber.attributedText = attributedString(text: "Contact: \(venue.contactNumber)", boldString: "Contact:")
        if venue.lat == "0" {
            cell.buttonShowOnMap.isHidden = true
        } else {
            cell.buttonShowOnMap.isHidden = false
        }
        cell.showLocationTapped = {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            VC.latitude = CLLocationDegrees(venue.lat)
            VC.longitude = CLLocationDegrees(venue.lng)
            self.navigationController?.pushViewController(VC, animated: true)
        }
        return cell
    }
}
extension VenueViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "VenueImagesViewController") as! VenueImagesViewController
        let venue = arrayVenue[indexPath.row]
        VC.venueId = venue.id
        navigationController?.pushViewController(VC, animated: true)
    }
}
