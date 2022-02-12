//
//  HomeViewController.swift
//  Peepoopee
//
//  Created by Cindy Nguyen on 11/02/2022.
//

import UIKit
import HomeKit

class HomeViewController: UIViewController {
    var home: HMHome!
    @IBOutlet var roomsTableView: UITableView!
    
    class func newInstance(home: HMHome) -> HomeViewController {
        let hvc = HomeViewController()
        hvc.home = home
        return hvc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.roomsTableView.delegate = self
        self.roomsTableView.dataSource = self
        let addRoomButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddRoom))
        self.navigationItem.rightBarButtonItem = addRoomButton
    }
    
    @objc func handleAddRoom() {
        let alertController = UIAlertController(title: "Création de pièce", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Nom de la pièce"
        }
        alertController.addAction(UIAlertAction(title: "Valider", style: .default, handler: { action in
            guard let roomName = alertController.textFields![0].text else {
                return
            }
            self.home.addRoom(withName: roomName) { room, err in
                self.roomsTableView.reloadData()
            }
        }))
        alertController.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = self.home.rooms[indexPath.row]
        let roomViewController = RoomViewController.newInstance(room: room, home: self.home)
        self.navigationController?.pushViewController(roomViewController, animated: true)
    }
    
}

extension HomeViewController: UITableViewDataSource {
    static let roomCellId = "rcid"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewController.roomCellId) ?? UITableViewCell(style: .default, reuseIdentifier: HomeViewController.roomCellId)
        let room = self.home.rooms[indexPath.row]
        cell.textLabel?.text = "\(room.name): \(room.accessories.count) accessoire(s)"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.home.rooms.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let room = self.home.rooms[indexPath.row]
        self.home.removeRoom(room) { err in
            guard err == nil else {
                return
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
