//
//  LocationPickerViewController.swift
//  Telesapp
//
//  Created by Trung on 20/04/2023.
//

import UIKit
import CoreLocation
import MapKit


class LocationPickerViewController: UIViewController {
    
    public var completion: ((CLLocationCoordinate2D) -> Void)?
    private var coordinates: CLLocationCoordinate2D?
    private let map: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pick Location"
        view.backgroundColor = .white
        map.isUserInteractionEnabled = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(sendButtonTapped))
        view.addSubview(map)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapMap(_ :)))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        map.addGestureRecognizer(gesture)
    }
    
    @objc func sendButtonTapped(){
        guard let coordinates = coordinates else {
            return
        }
        completion?(coordinates)
    }
    @objc func didTapMap(_ gesture: UITapGestureRecognizer){
        let locationInView = gesture.location(in: map)
        let coordinates = map.convert(locationInView, toCoordinateFrom: map)
        self.coordinates = coordinates
        
        
        /// Drop a pin on that location
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        map.addAnnotation(pin)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        map.frame = view.bounds
    }
}
