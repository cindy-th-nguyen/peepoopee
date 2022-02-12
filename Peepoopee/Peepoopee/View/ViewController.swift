//
//  ViewController.swift
//  Peepoopee
//
//  Created by Cindy Nguyen on 10/02/2022.
//

import UIKit
import HomeKit
import Lottie

class ViewController: UIViewController {
    var homeManager: HMHomeManager!
    @IBOutlet weak var titleLabel: UILabel!
    private var animationView: AnimationView?
    
    var houseList: [HMHome] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        configureComponents()
        configureAnimation()
        let manager = HMHomeManager()
        manager.delegate = self
        if manager.homes.count == 0 {
            manager.addHome(withName: "Super Toilette") { home, err in
                guard let home = home else {
                    return
                }
                print(home)
            }
        } else {
            for home in manager.homes {
                houseList.append(home)
            }
            print("😼 \(houseList)")
        }
        self.homeManager = manager
    }
    
    func configureComponents() {
        self.view.setGradientBackground()
        self.titleLabel.text = "Peepoopee"
        self.titleLabel.textColor = .white
        self.titleLabel.font = .boldSystemFont(ofSize: 24)
    }
    
    func configureAnimation() {
        animationView = .init(name: "17081-pepe-poo-poo")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        view.addSubview(animationView!)
        animationView!.play()
    }
}

extension ViewController: HMHomeManagerDelegate {
    func homeManager(_ manager: HMHomeManager, didUpdate status: HMHomeManagerAuthorizationStatus){
        
    }
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        
    }
}
