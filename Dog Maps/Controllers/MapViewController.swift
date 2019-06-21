//
//  ViewController.swift
//  Dog Maps
//
//  Created by Dmitry Borodin on 17/06/2019.
//  Copyright © 2019 Dmitry Borodin. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var locations = [LocationData]()
    let defaultLocation = CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapView()
        setLocationManager()
        requestLocations()
    }
    
    fileprivate func setMapView() {
        mapView.delegate = self
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
    }
    
    fileprivate func setLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        if
            CLLocationManager.locationServicesEnabled(),
            let currentLocation = locationManager.location?.coordinate {
                centerMapOnLocation(location: currentLocation)
        } else {
            centerMapOnLocation(location: defaultLocation)
        }
    }
    
    fileprivate func requestLocations() {
        OpenSourceService.requestLocations { [unowned self] (locations, error) in
            if let error = error {
                print(error)
            }
            
            if let locations = locations {
                for location in locations {
                    
                    let dogGround = DogPlaceLocationAnnotation(data: location)
                    DispatchQueue.main.async {
                        self.mapView.addAnnotation(dogGround)
                    }
                }
            }
        }
    }
    
    private func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 3000
        let coordinateRegion = MKCoordinateRegion(center: location,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addDetailsVC(with locationAnnotation: DogPlaceLocationAnnotation) {
        let detailsVC = MapDetailsViewController()
        detailsVC.locationAnnotation = locationAnnotation
        detailsVC.view.frame = CGRect(x: 0, y: view.frame.maxY, width: view.frame.width, height: view.frame.height - detailsVC.minYPosition)
        addChild(detailsVC)
        view.addSubview(detailsVC.view)
        detailsVC.didMove(toParent: self)
    }
    
    private func zoom(by delta: Double) {
        var region = mapView.region
        var span = region.span
        span.longitudeDelta *= delta
        span.latitudeDelta *= delta
        region.span = span
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func currentLoactionTapped(_ sender: Any) {
        guard let currentLocation = locationManager.location?.coordinate else { return }
        centerMapOnLocation(location: currentLocation)
    }
    
    @IBAction func zoomInTapped(_ sender: Any) {
        zoom(by: 0.5)
    }
    
    @IBAction func zoomOutTapped(_ sender: Any) {
        zoom(by: 2)
    }
    
    @IBAction func infoTapped(_ sender: Any) {
        guard let url = URL(string: "https://data.mos.ru") else { return }
        UIApplication.shared.open(url)
//            , options: <#T##[UIApplication.OpenExternalURLOptionsKey : Any]#>, completionHandler: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
    }
    
}

//MARK: MapView
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? DogPlaceLocationAnnotation else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            view.markerTintColor = .customCyan
            view.glyphImage = #imageLiteral(resourceName: "Pin")
            view.glyphTintColor = .black
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if !children.isEmpty {
            for child in children {
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
            }
        }
        let locationAnnotation = view.annotation as! DogPlaceLocationAnnotation
        addDetailsVC(with: locationAnnotation)
    }
}

//MARK: Location Manager
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            guard let currentLocation = locationManager.location?.coordinate else { return }
            centerMapOnLocation(location: currentLocation)
        }
    }
}


