//
//  MapDetailViewController.swift
//  ON THE MAP
//
//  Created by liang on 4/16/16.
//  Copyright © 2016 liang. All rights reserved.
//

import UIKit
import MapKit

class MapDetailViewController: UIViewController,MKMapViewDelegate,UITextViewDelegate {
    var appDelegate: AppDelegate!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textView: UITextView!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        mapView.delegate = self
        textView.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        self.pointAnnotation = MKPointAnnotation()
        self.pointAnnotation.title = "Location"
        self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: self.appDelegate.location.coordinate.latitude, longitude:self.appDelegate.location.coordinate.longitude)
        self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
        self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
    }
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        textView.text = ""
        return true
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @IBAction func submit(sender: AnyObject) {
        let uniqueKey = Constants.uniqueKey
        let firstName = Constants.firstName
        let lastName = Constants.lastName
        let mapString = self.appDelegate.mapString
        let latitude = Double(self.appDelegate.location.coordinate.latitude)
        let longitude = Double(self.appDelegate.location.coordinate.longitude)
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"https://udacity.com\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                print("Post location error")
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            self.complete()
        }
        task.resume()
    }
    private func complete() {
        performUIUpdatesOnMain {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    @IBAction func cancel(sender: AnyObject) {
        complete()
    }
}
