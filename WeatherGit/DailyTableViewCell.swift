//
//  DailyTableViewCell.swift
//  WeatherGit
//
//  Created by Reza Koushki on 02/01/2023.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
	
	@IBOutlet weak var dailyImageView: UIImageView!
	@IBOutlet weak var dailyWeekdayLabel: UILabel!
	@IBOutlet weak var dailyHighLabel: UILabel!
	@IBOutlet weak var dailySummaryView: UITextView!
	@IBOutlet weak var dailyLowLabel: UILabel!
	
	var dailyWeather: DailyWeather! {
		didSet {
			dailyImageView.image = UIImage(systemName: dailyWeather.dailyIcon)
			dailyWeekdayLabel.text = dailyWeather.dailyWeekday
			dailyHighLabel.text = "\(dailyWeather.dailyHigh)º"
			dailySummaryView.text = dailyWeather.dailySummary
			dailyLowLabel.text = "\(dailyWeather.dailyLow)º"
		}
	}
	
}
