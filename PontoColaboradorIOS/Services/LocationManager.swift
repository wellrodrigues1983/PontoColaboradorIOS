//
//  LocationManager.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 16/12/25.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    
    @Published var location: CLLocation?
    static let shared = LocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func requestLocation(){
        manager.requestWhenInUseAuthorization()
    }
    
}
    
    extension LocationManager: CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .notDetermined:
                print("DEBUG: Solicitar permissão de localização")
            case .restricted:
                print("DEBUG: Acesso à localização restrito")
            case .denied:
                print("DEBUG: Permissão de localização negada")
            case .authorizedAlways:
                print("DEBUG: Permissão de localização concedida (sempre)")
            case .authorizedWhenInUse:
                print("DEBUG: Permissão de localização concedida (enquanto em uso)")
            default:
                break
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            self.location = location
            
        }
    }

