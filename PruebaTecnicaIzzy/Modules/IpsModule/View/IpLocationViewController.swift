//
//  IpLocationViewController.swift
//  PruebaTecnicaIzzy
//
//  Created by Carlos Salazar Vazquez on 24/02/26.
//

import UIKit
import MapKit

class IpLocationViewController: UIViewController , MKMapViewDelegate{
    @IBOutlet weak var mapMK: MKMapView!
    var name_city: String?
    var lat : String?
    var lon : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareMap()
        addPin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = name_city
    }
    
    func prepareMap(){
        mapMK.delegate = self
    }
    
    func addPin() {
        guard
            let lat = Double(lat ?? "0.0"),
            let lng = Double(lon ?? "0.0")
        else {
            print("Coordenadas inválidas")
            return
        }
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name_city
        annotation.subtitle = name_city
        
        mapMK.addAnnotation(annotation)
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        mapMK.setRegion(region, animated: true)
    }
}
