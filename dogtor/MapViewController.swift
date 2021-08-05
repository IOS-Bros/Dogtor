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
    
    var str : String!


    override func viewDidLoad() {
        super.viewDidLoad()
        //모서리 굴곡률
        btnLoc.layer.cornerRadius = 10
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let queryModel = MapQueryModel()
        queryModel.delegate = self
        queryModel.downloadItems()
        
//        myLoc.delegate = self
        
        myLoc.requestWhenInUseAuthorization() // 승인 허용 문구 받아서 처리
        myLoc.startUpdatingLocation() // GPS 좌표 받기 시작
        
        hospitalMap.showsUserLocation = true
        hospitalMap.setUserTrackingMode(.follow, animated: true)
        // originmylocaion
        
        hospitalMap.delegate = self

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
        
    }
    
    func setPoint(_ lat: CLLocationDegrees, _ lon: CLLocationDegrees, _ txt1: String, _ txt2: String) {
        let pLoc = CLLocationCoordinate2DMake(lat, lon)
        let pin = MKPointAnnotation()
        
        pin.coordinate = pLoc
        pin.title = txt1
        pin.subtitle = txt2
        
        hospitalMap.addAnnotation(pin)
    }
}
extension MapViewController: MapQueryModelProtocol{
    
    func itemDownloaded(items: NSArray) {
        hospitalList = items
        for i in 0..<hospitalList.count{
            let hospital: MapDBModel = hospitalList[i] as! MapDBModel
            setPoint(Double(hospital.Lat!)!, Double(hospital.Long!)!, hospital.HospitalName!, hospital.HospitalID!)
        }
    }
}

// myLoc = CLLocationManager()가 호출시 자동 실행
//extension MapViewController: CLLocationManagerDelegate{
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let lastLoc = locations.last
//        myLoc.stopUpdatingLocation() // 좌표 받기 중지
//    }
//}

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
        let identifier = "MyPin"
        

        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        var annotationView = hospitalMap.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: .none)
            annotationView?.image = UIImage(named: "pin30.png")
            annotationView?.canShowCallout = true
            let btn = UIButton(type: UIButton.ButtonType.infoLight)
            annotationView?.rightCalloutAccessoryView = btn
            
        }else{
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation!
//        print("버튼을 누른 곳은 : " , annotation.title!!, annotation.subtitle!!)
        
        str = annotation.subtitle!!
        self.performSegue(withIdentifier: "segMapDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segMapDetail"{
            
            let detailView = segue.destination as! MapDetailViewController
                let no = "https://m.map.naver.com/search2/site.naver?code=\(str!)"
                detailView.receiveItems(no)
        }

    }
    
}

