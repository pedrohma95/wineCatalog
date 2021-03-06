//
//  DetailViewController.swift
//  wineCatalog
//
//  Created by Pedro De Miranda Arthur on 2/15/17.
//  Copyright © 2017 Pedro De Miranda Arthur. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var wineNameLbl: UILabel!
    
    @IBOutlet weak var countryFlag: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    // essa é a table view do Matches
    var nameWine : String?
    
    var countryPassed : [String]?
    
    var wineImagePassed : UIImage?
    
    var countryFinal : String?
    
    var imageMatchesPassed : [UIImage?] = []
    
    var imageMatchesTextPassed : [String]?
    
    var detailMatchesTextPassed : [String]?
    
    var imageNotMatchesPassed : [UIImage?] = []
    
    var imageNotMatchesTextPassed : [String]?
    
    var detailNotMatchesTextPassed : [String]?
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var oi: UIImageView!
    @IBOutlet weak var titulo: UILabel!
    
    @IBOutlet weak var detalhe: UILabel!
    @IBOutlet weak var viewNotRecommended: UIView!
    
    var timer : Timer!
    var update : Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        update = 0
        
        populatePageControl()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false;
        
        let joiner = ""
        let elements = countryPassed
        let joinedStrings = elements?.joined(separator: joiner)
        
        let base: UInt32 = 127397
        
        if(joinedStrings == "All"){
            countryFinal = "🌐 (Worldwide)" 
        }
        else{
            countryFinal = joinedStrings?.unicodeScalars.flatMap { String.init(UnicodeScalar(base + $0.value)!) }.joined()
        }
        
        wineNameLbl.text = nameWine
        
        countryFlag.text = countryFinal
        
        if(nameWine == "Tannat"){
            self.viewNotRecommended.backgroundColor = hexStringToUIColor(hex: "#decce1")
            self.viewNotRecommended.layer.borderColor = hexStringToUIColor(hex: "#90449f").cgColor
            self.viewNotRecommended.layer.borderWidth = 5
            titulo.textColor = hexStringToUIColor(hex: "#90449f")
        }
        
        oi.image = imageNotMatchesPassed[update]
        titulo.text = imageNotMatchesTextPassed?[update]
        detalhe.text = detailNotMatchesTextPassed?[update]
        
        
        // Do any additional setup after loading the view.
        
    }
    
    func populatePageControl(){
        detalhe.lineBreakMode = NSLineBreakMode.byWordWrapping
        detalhe.numberOfLines = 5
        
        pageControl.numberOfPages = imageNotMatchesPassed.count
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = hexStringToUIColor(hex: "#b206c7")
        
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(DetailViewController.updateTimer), userInfo: nil, repeats: true)
        
    }
    
    internal func updateTimer(){
            if(update < imageNotMatchesPassed.count){
                pageControl.currentPage = update
                oi.image = imageNotMatchesPassed[update]
                titulo.text = imageNotMatchesTextPassed?[update]
                detalhe.text = detailNotMatchesTextPassed?[update]
                update = update + 1
            }
            else{
                update = 0
            }
        
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return imageMatchesPassed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "wineMatchesDetails", for: indexPath) as! MatchesViewCell
        
        cell.imagemMatches.image = imageMatchesPassed[indexPath.row]
        cell.matchesTxt.text = imageMatchesTextPassed?[indexPath.row]
        cell.detailsMatches.text = detailMatchesTextPassed?[indexPath.row]
        
        return cell

    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

