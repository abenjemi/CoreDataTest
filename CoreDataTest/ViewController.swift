//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Amine Ben Jemia on 7/3/22.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tournamentsTable: UITableView!
    var tournaments: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        configureTableView()
    }
    
    func fetchData() {
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
          
        do {
            self.tournaments = try managedContext.fetch(Tournament.fetchRequest())
            
            DispatchQueue.main.async {
                self.tournamentsTable.reloadData()
            }
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
        // create new managed object
        guard let tournamentEntity = NSEntityDescription.entity(forEntityName: "Tournament", in: managedContext) else { return }
        let tournament = NSManagedObject(entity: tournamentEntity, insertInto: managedContext)
        
        // set the managed object
        tournament.setValue(country, forKeyPath: "country")
        tournament.setValue(city, forKeyPath: "city")
        
        // save managed object into the persistent container
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("could not save data. \(error), \(error.userInfo)")
        }
        
        // re-fetch data
        fetchData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit Tournament", message: "", preferredStyle: .alert)
        alert.addTextField()
        alert.addTextField()
        alert.textFields![0].text = tournaments[indexPath.row].value(forKeyPath: "country") as? String
        alert.textFields![1].text = tournaments[indexPath.row].value(forKeyPath: "city") as? String
        let saveButton = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let country = alert.textFields?[0].text, let city = alert.textFields?[1].text else {
                return
            }
            let tournamentToEdit = tournaments[indexPath.row]
            tournamentToEdit.setValue(country, forKey: "country")
            tournamentToEdit.setValue(city, forKey: "city")
            
            // save data
            do {
                try managedContext.save()
            }
            catch {
                print("error editing tournament")
            }
            
            // re-fetch data
            fetchData()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(cancelButton)
        alert.addAction(saveButton)
        present(alert, animated: true)
        print("cell tapped")
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            // object to delete
            let tournamentToDelete = tournaments[indexPath.row]
            
            // delete object
            managedContext.delete(tournamentToDelete)
//            tournaments.remove(at: indexPath.row)
            // save data
            do {
                try managedContext.save()
            }
            catch {
                print("error in delete")
            }
            
            // fetch data
            tableView.deleteRows(at: [indexPath], with: .right)
            fetchData()
            
            tableView.endUpdates()
        }
    }
    
}

