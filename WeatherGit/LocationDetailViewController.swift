//
//  LocationDetailViewController.swift
//  WeatherGit
//
//  Created by Reza Koushki on 11/12/2022.
//

import UIKit
import CoreLocation

private let dateFormatter: DateFormatter = {
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "EEEE, MMM d"
	
	
	return dateFormatter
}()

class LocationDetailViewController: UIViewController {
	
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var placeLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var summaryLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var pageControl: UIPageControl!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var collectionView: UICollectionView!
	
	var weatherDetail: WeatherDetail!
	var locationIndex = 0
	var locationManager: CLLocationManager!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		clearUI()
		
		tableView.delegate = self
		tableView.dataSource = self
		collectionView.delegate = self
		collectionView.dataSource = self
		
		if locationIndex == 0 {
			getLocation()
		}
		
		updateUI()
	}

	func clearUI() {
		dateLabel.text = ""
		placeLabel.text = ""
		temperatureLabel.text = ""
		summaryLabel.text = ""
		imageView.image = UIImage()
	}
	
	func updateUI() {
		let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
		
		let weatherLocation = pageViewController.weatherLocations[locationIndex]
		weatherDetail = WeatherDetail(name: weatherLocation.name, latitude: weatherLocation.latitude, longitude: weatherLocation.longitude)
		
		pageControl.numberOfPages = pageViewController.weatherLocations.count
		pageControl.currentPage = locationIndex
	
		weatherDetail.getData {
			DispatchQueue.main.async {
				dateFormatter.timeZone = TimeZone(identifier: self.weatherDetail.timezone)
				let usableDate = Date(timeIntervalSince1970: self.weatherDetail.currentTime)
				self.dateLabel.text = dateFormatter.string(from: usableDate)
				self.placeLabel.text = self.weatherDetail.name
				self.temperatureLabel.text = "\(self.weatherDetail.temperature)º"
				self.summaryLabel.text = self.weatherDetail.summary
				self.imageView.image = UIImage(systemName: self.weatherDetail.fileNameForIcon(icon: self.weatherDetail.dayIcon))
				self.tableView.reloadData()
				self.collectionView.reloadData()
			}
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "LocationListSegue" {
			let destination = segue.destination as! LocationListViewController
			let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
			destination.weatherLocations = pageViewController.weatherLocations
		}
	}
	
	@IBAction func undwindFromLocationListViewController(segue: UIStoryboardSegue) {
		let source = segue.source as! LocationListViewController
		locationIndex = source.selectedLocationIndex
		
		let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
		
		pageViewController.weatherLocations = source.weatherLocations
		
		pageViewController.setViewControllers([pageViewController.createLocationDetailViewController(forPage: locationIndex)], direction: .forward, animated: false, completion: nil)
		
	}
	
	@IBAction func pageControlTapped(_ sender: UIPageControl) {
		let pageViewController = UIApplication.shared
			.windows.first!.rootViewController as! PageViewController
		
		pageViewController.setViewControllers([pageViewController.createLocationDetailViewController(forPage: sender.currentPage)], direction: sender.currentPage<locationIndex ? .reverse : .forward, animated: true, completion: nil)
		
	}
	
}

extension LocationDetailViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DailyTableViewCell
		cell.dailyWeather = weatherDetail.dailyWeatherData[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return weatherDetail.dailyWeatherData.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}
}

extension LocationDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return weatherDetail.hourlyWeatherData.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let hourlyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as! HourlyCollectionViewCell
		hourlyCell.hourlyWeather = weatherDetail.hourlyWeatherData[indexPath.row]
		return hourlyCell
	}
}

extension LocationDetailViewController: CLLocationManagerDelegate {
	
	
	
	func getLocation() {
		// Creating a CLLocationManager will automatically check authorizaiton
		locationManager = CLLocationManager()
		locationManager.delegate = self
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		print("Checking Authetication Status")
		handleAuthenticationStatus(status: status)
	}
	
	func handleAuthenticationStatus(status: CLAuthorizationStatus) {
		switch status {
		case .notDetermined:
			locationManager.requestWhenInUseAuthorization()
		case .restricted:
			self.oneButtonAlert(title: "Location service denied", message: "It may be that parental controls are restricting location use in this app.")
		case .denied:
			showAlertToPrivacySetting(title: "User has not authorized location services", message: "Select 'Settings' below to enable device settings and enable location services for this app.")
		case .authorizedAlways, .authorizedWhenInUse:
			locationManager.requestLocation()
		@unknown default:
			print("Developer Alert: Uknown case of status in handleAuthenticationStatus: \(status)")
		}
	}
	
	func showAlertToPrivacySetting(title: String, message: String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
			print("ERROR: Something went wrong with UIApplication.openSettingsURLString")
			return
		}
		
		let settingsAction = UIAlertAction(title: title, style: .default) { _ in
			UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		alertController.addAction(settingsAction)
		alertController.addAction(cancelAction)
		present(alertController, animated: true, completion: nil)
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print("Updating Location")
		let currentLocation = locations.last ?? CLLocation()
		print("Current Location is \(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)")
		let geoCoder = CLGeocoder()
		geoCoder.reverseGeocodeLocation(currentLocation) { placemarks, error in
			var locationName = ""
			if placemarks != nil {
				// Get the first placemark
				let placeMark = placemarks?.last
				// Assign placemark to locationName
				locationName = placeMark?.name ?? "Parts Unknown"
			}
			else {
				print("Error retrieving place. Error Code: \(error!.localizedDescription)")
				locationName = "Could not find location"
			}
			print("Locationanme: \(locationName)")
			
			// Update weatherLocations[0] with the current location so it can be used in updateUI.
			// getLocation only called when locationIndex == 0
			
			let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
			
			pageViewController.weatherLocations[self.locationIndex].latitude = currentLocation.coordinate.latitude
			pageViewController.weatherLocations[self.locationIndex].longitude = currentLocation.coordinate.longitude
			pageViewController.weatherLocations[self.locationIndex].name = locationName
			
			self.updateUI()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("ERROR: \(error.localizedDescription). Failed to get device location.")
		
	}
}
