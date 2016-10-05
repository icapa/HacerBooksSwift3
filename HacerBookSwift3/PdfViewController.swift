//
//  PdfViewController.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 1/10/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit
import CoreData

class PdfViewController: UIViewController {
    var _model: Book
    
    var numComments = 0
    
    @IBAction func addNoteAction(_ sender: AnyObject) {
        let theNote = Annotation(withBook: _model, inContext: _model.managedObjectContext!)
        let noteVC = NotesViewController(model: theNote)
        self.navigationController?.pushViewController(noteVC, animated: true)
        
    }
    
    @IBOutlet weak var addNoteAction: UIBarButtonItem!
    @IBAction func viewNoteAction(_ sender: AnyObject) {
        
        let fr = NSFetchRequest<Annotation>(entityName: Annotation.entityName)
        fr.fetchBatchSize = 50
        fr.sortDescriptors = [NSSortDescriptor(key: "modificationDate",ascending: false)]
        fr.predicate = NSPredicate(format: "book == %@", _model)
        
        let fc = NSFetchedResultsController(fetchRequest: fr,
                                            managedObjectContext: _model.managedObjectContext!,
                                            sectionNameKeyPath: nil, cacheName: nil)
        
        // Create Table viewController
        /*
        let nVC = NotesTableViewController(fetchedResultsController: fc as! NSFetchedResultsController<NSFetchRequestResult>, style: .plain)
        
        self.navigationController?.pushViewController(nVC, animated: true)
        */
        
        // Creamos el layour
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 150)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset=UIEdgeInsets(top: 10,
                                         left: 10,
                                         bottom: 10,
                                         right: 10)
        
        // Creamos el CollectionViewController
        let cv = NotesCollectionViewController(fetchedResultsController: fc as! NSFetchedResultsController<NSFetchRequestResult>,
                                               layout: layout)
        
        self.navigationController?.pushViewController(cv , animated: true)
        
        
        
    }
    @IBOutlet weak var pdfView: UIWebView!
   
    
    //MARK: Init
    init(model: Book){
        _model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Sync
    func syncModelWithView(){
        self.pdfView.load(self.downloadPdf(ofBook: _model) as Data,
                          mimeType: "application/pdf",
                          textEncodingName: "utf8",
                          baseURL: URL(string: "www.google.es")!)
        
        /* How it works
        browserView.load((_model?._pdf.data)!, mimeType: "application/pdf", textEncodingName: "utf8", baseURL: URL(string:"http://www.google.com")!)
        */
    }
}
//MARK: Async download data
extension PdfViewController{
    func downloadPdf(ofBook book:Book)->NSData{
        if (book.pdf?.pdfData == nil){
            let mainBundle = Bundle.main
            let defaultPdf = mainBundle.url(forResource: "emptyPdf", withExtension: "pdf")!
            
            // AsyncData
            let theDefaultData = try! Data(contentsOf: defaultPdf)
            
            DispatchQueue.global(qos: .default).async {
                let theUrlImage = URL(string: book.pdfUrl!)
                let pdfData = try? Data(contentsOf: theUrlImage!)
                DispatchQueue.main.async {
                    if (pdfData==nil){
                        book.pdf?.pdfData = nil
                    }
                    else{
                        // Crate the pdfEntity
                        let thePdf = Pdf(withData: pdfData!,
                                         inContext: book.managedObjectContext!)
                        // Create the link
                        book.pdf = thePdf
                        //try! book.managedObjectContext?.save()
                        
                    }
                }
            }
            // Hay que mandar que descargue en segundo plano
            return theDefaultData as NSData
        }
        else{
            return (book.pdf?.pdfData)!
        }
    }

    
}
//MARK: - Lifecycle & KCO
extension PdfViewController{
    // Se llama una sola vez
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent=false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKVO()
       
        syncModelWithView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tearDownKVO()
    }
    
    
    static func observableKeys() -> [String] {return ["pdf"]};
    func setupKVO(){
        // alta en las notificaciones
        // para algunas propiedades
        // Deberes: Usar una la funcion map
        for key in PdfViewController.observableKeys(){
            
            _model.addObserver(self,
                                      forKeyPath: key,
                                      options: [],
                                      context: nil)
        }
    }
    
    func tearDownKVO(){
        // Baja en todas las notificaciones
        for key in PdfViewController.observableKeys(){
            _model.removeObserver(self,
                                       forKeyPath: key)
        }
    }
    
    
    
    
    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        
        
        syncModelWithView()
    }
}

