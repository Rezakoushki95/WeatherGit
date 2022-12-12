//
//  WeatherLocation.swift
//  WeatherGit
//
//  Created by Reza Koushki on 09/12/2022.
//

import Foundation

class WeatherLocation: Codable {
	var name: String
	var latitude: Double
	var longitude: Double
	
	init(name: String, latitude: Double, longitude: Double) {
		self.name = name
		self.latitude = latitude
		self.longitude = longitude
	}
	
	func getData() {
		let urlString = "https://api.openweathermap.org/data/3.0/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&exclude=minutely&appid=\(APIkey.openWeatherKey)"
		print("We are accessing the url \(urlString)")
		// Create a URL data type
		guard let url = URL(string: urlString) else {
			print("ERROR: Could not create a URL from \(urlString)")
			return
		}
		
		// Create Session
		let session = URLSession.shared
		
		// get data with .dataTask method
		
		let task = session.dataTask(with: url) { data, response, error in
			if let error = error {
				print("Error: \(error.localizedDescription)")
			}
			
			// note: There are some additional things that could go wrong when using URLSession, but we shouædn't experience them, so we'll ignore testing for these for now...

			// deal with the data
			do {
				let json = try JSONSerialization.jsonObject(with: data!, options: [])
				print("json: \(json)")
			} catch {
				print("JSON ERROR: \(error.localizedDescription)")
			}
		}
		task.resume()
	}
}
