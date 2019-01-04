import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController {
	
	@IBOutlet weak var map: MKMapView!
	private let locationManager = CLLocationManager()

	// MARK: -

	override func viewDidLoad() {
		super.viewDidLoad()
		locationManager.delegate = self
	}
	
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		locationManager.requestAlwaysAuthorization()
	}

	private func display(location: CLLocation) {
		reverseGeocode(location: location)
		zoom(location)
	}
	
	private func reverseGeocode(location: CLLocation) {
		CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [unowned self] placemark, error in
			guard let p = placemark?.first else { self.setAnnotation(subtitle: nil, location: location); return }
			let address = "\(p.subThoroughfare ?? "") \(p.thoroughfare ?? "Unknown"), \(p.locality ?? ""), \(p.administrativeArea ?? "") \(p.postalCode ?? ""), \(p.country ?? "")."
			self.setAnnotation(subtitle: address, location: location)
		})
	}
	
	
	private func setAnnotation(subtitle: String?, location: CLLocation) {
		let annotation = MKPointAnnotation()
		annotation.coordinate = location.coordinate
		annotation.title = "Current Location"
		annotation.subtitle = subtitle
		map.addAnnotation(annotation)
	}
	

	private func zoom(_ location: CLLocation) {
		let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)
		let region = MKCoordinateRegion(center: location.coordinate, span: span)
		map.setRegion(region, animated: true)
	}

}

// MARK: -

extension ViewController: CLLocationManagerDelegate {
	
	/// Receives user response to monitor location
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		guard status == .authorizedAlways || status == .authorizedWhenInUse else { return }
		locationManager.startUpdatingLocation()
		locationManager.allowsBackgroundLocationUpdates = status == .authorizedAlways ? true : false
	}
	
	/// Receives location information
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		display(location: location)
	}
	
}

