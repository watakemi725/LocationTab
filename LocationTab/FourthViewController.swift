//
//  FourthViewController.swift
//  LocationTab
//
//  Created by Takemi Watanuki on 2015/12/10.
//  Copyright © 2015年 Takemi Watanuki. All rights reserved.
//

import UIKit
import CoreLocation
import HealthKit
import CoreData


class FourthViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    
    //    var run: Run!
    
    
    var seconds = 0.0
    var distance = 0.0
    
    
    @IBOutlet var timeLabel : UILabel!
    @IBOutlet var distanceLabel : UILabel!
    @IBOutlet var paceLabel : UILabel!
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        
        if #available(iOS 9.0, *) {
            _locationManager.allowsBackgroundLocationUpdates = true
        }
        
        _locationManager.distanceFilter = 1.0
//        GPSの精度がdistanceFilter 1.0なら1m更新するごとに呼ばれるようになっている。
        
        return _locationManager
    }()
    
    lazy var locations = [CLLocation]()
    lazy var timer = NSTimer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        locationManager.requestAlwaysAuthorization()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    

    func eachSecond(timer: NSTimer) {
        seconds++
        let secondsQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: seconds)
        timeLabel.text = "Time: " + secondsQuantity.description
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: distance)
        distanceLabel.text = "Distance: " + distanceQuantity.description
        
        let paceUnit = HKUnit.secondUnit().unitDividedByUnit(HKUnit.meterUnit())
        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: seconds / distance)
        paceLabel.text = "Pace: " + paceQuantity.description
    }
    
    func startLocationUpdates() {
        // Here, the location manager will be lazily instantiated
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func start(){
        seconds = 0.0
        distance = 0.0
        locations.removeAll(keepCapacity: false)
        timer = NSTimer.scheduledTimerWithTimeInterval(1,
            target: self,
            selector: "eachSecond:",
            userInfo: nil,
            repeats: true)
        startLocationUpdates()
    }
    @IBAction func stop(){
        saveRun()
    }
    
    
    //位置情報をとっていくよう
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        for location in locations as! [CLLocation] {
        for location in locations {
            if location.horizontalAccuracy < 20 {
                //update distance
                if self.locations.count > 0 {
                    distance += location.distanceFromLocation(self.locations.last!)
                }
                
                //save location
                self.locations.append(location)
            }
        }
    }
    
    //走ったを保存しよう
    func saveRun() {
        // 1
        //        let savedRun = NSEntityDescription.insertNewObjectForEntityForName("Run",
        //            inManagedObjectContext: managedObjectContext!) as Run!
        //        savedRun.distance = distance
        //        savedRun.duration = seconds
        //        savedRun.timestamp = NSDate()
        //
        //        // 2
        //        var savedLocations = [Location]()
        //        for location in locations {
        //            let savedLocation = NSEntityDescription.insertNewObjectForEntityForName("Location",
        //                inManagedObjectContext: managedObjectContext!) as Location!
        //            savedLocation.timestamp = location.timestamp
        //            savedLocation.latitude = location.coordinate.latitude
        //            savedLocation.longitude = location.coordinate.longitude
        //            savedLocations.append(savedLocation)
        //        }
        //
        //        savedRun.locations = NSOrderedSet(array: savedLocations)
        //        run = savedRun
        //
        //        // 3
        //        var error: NSError?
        //        let success = managedObjectContext!.save(error)
        //        if !success {
        //            print("Could not save the run!")
        //        }
    }
    

    
    
    // MARK: - CLLocationManagerDelegate
    
    
}
extension FourthViewController: CLLocationManagerDelegate {
}
