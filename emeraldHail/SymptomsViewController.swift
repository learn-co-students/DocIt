//
//  SymptomsViewController.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 11/24/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class SymptomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // OUTLETS 
    
    @IBOutlet weak var symptomTableView: UITableView!
    
    // PROPERTIES
    
    var symptoms:[Symptom] = [.bloodInStool, .chestPain, .constipation, .cough, .diarrhea, .dizziness, .earache, .eyeDiscomfort, .fever, .footPain, .footSwelling, .headache, .heartpalpitations, .itchiness, .kneePain, .legSwelling, .musclePain, .nasalcongestion, .nausea, .neckPain, .shortBreath, .shoulderPain, .skinRashes, .soreThroat, .urinaryProblems, .vision, .vomiting, .wheezing]
    
    // LOADS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        symptomTableView.reloadData()
    }
    
    // TABLEVIEW METHODS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symptoms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "symptomCell", for: indexPath) as! SymptomViewCell
        
        cell.symptomLabel.text = symptoms[indexPath.row].rawValue
        
        return cell
    }
    
}

class SymptomViewCell: UITableViewCell {

    // OUTLETS 
    
    @IBOutlet weak var symptomLabel: UILabel!
    

}
