//
//  PdfViewController.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 1/10/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class PdfViewController: UIViewController {

    @IBOutlet weak var addNoteAction: UIBarButtonItem!
    @IBAction func viewNoteAction(_ sender: AnyObject) {
    }
    @IBOutlet weak var pdfView: UIWebView!
    var _model: Book
    
    //MARK: Init
    init(model: Book){
        _model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        syncModelWithView()
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
                        try! book.managedObjectContext?.save()
                        
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
