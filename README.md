# Track Users Location Using CLLocationManager
***
A simple implementation of CLLocationManager. Works in the foreground and background. Displays location on MKMapView. Tapping location on map displays address using reverse geocoding.

##### Declare instance and set delegate.
```swift
let locationManager = CLLocationManager()
locationManager.delegate = self
```
##### Requests permission to track location.
```swift
locationManager.requestAlwaysAuthorization()
```
##### Conform to delegate.
```swift
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
```
##### Use reverse geocoding to display address and set annotation on map.
```swift
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
```

