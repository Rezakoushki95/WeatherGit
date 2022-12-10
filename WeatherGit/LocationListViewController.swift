//
//  LocationListViewController.swift
//  WeatherGit
//
//  Created by Reza Koushki on 09/12/2022.
//

import UIKit

class LocationListViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var editBarButton: UIBarButtonItem!
	@IBOutlet weak var addBarButton: UIBarButtonItem!
	
	var weatherLocations: [WeatherLocation] = [
		WeatherLocation(name: "Aarhus, Denmark", latitude: 0, longitude: 0),
		WeatherLocation(name: "Odense, Denmark", latitude: 0, longitude: 0),
		WeatherLocation(name: "København, Denmark", latitude: 0, longitude: 0)
	]

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	@IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
		if tableView.isEditing {
			tableView.setEditing(false, animated: true)
			sender.title = "Edit"
			addBarButton.isEnabled = true
		} else {
			tableView.setEditing(true, animated: true)
			sender.title = "Done"
			addBarButton.isEnabled = false
		}
	}
	
	@IBAction func addLocationPressed(_ sender: UIBarButtonItem) {
		
	}
	
}

extension LocationListViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		let itemToMove = weatherLocations[sourceIndexPath.row]
		weatherLocations.remove(at: sourceIndexPath.row)
		weatherLocations.insert(itemToMove, at: destinationIndexPath.row)
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			weatherLocations.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return weatherLocations.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "weatherLocationCell", for: indexPath)
		cell.textLabel?.text = weatherLocations[indexPath.row].name
		return cell
	}
	
	
}
