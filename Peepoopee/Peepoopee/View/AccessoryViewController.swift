//
//  AccessoryViewController.swift
//  Peepoopee
//
//  Created by Cindy Nguyen on 11/02/2022.
//

import UIKit
import HomeKit

class AccessoryViewController: UIViewController {

    var home: HMHome!
    var room: HMRoom!
    @IBOutlet var accessoryPowerStateSwitch: UISwitch!
    var accessory: HMAccessory!

    class func newInstance(room: HMRoom, home: HMHome, accessory: HMAccessory) -> AccessoryViewController {
        let avc = AccessoryViewController()
        avc.room = room
        avc.home = home
        avc.accessory = accessory
        return avc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let characteristic = self.getPowerStateCharacteristic()
        let isWritable = characteristic?.properties.firstIndex(where: { props in
            return props == HMCharacteristicPropertyWritable
        }) ?? -1
        self.accessoryPowerStateSwitch.isEnabled = isWritable != -1
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            self.updatePowerState()
        }
    }
    
    @IBAction func handleUpdatePowerState(_ sender: UISwitch) {
        let val = sender.isOn
        let characteristic = self.getPowerStateCharacteristic()
        characteristic?.writeValue(val, completionHandler: { err in
            guard err == nil else {
                return
            }
            sender.isOn = val
        })
    }
    
    func getPowerStateCharacteristic() -> HMCharacteristic? {
        for service in self.accessory.services {
            for characteristic in service.characteristics {
                if characteristic.characteristicType == HMCharacteristicTypePowerState {
                    return characteristic
                }
            }
        }
        return nil
    }
    
    func updatePowerState() {
        guard let characteristic = self.getPowerStateCharacteristic() else {
            return
        }
        // On est dans le service prise de courant et on peut acceder à l'etat de l'alimentation
        characteristic.readValue { err in
            guard err == nil else {
                self.accessoryPowerStateSwitch.isOn = false
                return
            }
            guard let isOn = characteristic.value as? Int else {
                self.accessoryPowerStateSwitch.isOn = false
                return
            }
            self.accessoryPowerStateSwitch.isOn = isOn == 1
        }
    }
}
