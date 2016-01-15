//
//  ThirdViewController.swift
//  LocationTab
//
//  Created by Takemi Watanuki on 2015/11/26.
//  Copyright © 2015年 Takemi Watanuki. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation


class ThirdViewController: UIViewController,CLLocationManagerDelegate {
    
    var pedometer: AnyObject!
    
    @IBOutlet var label: UITextView!
    
    @IBOutlet var magneticX: UILabel!
    @IBOutlet var magneticY: UILabel!
    @IBOutlet var magneticZ: UILabel!
    @IBOutlet var magneticAverage: UILabel!
    
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var kphLabel: UILabel!
    
    let motionManager:  CMMotionManager = CMMotionManager()

    var lm: CLLocationManager! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        lm = CLLocationManager()
        lm.delegate = self
        //位置情報取得の可否。バックグラウンドで実行中の場合にもアプリが位置情報を利用することを許可する
        lm.requestAlwaysAuthorization()
        //位置情報の精度
        lm.desiredAccuracy = kCLLocationAccuracyBest
        //位置情報取得間隔(m)
        lm.distanceFilter = 1.0
        
        
        
        motionManager.deviceMotionUpdateInterval = 1 // sec.

        // BEGIN magnets
        motionManager.startMagnetometerUpdatesToQueue(NSOperationQueue.mainQueue()) {
            (magnetometerData, error) -> Void in
            
            let magneticField = magnetometerData!.magneticField
            
            let xValue = String(format:"%.2f", magneticField.x)
            let yValue = String(format:"%.2f", magneticField.y)
            let zValue = String(format:"%.2f", magneticField.z)
            
//            let average = (magneticField.x + magneticField.y + magneticField.z) / 3.0
            
//            let averageValue = String(format:"%.2f", average)
            
            self.magneticX.text = xValue
            self.magneticY.text = yValue
            self.magneticZ.text = zValue
//            self.magneticAverage.text = averageValue
            
            
            //平均3軸磁気量を求めている
            let magneticNum = (magneticField.x * magneticField.x)+(magneticField.y * magneticField.y)+(magneticField.z * magneticField.z)
           self.magneticAverage.text = String(sqrt(magneticNum))
        }
        
//        func safeSqrt(x: Double) -> Double? {
//            return x < 0.0 ? nil : sqrt(x)
//        }
        
        // Do any additional setup after loading the view.
        
        // メンバー変数でないと動作しないので注意
        //        if #available(iOS 8.0, *) {
        
        
        if #available(iOS 8.0, *) {
            pedometer = CMPedometer()
        } else {
            // Fallback on earlier versions
        }
        
        
        //        } else {
        //            // Fallback on earlier versions
        //        }
        
        
        if #available(iOS 8.0, *) {
            if CMPedometer.isStepCountingAvailable() {
                // 計測開始
                pedometer.startPedometerUpdatesFromDate(NSDate(), withHandler: {
                    [unowned self] data, error in
                    dispatch_async(dispatch_get_main_queue(), {
                        print("update")
                        if error != nil {
                            // エラー
                            self.label.text = "エラー : \(error)"
                            print("エラー : \(error)")
                        } else {
                            let lengthFormatter = NSLengthFormatter()
                            // 歩数
                            let steps = data!.numberOfSteps
                            // 距離
                            let distance = data!.distance!.doubleValue
                            // 速さ
                            let time = data!.endDate.timeIntervalSinceDate(data!.startDate)
                            let speed = distance / time
                            // 上った回数
                            let floorsAscended = data!.floorsAscended
                            // 降りた回数
                            let floorsDescended = data!.floorsDescended
                            // 結果をラベルに出力
                            self.label.text = "Steps: \(steps)"
                                + "\nDistance : \(lengthFormatter.stringFromMeters(distance))"
                                + "\nSpeed : \(lengthFormatter.stringFromMeters(speed)) / s"
                                + "\nfloorsAscended : \(floorsAscended)"
                                + "\nfloorsDescended : \(floorsDescended)"
                            
                            //数値を排出する
                            
                            
                        }
                    })
                    })
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    
    /** 位置情報取得成功時 */
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        
        
        // Speedを更新
//        self.speedLabel.text =[NSString stringWithFormat:@"%.2f", newLocation.speed];
        self.speedLabel.text = String(format:"%.2f",newLocation.speed )
            
        
        // km/hで表示したい場合
        self.kphLabel.text = String(format:"%.2f",newLocation.speed * 3.600 )
        
    }
    
    
    func startStepCounting() {
        // CMPedometerが利用できるか確認
//        if #available(iOS 8.0, *) {
//            if CMPedometer.isStepCountingAvailable() {
//                // 計測開始
//                pedometer.startPedometerUpdatesFromDate(NSDate(), withHandler: {
//                    [unowned self] data, error in
//                    dispatch_async(dispatch_get_main_queue(), {
//                        print("update")
//                        if error != nil {
//                            // エラー
//                            self.label.text = "エラー : \(error)"
//                            print("エラー : \(error)")
//                        } else {
//                            let lengthFormatter = NSLengthFormatter()
//                            // 歩数
//                            let steps = data!.numberOfSteps
//                            // 距離
//                            let distance = data!.distance!.doubleValue
//                            // 速さ
//                            let time = data!.endDate.timeIntervalSinceDate(data!.startDate)
//                            let speed = distance / time
//                            // 上った回数
//                            let floorsAscended = data!.floorsAscended
//                            // 降りた回数
//                            let floorsDescended = data!.floorsDescended
//                            // 結果をラベルに出力
//                            self.label.text = "Steps: \(steps)"
//                                + "\n\nDistance : \(lengthFormatter.stringFromMeters(distance))"
//                                + "\n\nSpeed : \(lengthFormatter.stringFromMeters(speed)) / s"
//                                + "\n\nfloorsAscended : \(floorsAscended)"
//                                + "\n\nfloorsDescended : \(floorsDescended)"
//                        }
//                    })
//                    })
//            }
//        } else {
//            // Fallback on earlier versions
//        }
    }
    
    @IBAction func refresh(){
        startStepCounting()
        magnetCount()
        
        //現在地取得
        lm.startUpdatingLocation()
    }
    

    
    func magnetCount(){
        
        
        //
        //        if manager.deviceMotionAvailable{
        //            manager.deviceMotionUpdateInterval = 0.1
        //            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue()){
        //                (data: CMDeviceMotion!, error: NSError!) in
        //
        //                if let isError = error{
        //                    NSLog("Error: %@", isError)
        //                }
        //                valX = data.magneticField.field.x
        //                valY = data.magneticField.field.y
        //                valZ = data.magneticField.field.z
        //                valAccuracy = data.magneticField.accuracy.value
        //
        //
        //                if values != nil{
        //                    values!(x: valX, y: valY, z: valZ, accuracy: valAccuracy)
        //                }
        //
        //                self.delegate?.getMagneticFieldFromDeviceMotion!(valX, y: valY, z: valZ)
        //            }
        //
        //        } else {
        //            NSLog("Device Motion is not available")
        //        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
