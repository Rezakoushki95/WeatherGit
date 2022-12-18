//
//  WeatherDetail.swift
//  WeatherGit
//
//  Created by Reza Koushki on 12/12/2022.
//

import UIKit

private let dateFormatter: DateFormatter = {
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "EEEE"
	return dateFormatter
}()



struct DailyWeather {
	var dailyIcon: String
	var dailyWeekday: String
	var dailySummary: String
	var dailyHigh: Int
	var dailyLow: Int
}

class WeatherDetail: WeatherLocation {
	
	private struct Result: Codable {
		var timezone: String
		var current: Current
		var daily: [Daily]
	}
	
	private struct Current: Codable {
		var dt: TimeInterval
		var temp: Double
		var weather: [Weather]
	}
	
	private struct Weather: Codable {
		var description: String
		var icon: String
	}
	
	private struct Daily: Codable {
		var dt: TimeInterval
		var temp: Temp
		var weather: [Weather]
	}
	
	private struct Temp: Codable {
		var min: Double
		var max: Double
	}
	
	
	var timezone = ""
	var currentTime = 0.0
	var temperature = 0
	var summary = ""
	var dayIcon = ""
	var dailyWeatherData: [DailyWeather] = []
	
	func fileNameForIcon(icon: String) -> String {
		switch icon {
		case "01d", "01n":
			return "sun.max.fill"
		case "02d", "03d", "04d", "02n", "03n", "04n":
			return "cloud.fill"
		case "09d", "10d", "09n", "10n":
			return "cloud.rain.fill"
		case "11d", "11n":
			return "cloud.bolt"
		case "13d", "13n":
			return "cloud.snow.fill"
		case "50d", "50n":
			return "wind.snow"
		default:
			return "cloud.fill"
			
		}
	}
	
	
	func getData(completed: @escaping () -> ()) {
		let urlString = "https://api.openweathermap.org/data/3.0/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&exclude=minutely&appid=\(APIkey.openWeatherKey)"
		print("We are accessing the url \(urlString)")
		// Create a URL data type
		guard let url = URL(string: urlString) else {
			print("ERROR: Could not create a URL from \(urlString)")
			completed()
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
//				let json = try JSONSerialization.jsonObject(with: data!, options: [])
				let result = try JSONDecoder().decode(Result.self, from: data!)
				
				self.timezone = result.timezone
				self.currentTime = result.current.dt
				self.temperature = Int(result.current.temp)
				self.summary = result.current.weather[0].description
				self.dayIcon = result.current.weather[0].icon
				
				for index in 0..<result.daily.count {
					let weekdayDate = Date(timeIntervalSince1970: result.daily[index].dt)
					dateFormatter.timeZone = TimeZone(identifier: result.timezone)
					let dailyWeekDay = dateFormatter.string(from: weekdayDate)
					let dailyIcon = self.fileNameForIcon(icon: result.daily[index].weather[0].icon)
					let dailySummary = result.daily[index].weather[0].description
					let dailyHigh = Int(result.daily[index].temp.max.rounded())
					let dailyLow = Int(result.daily[index].temp.min.rounded())
					
					let dailyWeather = DailyWeather(dailyIcon: dailyIcon, dailyWeekday: dailyWeekDay, dailySummary: dailySummary, dailyHigh: dailyHigh, dailyLow: dailyLow)
					
					self.dailyWeatherData.append(dailyWeather)
					
					print("Day: \(dailyWeekDay), High: \(dailyHigh), Low: \(dailyLow)")

					
				}

			} catch {
				print("JSON ERROR: \(error.localizedDescription)")
			}
			completed()
		}
		task.resume()
	}
	
}
