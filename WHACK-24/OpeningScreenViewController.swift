//
//  OpeningScreenViewController.swift
//  WHACK-24
//
//  Created by Claire Beyette on 10/1/16.
//  Copyright © 2016 Claire Beyette. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation
import CoreLocation


class OpeningSceenViewController: UIViewController, CLLocationManagerDelegate {
    
    

    
    //Instance Variables ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    
    var beaconManager = CLLocationManager()

    let wellesleyDict = beaconDict().wellesleyDict
    var beaconRegions: [CLBeaconRegion] = []

    @IBOutlet weak var colorLabel: UILabel!
    
    var closestBeacon: CLBeacon?
    
    @IBOutlet weak var locationLabel: UILabel!
    
    
    //viewDidLoad ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        beaconManager.delegate = self
        
        var uuid = NSUUID(UUIDString: "8366031D-4C67-49D2-952F-EFE8A137FA1B")
        var beaconRegion = CLBeaconRegion(proximityUUID: uuid!, identifier: "team24-2")
        beaconRegions.append(beaconRegion)

        uuid = NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
        beaconRegion = CLBeaconRegion(proximityUUID: uuid!, identifier: "estimote")
        beaconRegions.append(beaconRegion)

        beaconManager.requestAlwaysAuthorization()
        beaconManager.startMonitoringForRegion(beaconRegion)
        
        
         print ("view did load finished")

    }
    

    
    //viewDidAppear ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    override func viewDidAppear(animated: Bool) {
        for aBeaconRegion in beaconRegions {
            beaconManager.startRangingBeaconsInRegion(aBeaconRegion)
        }

        print("view did appear")
    }
    
    
    
    
    //locationManager ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon],
                       inRegion region: CLBeaconRegion) {
        
        if (!beacons.isEmpty){
        
        
        //determine closest beacon
        print(beacons[0])
            
        let distanceOk = (beacons[0].proximity == CLProximity.Near) || (beacons[0].accuracy < 3)
            
        print(beacons[0].proximity)
        print(beacons[0].accuracy)

        if ((closestBeacon == nil)) {
            closestBeacon = beacons[0]
        }
        if (((beacons[0].major != closestBeacon!.major)||(beacons[0].minor != closestBeacon!.minor))&&distanceOk){
            
            closestBeacon = beacons[0]
            readBeaconMessage(beacons[0])
            
            }
            
        }
        
//        
//        for beacon in beacons{
//    
//            print(" Floor:\(wellesleyDict[Int(beacon.major)]![Int(beacon.minor)]![0]), Location:\(wellesleyDict[Int(beacon.major)]![Int(beacon.minor)]![1])")
//        }
        }
    
    //readBeaconMessage ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    func readBeaconMessage (currentBeacon: CLBeacon){
        
        let majorNum = currentBeacon.major
        let minorNum = currentBeacon.minor
        
        let message = "You are at the \(wellesleyDict[Int(majorNum)]![Int(minorNum)]!["floor"]!) \(wellesleyDict[Int(majorNum)]![Int(minorNum)]!["location"]!)."
        
        
        print(message)
        
        locationLabel.text = message
        
        let locationType = wellesleyDict[Int(majorNum)]![Int(minorNum)]!["type"]!
        
        
        var color = UIColor()
        
        
        switch locationType {
            
        case ("stair"):
            color = UIColor(red:0.00, green:0.65, blue:0.49, alpha:1.0)
            
        case ("elevator"):
            color = UIColor(red:1.00, green:0.62, blue:0.00, alpha:1.0)
            
        default:
            color = UIColor.whiteColor()
        }
        
        colorLabel.backgroundColor = color
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        
        myUtterance = AVSpeechUtterance(string: message)
        myUtterance.rate = 0.3
        synth.speakUtterance(myUtterance)
        
    }
    
    
    
    
    
}

