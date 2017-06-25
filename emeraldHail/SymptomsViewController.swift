//
//  SymptomsViewController.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 11/24/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SymptomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var symptomView: UIView!
    @IBOutlet weak var symptomTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: Properties
    var symptoms: [Symptom] = [.bloodInStool, .chestPain, .constipation, .cough, .diarrhea, .dizziness, .earache, .eyeDiscomfort, .fever, .footPain, .footSwelling, .headache, .heartpalpitations, .itchiness, .kneePain, .legSwelling, .musclePain, .nasalcongestion, .nausea, .neckPain, .runnyNose, .shortBreath, .shoulderPain, .skinRashes, .soreThroat, .stomachache, .urinaryProblems, .vision, .vomiting, .wheezing]
    
    var selectedSymtoms: [String : String] = [:]
    
    // MARK: - Loads
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Actions
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIButton) {
        saveButton.isEnabled = false
        // Prevent adding an empty ditionary to firebase
        if selectedSymtoms.isEmpty {
            saveButton.backgroundColor = Constants.Colors.submarine
            return
        }
        
        let postsRef = Database.posts.child(Store.eventID).childByAutoId()
        let uniqueID = postsRef.key
        let newSymp = Symp(content: selectedSymtoms, uniqueID: uniqueID, timestamp: getTimestamp())
        
        postsRef.setValue(newSymp.serialize(), withCompletionBlock: { error, ref in
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Methods
    func setupView() {
        symptomTableView.allowsMultipleSelection = true
        
        view.backgroundColor = Constants.Colors.transBlack
        
        symptomView.docItStyleView()
        symptomTableView.tintColor = Constants.Colors.scooter
        symptomTableView.separatorColor = Constants.Colors.athensGray
        
        saveButton.docItStyle()
        cancelButton.docItStyle()
        
        saveButton.isEnabled = false
        saveButton.backgroundColor = Constants.Colors.submarine
        
        symptomTableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symptoms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "symptomCell", for: indexPath) as! SymptomViewCell
        
        cell.symptomLabel.text = symptoms[indexPath.row].description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSymtoms["s\(indexPath.row)"] = symptoms[indexPath.row].rawValue
        print(selectedSymtoms)
        saveButton.isEnabled = true
        saveButton.backgroundColor = Constants.Colors.scooter
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedSymtoms.removeValue(forKey: "s\(indexPath.row)")
        print(selectedSymtoms)
    }
    
}

class SymptomViewCell: UITableViewCell {
    @IBOutlet weak var symptomLabel: UILabel!
}
