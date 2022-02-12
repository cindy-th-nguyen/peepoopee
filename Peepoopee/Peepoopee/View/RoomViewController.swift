//
//  RoomViewController.swift
//  Peepoopee
//
//  Created by Cindy Nguyen on 11/02/2022.
//

import UIKit
import HomeKit

class RoomViewController: UIViewController {
    var home: HMHome!
    var room: HMRoom!
    @IBOutlet var accessoryTableView: UITableView!
    
    class func newInstance(room: HMRoom, home: HMHome) -> RoomViewController {
        let rvc = RoomViewController()
        rvc.room = room
        rvc.home = home
        return rvc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addAccessoryButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddAccessory))
        self.navigationItem.rightBarButtonItem = addAccessoryButton
        self.accessoryTableView.delegate =  self
        self.accessoryTableView.dataSource = self
    }
    
    @objc func handleAddAccessory() {
        let abvc = AccessoryBrowserViewController.newInstance(delegate: self)
        self.present(abvc, animated: true)
    }
}

extension RoomViewController: AccessoryBrowserViewControllerDelegate {
    func accessoryBrowserViewController(_ abvc: AccessoryBrowserViewController, didSelectNew accessory: HMAccessory) {
        self.home.addAccessory(accessory) { err in
            self.home.assignAccessory(accessory, to: self.room) { err in
                abvc.dismiss(animated: true) {
                    print(accessory)
                }
            }
        }
    }
}

extension RoomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let accessory = self.room.accessories[indexPath.row]
        let accessoryViewController = AccessoryViewController.newInstance(room: self.room, home: self.home, accessory: accessory)
        self.navigationController?.pushViewController(accessoryViewController, animated: true)
    }
}

extension RoomViewController: UITableViewDataSource {
    
    static let accessoryCellId =  "acid"

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RoomViewController.accessoryCellId) ?? UITableViewCell(style: .default, reuseIdentifier: RoomViewController.accessoryCellId)
        let accessory = self.room.accessories[indexPath.row]
        cell.textLabel?.text = "\(accessory.name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.room.accessories.count
    }
}
