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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusBarBackgroundView: UIView!
    
    
    let locationManager = CLLocationManager()
    var locations = [LocationData]()
    let defaultLocation = CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBarBackgroundView.alpha = 0.6
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
        startLoadingIndicator()
        OpenSourceService.shared.requestLocations { [unowned self] (status) in
            switch status {
            case .success(let locations):
                print("Success")
                for location in locations {
                    let dogGround = DogPlaceLocationAnnotation(data: location)
                    DispatchQueue.main.async {
                        self.mapView.addAnnotation(dogGround)
                    }
                }
                DispatchQueue.main.async {
                    self.stopLoadingIndicator()
                }
            default:
                DispatchQueue.main.async {
                    self.showErrorAlert(with: status)
                }
            }
        }
    }
    
    private func startLoadingIndicator() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    private func stopLoadingIndicator() {
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    private func showErrorAlert(with status: OpenSourceService.Status) {
        var title: String
        var message: String
        switch status {
        case .noConnection:
            title = "Нет интернета"
            message = "Проверьте соединение с интернетом"
        case .badConnection:
            title = "Плохое соединение"
            message = "Проверьте соединение с интернетом или попробуйте позже"
        case .fetchError, .unknownError:
            title = "Неизвестная ошибка"
            message = "Попробуйте позже"
        case .success:
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let repeatButton = UIAlertAction(title: "Повторить", style: .default) { [unowned self] (nil) in
            self.requestLocations()
        }
        alert.addAction(repeatButton)
        present(alert, animated: true, completion: nil)
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
    
    private func zoom(by delta: Double, duration: TimeInterval) {
        var region = mapView.region
        var span = region.span
        let newLongitude = delta * span.longitudeDelta
        let newLatitude = delta * span.latitudeDelta
        span.longitudeDelta = newLongitude > 125 ? 125 : newLongitude
        span.latitudeDelta = newLatitude > 125 ? 125 : newLatitude
        region.span = span
        
        MKMapView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: .curveEaseIn, animations: {
            self.mapView.setRegion(region, animated: true)
        }, completion: nil)
    }
    
    @IBAction func currentLocationTapped(_ sender: Any) {
        guard let currentLocation = locationManager.location?.coordinate else { return }
        centerMapOnLocation(location: currentLocation)
    }
    
    @IBAction func zoomInTapped(_ sender: Any) {
        zoom(by: 0.5, duration: 0.3)
    }
    
    @IBAction func zoomOutTapped(_ sender: Any) {
        zoom(by: 2, duration: 0.3)
    }
    
    @IBAction func infoTapped(_ sender: Any) {
        guard let url = URL(string: "https://data.mos.ru") else { return }
        UIApplication.shared.open(url)
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


