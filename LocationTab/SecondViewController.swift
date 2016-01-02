//
//  SecondViewController.swift
//  LocationTab
//
//  Created by Takemi Watanuki on 2015/11/25.
//  Copyright © 2015年 Takemi Watanuki. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

class SecondViewController: UIViewController,CLLocationManagerDelegate {
    
    
    
    var myLocationManager: CLLocationManager!
    
    //グローバル平均3軸加速度
    var GlobalAverageAccel = 0.0
    
    @IBOutlet var kasokudox : UILabel!
    @IBOutlet var kasokudoy : UILabel!
    @IBOutlet var kasokudoz : UILabel!
    @IBOutlet var kasokudoAve : UILabel!
    
    @IBOutlet var jiyairox : UILabel!
    @IBOutlet var jiyairoy : UILabel!
    @IBOutlet var jiyairoz : UILabel!
    
    
    
    @IBOutlet var conpas : UILabel!
    
    
    // create instance of MotionManager
    let motionManager: CMMotionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        // Initialize MotionManager
        motionManager.deviceMotionUpdateInterval = 0.05 // 20Hz
        
        // Start motion data acquisition
        motionManager.startDeviceMotionUpdatesToQueue( NSOperationQueue.currentQueue()!, withHandler:{
            deviceManager, error in
            let accel: CMAcceleration = deviceManager!.userAcceleration
            self.kasokudox.text = String(format: "%.2f", accel.x)
            self.kasokudoy.text = String(format: "%.2f", accel.y)
            self.kasokudoz.text = String(format: "%.2f", accel.z)
            //
            let gyro: CMRotationRate = deviceManager!.rotationRate
            self.jiyairox.text = String(format: "%.2f", gyro.x)
            self.jiyairoy.text = String(format: "%.2f", gyro.y)
            self.jiyairoz.text = String(format: "%.2f", gyro.z)
            
            
            
            
            
            self.GlobalAverageAccel = sqrt((accel.x*accel.x)+(accel.y*accel.y)+(accel.z*accel.z))
            
            self.kasokudoAve.text = String(format: "%.2f", self.GlobalAverageAccel)
            
            
        })
        
        // LocationManagerの生成.
        myLocationManager = CLLocationManager()
        
        
        myLocationManager.requestAlwaysAuthorization()
        
        // Delegateの設定.
        myLocationManager.delegate = self
        
        // 何度動いたら更新するか（デフォルトは1度）
        myLocationManager.headingFilter = kCLHeadingFilterNone;
        
        // デバイスの度の向きを北とするか（デフォルトは画面上部）
        myLocationManager.headingOrientation = CLDeviceOrientation.Portrait //kCLDeviceOrientationPortrait
        
        
        myLocationManager.distanceFilter = 1.0 // 1m毎にGPS情報取得
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest // 最高精度でGPS取得
        myLocationManager.startUpdatingLocation() // 位置情報更新機能起動
        myLocationManager.startUpdatingHeading() // コンパス更新機能起動
        
        // ヘディングイベントの開始
        myLocationManager.startUpdatingHeading() //startUpdatingHeading
        
        if(CLLocationManager.headingAvailable()==true){
            
            
            //            // LocationManagerの生成.
            //            myLocationManager = CLLocationManager()
            //
            //            // Delegateの設定.
            //            myLocationManager.delegate = self
            //
            //            // 何度動いたら更新するか（デフォルトは1度）
            //            myLocationManager.headingFilter = kCLHeadingFilterNone;
            //
            //            // デバイスの度の向きを北とするか（デフォルトは画面上部）
            //            myLocationManager.headingOrientation = CLDeviceOrientation.Portrait //kCLDeviceOrientationPortrait
            //
            //
            //            myLocationManager.distanceFilter = 1.0 // 1m毎にGPS情報取得
            //            myLocationManager.desiredAccuracy = kCLLocationAccuracyBest // 最高精度でGPS取得
            //            myLocationManager.startUpdatingLocation() // 位置情報更新機能起動
            //            myLocationManager.startUpdatingHeading() // コンパス更新機能起動
            //
            //            // ヘディングイベントの開始
            //            myLocationManager.startUpdatingHeading() //startUpdatingHeading
            
        }
        
        
        
        //
        //        if ([CLLocationManager headingAvailable])
        //        {
        //            // インスタンスを生成
        //            _locationManager = [[CLLocationManager alloc] init];
        //
        //            // デリゲートを設定
        //            _locationManager.delegate = self;
        //
        //            // 何度動いたら更新するか（デフォルトは1度）
        //            _locationManager.headingFilter = kCLHeadingFilterNone;
        //
        //            // デバイスの度の向きを北とするか（デフォルトは画面上部）
        //            _locationManager.headingOrientation = CLDeviceOrientationPortrait;
        //
        //            // ヘディングイベントの開始
        //            [_locationManager startUpdatingHeading];
        //        }
        //
        
    }
    
    func locationManager(manager:CLLocationManager, didUpdateHeading newHeading:CLHeading){
        conpas.text = String(format:"%f deg",newHeading.magneticHeading)
        
    }
    
    //    // 緯度・経度を受信
    //    　func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!){
    //        　　locationLabel.text = String(format:"%f , %f",
    //            　　　　newLocation.coordinate.latitude,
    //            　　　　newLocation.coordinate.longitude)
    //        　}
    //
    //    　// コンパスの値を受信
    //    　func locationManager(manager:CLLocationManager, didUpdateHeading newHeading:CLHeading) {
    //        　　　　headingLabel.text = String(format:"%f deg",newHeading.magneticHeading)
    //        　}
    
    //    - (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
    //    {
    //    CLLocationDirection heading = newHeading.magneticHeading;
    //    self.textField.text = [NSString stringWithFormat:@"%.2f", heading];
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

