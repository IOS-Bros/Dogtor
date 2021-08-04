//
//  MapViewController.swift
//  dogtor
//
//  Created by SeungYeon on 2021/08/03.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var hospitalMap: MKMapView!
    @IBOutlet weak var btnLoc: UIButton!
    
    var hospitalList: NSArray = NSArray()
    let myLoc = CLLocationManager()
    
    var mylet:Double!
    var mylong:Double!

    override func viewDidLoad() {
        super.viewDidLoad()
        //모서리 굴곡률
        btnLoc.layer.cornerRadius = 10
        
        myLoc.delegate = self
        myLoc.requestWhenInUseAuthorization() // 승인 허용 문구 받아서 처리
        myLoc.startUpdatingLocation() // GPS 좌표 받기 시작
        
        hospitalMap.showsUserLocation = true
        hospitalMap.setUserTrackingMode(.follow, animated: true)
        // originmylocaion
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let queryModel = MapQueryModel()
        queryModel.delegate = self
        queryModel.downloadItems()

    }
    @IBAction func btnMyLoc(_ sender: UIButton) {
        hospitalMap.showsUserLocation = true
        hospitalMap.setUserTrackingMode(.follow, animated: true)
    }
    // 좌표 값에 대한 것
    func mapMove(_ lat: CLLocationDegrees, _ lon: CLLocationDegrees, _ txt1: String){
        let pLoc = CLLocationCoordinate2DMake(lat, lon)
        //  배율
        let pSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        
        // 좌표 정보
        let pRegion = MKCoordinateRegion(center: pLoc, span: pSpan)
        
        // 현재 지도를 좌표 정보로 보이기
        hospitalMap.setRegion(pRegion, animated: true)
        
//        let addrLoc = CLLocation(latitude: lat, longitude: lon)
//        var txt2 = ""
//
//        CLGeocoder().reverseGeocodeLocation(addrLoc, completionHandler: {place, error in
//            let pm = place!.first
//            txt2 = pm!.country! // 국가
//            txt2 += " " + pm!.locality! // 시도
//            txt2 += " " + pm!.thoroughfare! // 동
//            self.addr2.text = txt2
//        })
//        addr1.text = txt1
//        setPoint(pLoc, txt1)
    }
    
    func setPoint(_ lat: CLLocationDegrees, _ lon: CLLocationDegrees, _ txt1: String) {
        let pLoc = CLLocationCoordinate2DMake(lat, lon)
        let pin = MKPointAnnotation()
        
        pin.coordinate = pLoc
        pin.title = txt1
//        pin.subtitle = txt2
        
        hospitalMap.addAnnotation(pin)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController: MapQueryModelProtocol{
    
    func itemDownloaded(items: NSArray) {
        hospitalList = items
        for i in 0..<hospitalList.count{
            let hospital: MapDBModel = hospitalList[i] as! MapDBModel
            setPoint(Double(hospital.Lat!)!, Double(hospital.Long!)!, hospital.HospitalName!)
        }
        
    }
}

// myLoc = CLLocationManager()가 호출시 자동 실행
extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let lastLoc = locations.last
        mylet = (lastLoc?.coordinate.latitude)!
        mylong = (lastLoc?.coordinate.longitude)!
        // 지도보기
//        mapMove((lastLoc?.coordinate.latitude)!, (lastLoc?.coordinate.longitude)!, "현재 위치")
//        mapMove(hospitalList[pageControl.currentPage].1, hospitalList[pageControl.currentPage].2, hospitalList[pageControl.currentPage].0)
        
        myLoc.stopUpdatingLocation() // 좌표 받기 중지
    }
    
}

extension MapViewController:MKMapViewDelegate{
//    private func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        var annotationView = hospitalMap.dequeueReusableAnnotationView(withIdentifier: "Museum")
//        if annotationView == nil{
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Museum")
//            annotationView?.image = UIImage(named: "Japan_small_icon.png")
//            annotationView?.canShowCallout = false
//        }else{
//            annotationView!.annotation = annotation
//        }
//         return annotationView
//     }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = hospitalMap.dequeueReusableAnnotationView(withIdentifier: "Museum")
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Museum")
            annotationView?.canShowCallout = true
            let btn = UIButton(type: UIButton.ButtonType.infoLight)
            annotationView?.rightCalloutAccessoryView = btn
            btn.tag = 1
            let btn2 = UIButton(type: UIButton.ButtonType.infoLight)
            annotationView?.leftCalloutAccessoryView = btn2
            btn2.tag = 2
        }else{
            annotationView!.annotation = annotation
        }
        return annotationView
    }
}

