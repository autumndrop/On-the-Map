//
//  AddLocationViewController.swift
//  ON THE MAP
//
//  Created by liang on 4/16/16.
//  Copyright © 2016 liang. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddLocationViewController: UIViewController, UITextViewDelegate {

    var appDelegate: AppDelegate!
    @IBOutlet weak var textView: UITextView!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        textView.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        textView.text = ""
        return true
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @IBAction func findLocation(sender: AnyObject) {
        if let address = self.textView.text{
            self.appDelegate.mapString = address
            localSearchRequest = MKLocalSearchRequest()
            localSearchRequest.naturalLanguageQuery = address
            localSearch = MKLocalSearch(request: localSearchRequest)
            localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
                
                if localSearchResponse == nil{
                    let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    return
                }
                
                self.appDelegate.location = CLLocation(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
                self.startMapDetailViewActivity()
                
            }
        }
    }
    private func startMapDetailViewActivity() {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapDetailViewController") as! MapDetailViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        complete()
    }
    private func complete() {
        performUIUpdatesOnMain {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
}
