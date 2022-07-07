//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Amine Ben Jemia on 7/3/22.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tournamentsTable: UITableView!
    var tournaments: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(entity: "Tournament")
        configureTableView()
    }
    
    func fetchData(entity: String) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return
          }
          
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
          
        do {
          tournaments = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    @IBAction func addTournament(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Tournament", message: "", preferredStyle: .alert)
        alert.addTextField()
        alert.addTextField()
        alert.textFields?[0].placeholder = "country"
        alert.textFields?[1].placeholder = "city"
        let saveButton = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let country = alert.textFields?[0].text, let city = alert.textFields?[1].text else {
                return
            }
            self.saveTournament(country: country, city: city)
            self.tournamentsTable.reloadData()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(cancelButton)
        alert.addAction(saveButton)
        present(alert, animated: true)
    }
    
    func saveTournament(country: String, city: String) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return
          }
          
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // create new managed object
        guard let tournamentEntity = NSEntityDescription.entity(forEntityName: "Tournament", in: managedContext) else { return }
        let tournament = NSManagedObject(entity: tournamentEntity, insertInto: managedContext)
        
        // set the managed object
        tournament.setValue(country, forKeyPath: "country")
        tournament.setValue(city, forKeyPath: "city")
        
        // save managed object into the persistent container
        do {
            try managedContext.save()
            tournaments.append(tournament)
        } catch let error as NSError {
            print("could not save data. \(error), \(error.userInfo)")
        }
    }
    
    func configureTableView() {
        tournamentsTable.delegate = self
        tournamentsTable.dataSource = self
//        tournamentsTable.register(UITableViewCell.self, forCellReuseIdentifier: TournamentTableCell.identifier)
        tournamentsTable.register(UINib(nibName: "TournamentTableCell", bundle: nil), forCellReuseIdentifier: TournamentTableCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tournaments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TournamentTableCell.identifier) as? TournamentTableCell else {
            return UITableViewCell()
        }
        cell.setupCell()
        let tournament = tournaments[indexPath.row]
        cell.countryLabel.text = tournament.value(forKeyPath: "country") as? String
        cell.cityLabel.text = tournament.value(forKeyPath: "city") as? String
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let alert = UIAlertController(title: "Edit Tournament", message: "", preferredStyle: .alert)
//        alert.addTextField()
//        alert.addTextField()
//        alert.textFields?[0].text = tournaments[indexPath.row].value(forKeyPath: "country") as! String
//        alert.textFields?[1].text = tournaments[indexPath.row].value(forKeyPath: "city") as! String
//        let saveButton = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
//            guard let country = alert.textFields?[0].text, let city = alert.textFields?[1].text else {
//                return
//            }
//            tournaments[indexPath.row].country = country
//            tournaments[indexPath.row].city = city
//            tournamentsTable.reloadData()
//        }
//        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
//        alert.addAction(cancelButton)
//        alert.addAction(saveButton)
//        present(alert, animated: true)
//        print("cell tapped")
//    }
//    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            tableView.beginUpdates()
//            tournaments.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .right)
//            tableView.endUpdates()
//        }
//    }
    
}

