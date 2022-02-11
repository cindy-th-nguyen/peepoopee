//
//  ViewController.swift
//  Peepoopee
//
//  Created by Cindy Nguyen on 10/02/2022.
//

import UIKit
import HomeKit

class ViewController: UIViewController {
    var homeManager: HMHomeManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let manager = HMHomeManager()
        manager.delegate = self
        if manager.homes.count == 0 {
            manager.addHome(withName: "My Home") { home, err in
                guard let home = home else {
                    return
                }
                print(home)
            }
        }
        self.homeManager = manager
    }
}

extension ViewController: HMHomeManagerDelegate {
    func homeManager(_ manager: HMHomeManager, didUpdate status: HMHomeManagerAuthorizationStatus){
        print("here")
    }
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        print("here 2")
    }
    
    
}
