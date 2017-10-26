//
//  MapViewController.swift
//  PostCard
//
//  Created by Matthew Russo on 6/7/17.
//  Copyright © 2017 Olya Danylova. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {

    let APPLICATION_ID = "63E6BEB9-AC2E-0B24-FF2C-F948484DAB00"
    let API_KEY = "2C160E48-1E10-FDA0-FF44-EB006605BF00"
    let SERVER_URL = "https://api.backendless.com"
    let backendless = Backendless.sharedInstance()!
    let imagePicker = UIImagePickerController()
    var showReceivedCards : Bool = true
    var pinTable = "ReceivedPostCards"
    var locationManager:CLLocationManager!
    var postcardTableCount = -1

    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var bottomBar: UIToolbar!

    @IBOutlet weak var sendOrReceived: CustomSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backendless.hostURL = SERVER_URL
        backendless.initApp(APPLICATION_ID, apiKey: API_KEY)
        
        self.bottomBar.clipsToBounds = true
        mapView.delegate = self
        imagePicker.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self

        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        checkSendOrReceive()
        
        getLengthOfTable(tableName: "SentPostCards")

        let sendOrReceivedTapped = UITapGestureRecognizer(target: self, action: #selector(self.sendOrReceiveTapped(sender:)))
        
        sendOrReceived.addGestureRecognizer(sendOrReceivedTapped)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendOrReceiveTapped(sender: UITapGestureRecognizer) {
        checkSendOrReceive()
    }
    
    func checkSendOrReceive() {
        if(sendOrReceived.selectedIndex == 0) {
            showReceivedCards = true
            pinTable = "ReceivedPostCards"
            retrievePins()
            
        } else {
            showReceivedCards = false
            pinTable = "SentPostCards"
            retrievePins()
        }
    }
    
    // MARK: Get pins
    func retrievePins() {
        
        // remove prexisting annotations
        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)
        
        // retrieves all MessageTable
        let dataStore = self.backendless.data.ofTable(pinTable)
        dataStore?.find({
            (array) -> () in

            // loop through all objects
            for pinObject in array! as [AnyObject] {
                let pinLatitude = pinObject["Latitude"]! as! CLLocationDegrees
                let pinLongitude = pinObject["Longitude"]! as! CLLocationDegrees
                let postCardId = pinObject["CardID"]! as! String

                let pinCoord = CLLocationCoordinate2DMake(pinLatitude , pinLongitude)

                let annotation = CustomAnnotation(pinCoord: pinCoord, id: postCardId)

                self.mapView.addAnnotation(annotation)

                
            }

        },
                        error: {
                            (fault : Fault?) -> () in
                            print("Server reported an error: \(String(describing: fault))")
        })
        
    }
    

    // MARK: - Map delegate functions

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation
        {
            return nil
        }
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }else{
            annotationView?.annotation = annotation
        }
        
        let img = UIImage(named: "pin")
        annotationView?.image = img
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView)
    {
        if view.annotation is MKUserLocation
        {
            return
        }
        
        let width = mapView.bounds.size.width
        let height = mapView.bounds.size.height

        let screenView = UIView(frame: CGRect(x:0, y:0, width: width, height: height))

        let annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        annotationView?.canShowCallout = false
        screenView.center = CGPoint(x: 0.0 + 5.0, y: 0.0)
        let ann = view.annotation as! CustomAnnotation
        let id = ann.id
        findPostCardById(postCardId: id)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)

    }

    func showPostCard(postCardData: AnyObject) {
        let width = mapView.bounds.size.width
        let height = mapView.bounds.size.height
        let id = postCardData["CardID"] as! String
        let city = postCardData["City"] as! String
        let country = postCardData["Country"] as! String
        let text = postCardData["Text"] as! String
        let dateString = postCardData["DateString"] as! String
        var id2: String = id
        id2 = id2.replacingOccurrences(of: "\"", with: "")
        var imageURL = "https://api.backendless.com/\(APPLICATION_ID)/\(API_KEY)/files/media/\(id2).JPG" as String
        let url = NSURL(string: imageURL)
        let data = NSData(contentsOf: url! as URL)
        let image = UIImage(data: data! as Data)!
        let pc = PostCard(frame: CGRect(x: 0, y: height, width: width, height: height), id: id, country: country, city: city, text: text, dateString: dateString, image: image)
        self.view.addSubview(pc)

        UIView.animate(withDuration: 0.2, delay: 0.05, options: [], animations: {
            let top = height * -1
            
            pc.transform = CGAffineTransform(translationX: 0, y: top)
        }, completion: nil)
        
    }
    
    func findPostCardById(postCardId: String){
        var error: Fault?
        let dataStore = self.backendless.data.ofTable(pinTable)
        
        dataStore?.find({
            (array) -> () in

            let index = array?.index(where: { (item) -> Bool in
                let postCard = (item as AnyObject)
                let bool = postCard["CardID"] as! String == postCardId
                return bool
            })

            let data = array?[index!] as AnyObject
            self.showPostCard(postCardData: data)
            },
            error: {
                (fault : Fault?) -> () in
                print("Server reported an error: \(String(describing: fault))")
        })
        
    }
    
    
    @IBAction func openCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            let screenSize = UIScreen.main.bounds.size
            let cameraAspectRatio = CGFloat(4.0 / 3.0)
            let cameraImageHeight = screenSize.width * cameraAspectRatio
            let scale = screenSize.height / cameraImageHeight
            imagePicker.cameraViewTransform = CGAffineTransform(translationX: 0, y: (screenSize.height - cameraImageHeight)/2)
            imagePicker.cameraViewTransform = imagePicker.cameraViewTransform.scaledBy(x: scale, y: scale)

            present(imagePicker,animated: true,completion: nil)
        }
        else
        {
            let alert:UIAlertController = UIAlertController(title: "Camera Unavailable", message: "Unable to find a camera on this device", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        createPostCardFromCamera(imageData: chosenImage)
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func createPostCardFromCamera(imageData: UIImage) {
        getLengthOfTable(tableName: "SentPostCards")
        let idNum = postcardTableCount + 1
        let id = "sentPostCard\(idNum)"
        let date = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.short
        dateformatter.timeStyle = DateFormatter.Style.none
        let dateString = dateformatter.string(from: date as Date)

        let width = mapView.bounds.size.width
        let height = mapView.bounds.size.height
        let frame = CGRect(x: 0, y: 0, width: width, height: height)

        let loc = locationManager.location!.coordinate
        let location = locationManager.location!

        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            let country: String
            let city: String

            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            country = placeMark.addressDictionary!["Country"] as! String
            city = placeMark.addressDictionary!["City"] as! String

            
            let postCard = CreatePostCard(frame: frame, id: id, country: country, city: city, dateString: dateString, image: imageData, latitude: loc.latitude, longitude: loc.longitude)
            
            self.view.addSubview(postCard)

        })

    }


    func getLengthOfTable(tableName: String) {
        // retrieves all of table
        let dataStore = self.backendless.data.ofTable(tableName)
        
        dataStore?.find({
            (array) -> () in
            
            
            let data = array!.count
            self.postcardTableCount = data
        },
                        error: {
                            (fault : Fault?) -> () in
                            print("Server reported an error: \(String(describing: fault))")
        })

    }

}
