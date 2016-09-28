//
//  BookViewController.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 26/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {

    var _model: Book
    
    init(model: Book){
        _model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    @IBAction func changeFavoritu(_ sender: AnyObject) {
    }
    @IBAction func readPdf(_ sender: AnyObject) {
    }
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
       
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageBook: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: Init
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Sync
    func syncModelWithView(){
        self.tagsLabel.text = _model.listOfTags
        self.authorLabel.text = Author.authorsToString(theAuthors: _model.author!)
        self.titleLabel.text = _model.title!
        self.imageBook.image = (_model.cover?.image)!
        
    }
    
    //MARK: Loads
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        syncModelWithView()
    }
    
}
