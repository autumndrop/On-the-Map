//
//  MapViewController.swift
//  ON THE MAP
//
//  Created by liang on 4/16/16.
//  Copyright © 2016 liang. All rights reserved.
//


import UIKit
import MapKit

/**
 * This view controller demonstrates the objects involved in displaying pins on a map.
 *
 * The map is a MKMapView.
 * The pins are represented by MKPointAnnotation instances.
 *
 * The view controller conforms to the MKMapViewDelegate so that it can receive a method
 * invocation when a pin annotation is tapped. It accomplishes this using two delegate
 * methods: one to put a small "info" button on the right side of each pin, and one to
 * respond when the "info" button is tapped.
 */

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // The map. See the setup in the Storyboard file. Note particularly that the view controller
    // is set up as the map view's delegate.
    @IBOutlet weak var mapView: MKMapView!
    var appDelegate: AppDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        getLocations()
    }
    
    func getLocations(){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            let parsedResults:AnyObject!
            do{
                parsedResults = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            }catch{
                print("Parse Error")
                return
            }
            guard let results = parsedResults["results"] as? [[String:AnyObject]] else{
                print("Parse Array Error")
                return
            }
            for anItem in results{
                guard let objectId = anItem["objectId"] as! String! else{
                    print("Parse Location Error")
                    return
                }
                
                guard let uniqueKey = anItem["uniqueKey"] as! String! else{
                    print("Parse Location Error")
                    return
                }
                
                guard let firstName = anItem["firstName"] as! String! else{
                    print("Parse Location Error")
                    return
                }
                
                guard let lastName = anItem["lastName"] as! String! else{
                    print("Parse Location Error")
                    return
                }
                
                guard let mapString = anItem["mapString"] as! String! else{
                    print("Parse Location Error")
                    return
                }
                
                guard let mediaURL = anItem["mediaURL"] as! String! else{
                    print("Parse Location Error")
                    return
                }
                
                guard let latitude = anItem["latitude"] as! Double! else{
                    print("Parse Location Error")
                    return
                }
                
                guard let longitude = anItem["longitude"] as! Double! else{
                    print("Parse Location Error")
                    return
                }
                
                let location = Location(objectId: objectId, uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
                
                self.appDelegate.locations.append(location)
            }
            
            var annotations = [MKPointAnnotation]()
        
            
            for dictionary in self.appDelegate.locations {
                
                // Notice that the float values are being used to create CLLocationDegree values.
                // This is a version of the Double type.
                let lat = CLLocationDegrees(dictionary.latitude)
                let long = CLLocationDegrees(dictionary.longitude)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = dictionary.firstName
                let last = dictionary.lastName
                let mediaURL = dictionary.mediaURL
                
                // Here we create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL

                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
            }
            
            // When the array is complete, we add the annotations to the map.
            self.mapView.addAnnotations(annotations)
        }
        task.resume()
    }
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
                print("open url")
            }
        }
    }

    @IBAction func addLocation(sender: AnyObject) {
        if hasLocationBefore(){
            let alertController = UIAlertController(title: "iOScreator", message:
                "You Have Already Posted a Student Location. Would You Like to Overwrite Your Current Location?", preferredStyle: UIAlertControllerStyle.Alert)
            var overWriteAction = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.startAddLocationActivity()
            }
            alertController.addAction(overWriteAction)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            self.startAddLocationActivity()
        }
    }
    
    func hasLocationBefore() -> Bool{
        var flag:Bool = false
        for location in self.appDelegate.locations{
            if location.firstName == Constants.firstName && location.lastName == Constants.lastName && location.uniqueKey == Constants.uniqueKey{
                flag = true
            }
        }
        return flag
    }
    
    private func startAddLocationActivity() {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AddLocationViewController") as! AddLocationViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
}