//
//  HourlyCollectionViewCell.swift
//  WeatherGit
//
//  Created by Reza Koushki on 09/01/2023.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var hourLabel: UILabel!
	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var hourlyTemperature: UILabel!
	
	var hourlyWeather: HourlyWeather! {
		didSet {
			hourLabel.text = hourlyWeather.hour
			iconImageView.image = UIImage(systemName: hourlyWeather.hourlyIcon) // TODO: Add icons later
			hourlyTemperature.text = "\(hourlyWeather.hourlyTemperature)º"
		}
	}
	
}
