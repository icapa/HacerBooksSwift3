//
//  BookViewController.swift
//  HackerBooks
//
//  Created by Iván Cayón Palacio on 4/7/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {

    //MARK: - Properties
    var model: Book
    
    var delegate: BookViewControlerDelegate?
    
    //MARK: - Initialization
    init(model: Book){
        self.model=model
        super.init(nibName: "BookViewController", bundle: nil)
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func syncModelWithView(){
        
        
        // La imagen
        self.imageView.image = model.cover?.image
        
        // El titulo
        self.titleView.text = model.title
        
        // Los autores
        self.authorsView.text = "Authors: \(Author.authorsToString(theAuthors: model.author!))"
        
        
        // Los tags
        let theTags = BookTag.tagsForBook(theBook: model,
                                          inContext: model.managedObjectContext)
        var tagString : String = ""
        for each in theTags!{
            tagString.append((each.tag?.realTagName)!)
            tagString.append(",")
        }
        let listTagsString = tagString.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))

        
        
        self.tagsView.text = "\(listTagsString)"
        
        // Favorito
        favButton.titleLabel?.isHidden=true
        

        if model.isFavorite == true {
            favButton.setBackgroundImage(UIImage(named: "favorito.jpeg"), for: UIControlState.normal)
            //favButton.setTitle("No Fav", forState: UIControlState.Normal)
            //favButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)

        }else{
            favButton.setBackgroundImage(UIImage(named: "no_favorito.png"), for: UIControlState.normal)
            //favButton.setTitle("Favorite", forState: UIControlState.Normal)
            //favButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        }
        
        
    }
    
    @IBOutlet weak var tagsView: UILabel!
    
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var favButton: UIButton!
    
    @IBOutlet weak var authorsView: UILabel!
    
    @IBOutlet weak var imageBoot: UIImageView!
    //MARK: IB Actions Fav & Read
    
    @IBAction func markFavorite(sender: AnyObject) {
        if model.isFavorite == false {
            model.isFavorite=true
        }else{
            model.isFavorite=false
        }
        syncModelWithView()
        // Mando al delegado el libro que quiero meter o quitar
        //delegate?.bookViewControler(vc: self, didSelectBook: model)
        
        
    }
    
    @IBAction func readBook(sender: AnyObject) {
        //let pdfReader = ReaderViewController(model: model)
        //navigationController?.pushViewController(pdfReader, animated: true)
        print("Falta de implamentar el lector")
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
        favButton.titleLabel?.isHidden=true
        self.title = "Book properties"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        syncModelWithView()
    }
    
    //MARK: Notification
    func bookDidChange(notification: NSNotification){
        // Quitamos la portada
        if self.imageBoot.isHidden == false {
            self.imageBoot.isHidden = true
        }

        syncModelWithView()
    }
}
//MARK: - Delegate
protocol BookViewControlerDelegate{
    func bookViewControler(vc: BookViewController, didSelectBook book: Book)
}
