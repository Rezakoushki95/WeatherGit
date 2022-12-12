//
//  LocationDetailViewController.swift
//  WeatherGit
//
//  Created by Reza Koushki on 11/12/2022.
//

import UIKit

class LocationDetailViewController: UIViewController {

	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var placeLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var summaryLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	
	var weaterLocation: WeatherLocation!
	var weatherLocations: [WeatherLocation] = []
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		if weaterLocation == nil {
			weaterLocation = WeatherLocation(name: "Current Location", latitude: 0.0, longitude: 0.0)
			weatherLocations.append(weaterLocation)
		}
		
		updateUI()
	}
	
	func updateUI() {
		dateLabel.text = ""
		placeLabel.text = weaterLocation.name
		temperatureLabel.text = "--º"
		summaryLabel.text = ""
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destination = segue.destination as! LocationListViewController
		destination.weatherLocations = weatherLocations
	}
	
	@IBAction func undwindFromLocationListViewController(segue: UIStoryboardSegue) {
		let source = segue.source as! LocationListViewController
		weatherLocations = source.weatherLocations
		weaterLocation = weatherLocations[source.selectedLocationIndex]
		updateUI()
	}
}
