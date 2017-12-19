//
//  VenueImagesViewController.swift
//  FourSquareApp
//
//  Created by Manisha  Sharma on 19/12/2017.
//  Copyright © 2017 Qualwebs. All rights reserved.
//

import UIKit
import Alamofire

class VenueImagesViewController: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var collectionViewVenueImages: UICollectionView!
    @IBOutlet weak var labelNoImageFound: UILabel!
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var arrayVenueImage = [String]()
    var venueId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = "https://api.foursquare.com/v2/venues/\(venueId)/photos?client_id=ASV0GQH1PGYMLMUORSFPCZVQA2RD02JSID5LDWMY51CISWWK&client_secret=DNQQT0USFFYJWGZTGKFBUTKV5DXLCENALTIAZQFM5YCQ3CAO&v=20170801"
        callApi(url: url)
        showActivityIndicatory()
        collectionViewVenueImages.isHidden = true
        labelNoImageFound.isHidden = true
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
    
    func callApi(url: String) {
        Alamofire.request(url).responseJSON { (dataResponse) in
            print(dataResponse)
            switch dataResponse.result {
            case .success(_):
                let dictResponse = dataResponse.result.value as AnyObject
                let response = (dictResponse.value(forKey: "response") as AnyObject).value(forKey: "photos") as AnyObject
                let itemCount = response.value(forKey: "count") as? Int
                let itemResponse = response.value(forKey: "items") as AnyObject
                for index in 0..<itemResponse.count {
                    let prefix = String(describing: ((itemResponse.value(forKey: "prefix") as AnyObject).object(at: index)))
                    let suffix = String(describing: ((itemResponse.value(forKey: "suffix") as AnyObject).object(at: index)))
                    let imageUrl = "\(prefix)300x300\(suffix)"
                    self.arrayVenueImage.append(imageUrl)
                }
                self.actInd.stopAnimating()
                if self.arrayVenueImage.count > 0 {
                    self.collectionViewVenueImages.isHidden = false
                    self.labelNoImageFound.isHidden = true
                } else {
                    self.collectionViewVenueImages.isHidden = true
                    self.labelNoImageFound.isHidden = false
                }
                self.collectionViewVenueImages.reloadData()
                break
            case .failure(_):
                break
            }
        }
    }
}

extension VenueImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayVenueImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VenueImageCollectionViewCell", for: indexPath) as! VenueImageCollectionViewCell
        let venueImageUrl = arrayVenueImage[indexPath.row]
        cell.venueImage.sd_setImage(with: URL(string: venueImageUrl)!)
        return cell
    }
}
