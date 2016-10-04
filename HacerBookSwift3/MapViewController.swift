//
//  MapViewController.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 4/10/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>?
    
    //MARK: - Init
    init (model: NSFetchedResultsController<NSFetchRequestResult>){
        self.fetchedResultsController = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Tenemos los fetch habría que crear las marcas
        executeSearch()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Aquí hay que pintar las posiciones
        let pos = self.centerPosition()
        if (pos != nil){
            let region = MKCoordinateRegionMakeWithDistance((pos?.coordinate)!, 1000, 1000)
            mapView.setRegion(region, animated: true)
        }
    }
}
//MARK: - Search CoreData
extension MapViewController{
    func executeSearch(){
        if let fc = fetchedResultsController{
            do{
                try fc.performFetch()
            }catch let e as NSError{
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
            }
        }
    }
}

//MARK: - Localization Utils
extension MapViewController{
    // Voy a hacer la media de todas las notas para centrar el mapa
    func centerPosition()->CLLocation?{
        var meanLatitude = 0.0
        var meanLongitude = 0.0
        var numOfPosition = 0
        for each in (fetchedResultsController?.fetchedObjects)!{
            let a = each as! Annotation
            if (a.localization != nil){
                let c = a.localization
                meanLatitude = meanLatitude + (c?.latitude)!
                meanLongitude = meanLongitude + (c?.longitude)!
                numOfPosition = numOfPosition + 1
                
                // Aprovecho para crear las anotaciones
                let fmt = DateFormatter()
                fmt.dateStyle = .medium
                
                
                let mark = Marks(title: a.title!,
                                 locationName: fmt.string(from: a.modificationDate! as Date),
                                 coordinate: CLLocationCoordinate2D(latitude: (c?.latitude)!, longitude: (c?.longitude)!))
                mapView.addAnnotation(mark)
                
            }
        }
        if (numOfPosition>0){
            meanLongitude = meanLongitude.divided(by: Double(numOfPosition))
            meanLatitude  = meanLatitude.divided(by: Double(numOfPosition))
            return CLLocation(latitude: meanLatitude, longitude: meanLongitude)
        }
        else{
            return nil
        }
    }
}
