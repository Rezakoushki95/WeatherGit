//
//  WeatherLocation.swift
//  WeatherGit
//
//  Created by Reza Koushki on 09/12/2022.
//

import Foundation

class WeatherLocation: Codable {
	
	struct Result: Codable {
		var timezone: String
	}
	
	var name: String
	var latitude: Double
	var longitude: Double
	
	init(name: String, latitude: Double, longitude: Double) {
		self.name = name
		self.latitude = latitude
		self.longitude = longitude
	}
}
