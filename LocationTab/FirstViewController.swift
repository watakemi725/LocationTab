//
//  FirstViewController.swift
//  LocationTab
//
//  Created by Takemi Watanuki on 2015/11/25.
//  Copyright © 2015年 Takemi Watanuki. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FirstViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    var myMapView: MKMapView!
    var myLocationManager: CLLocationManager!
    var mySpeed : CLLocationSpeed!
    
    var speedLabel: UILabel!
    var kphLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //speedlabelの生成
        // Labelを作成.
        
        
        speedLabel = UILabel(frame: CGRectMake(0,self.view.bounds.height-100 ,self.view.bounds.width/2,50))
        // 背景をオレンジ色にする.
        speedLabel.backgroundColor = UIColor.grayColor()
        // ViewにLabelを追加.
        self.view.addSubview(speedLabel)
        
        kphLabel = UILabel(frame: CGRectMake(self.view.bounds.width/2,self.view.bounds.height-100 ,self.view.bounds.width/2,50))
        // 背景をオレンジ色にする.
        kphLabel.backgroundColor = UIColor.redColor()
        //        kphLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: 200)
        self.view.addSubview(kphLabel)
        
        
        // LocationManagerの生成.
        myLocationManager = CLLocationManager()
        
        // Delegateの設定.
        myLocationManager.delegate = self
        
        // 距離のフィルタ.
//        myLocationManager.distanceFilter = 100.0
        myLocationManager.distanceFilter = 1.0
        
        // 精度.
        myLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()
        
        // まだ認証が得られていない場合は、認証ダイアログを表示.
        if(status == CLAuthorizationStatus.NotDetermined) {
            
            // まだ承認が得られていない場合は、認証ダイアログを表示.
            
            self.myLocationManager.requestAlwaysAuthorization()
            
        }
        
        // 位置情報の更新を開始.
        myLocationManager.startUpdatingLocation()
        
        // MapViewの生成.
        myMapView = MKMapView()
        
        // MapViewのサイズを画面全体に.
        //        myMapView.frame = self.view.bounds
        myMapView.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height-100)
        
        // Delegateを設定.
        myMapView.delegate = self
        
        // MapViewをViewに追加.
        self.view.addSubview(myMapView)
        
        // 中心点の緯度経度.
        let myLat: CLLocationDegrees = 37.506804
        let myLon: CLLocationDegrees = 139.930531
        let myCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLat, myLon) as CLLocationCoordinate2D
        
        // 縮尺.
        let myLatDist : CLLocationDistance = 100
        let myLonDist : CLLocationDistance = 100
        
        // Regionを作成.
        let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myCoordinate, myLatDist, myLonDist);
        
        // MapViewに反映.
        myMapView.setRegion(myRegion, animated: true)
        
    }
    
    // GPSから値を取得した際に呼び出されるメソッド.
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 配列から現在座標を取得.
        let myLocations: NSArray = locations as NSArray
        let myLastLocation: CLLocation = myLocations.lastObject as! CLLocation
        let myLocation:CLLocationCoordinate2D = myLastLocation.coordinate
        
        // 縮尺.
        let myLatDist : CLLocationDistance = 100
        let myLonDist : CLLocationDistance = 100
        
        // Regionを作成.
        let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myLocation, myLatDist, myLonDist);
        
        
        
        
        
        // ピンを生成.
        let myPin: MKPointAnnotation = MKPointAnnotation()
        
        // 中心点.
        //        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLatitude, myLongitude)
        // 座標を設定.
        myPin.coordinate = myLocation
        
        // タイトルを設定.
        myPin.title = "タイトル"
        
        // サブタイトルを設定.
        myPin.subtitle = "サブタイトル"
        
        // MapViewにピンを追加.
        myMapView.addAnnotation(myPin)
        
        
        locationManager(myLocationManager, didUpdateToLocation: myLocations.lastObject as! CLLocation, fromLocation: myLocations.firstObject as! CLLocation)
        
        
        // MapViewに反映.
        myMapView.setRegion(myRegion, animated: true)
        
        
        
        //speedの取得
        mySpeed = myLastLocation.speed
        kphLabel.text = String(format:"%.2f m/s(cl)",mySpeed )
    }
    
    // Regionが変更した時に呼び出されるメソッド.
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("regionDidChangeAnimated")
    }
    
    
    /** 位置情報取得成功時 */
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        
        
        // Speedを更新
        //        self.speedLabel.text =[NSString stringWithFormat:@"%.2f", newLocation.speed];
        speedLabel.text = String(format:"%.2f m/s",newLocation.speed )
        
        
        // km/hで表示したい場合
        //        kphLabel.text = String(format:"%.2f km/h",newLocation.speed * 3.600 )
        
    }
    
    func speedUpdate(speed: CLLocationSpeed) {
        print(speed)
        //        label.text = "\(speed)"
        //         kphLabel.text = String(format:"%.2f m/s()",speed )
    }
    
    
    // 認証が変更された時に呼び出されるメソッド.
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        let shouldIAllow = false
        switch status{
        case .AuthorizedWhenInUse:
            print("AuthorizedWhenInUse")
        case .Authorized:
            print("Authorized")
        case .Denied:
            print("Denied")
        case .Restricted:
            print("Restricted")
        case .NotDetermined:
            print("NotDetermined")
        default:
            print("etc.")
            
        }
        NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
        if (shouldIAllow == true) {
            print("Location to Allowed")
            // Start location services
            myLocationManager.startUpdatingLocation()
        } else {
            print("Denied access: ")//\(locationStatus)")
        }
    }
}
