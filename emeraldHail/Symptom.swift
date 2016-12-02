//
//  symptoms.swift
//  emeraldHail
//
//  Created by Mirim An on 11/15/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit

enum Symptom: String {
    
    case bloodInStool = "Blood in stool",
    chestPain = "Chest pain",
    constipation = "Constipation",
    cough = "Cough",
    diarrhea = "Diarrhea",
    dizziness = "Dizziness",
    earache = "Earache",
    eyeDiscomfort = "Eye discomfort and redness",
    fever = "Fever",
    footPain = "Foot pain",
    footSwelling = "Foot swelling",
    headache = "Headache",
    heartpalpitations = "Heart palpitations",
    itchiness = "Itchiness",
    kneePain = "Knee pain",
    legSwelling = "Leg swelling",
    musclePain = "Joint pain or muscle pain",
    nasalcongestion = "Nasal congestion",
    nausea = "Nausea",
    neckPain = "Neck pain",
    shortBreath = "Shortness of breath",
    shoulderPain = "Shoulder pain",
    skinRashes = "Skin rashes",
    soreThroat = "Sore throat",
    urinaryProblems = "Urinary problems",
    runnyNose = "Runny nose",
    vision = "Vision Problems",
    vomiting = "Vomiting",
    wheezing = "Wheezing"
    
    
    var description: String {
        switch self {
        case .bloodInStool: return "Blood in stool"
        case .chestPain: return  "Chest pain"
        case .constipation: return "Constipation"
        case .cough: return "Cough"
        case .diarrhea: return "Diarrhea"
        case .dizziness: return "Dizziness"
        case .earache: return "Earache"
        case .eyeDiscomfort: return "Eye discomfort and redness"
        case .fever : return "Fever"
        case .footPain : return "Foot pain"
        case .footSwelling : return "Foot swelling"
        case .headache : return "Headache"
        case .heartpalpitations : return "Heart palpitations"
        case .itchiness : return "Itchiness"
        case .kneePain : return "Knee pain"
        case .legSwelling : return "Leg swelling"
        case .musclePain : return "Joint pain or muscle pain"
        case .nasalcongestion : return "Nasal congestion"
        case .nausea : return "Nausea"
        case .neckPain : return "Neck pain"
        case .shortBreath : return "Shortness of breath"
        case .shoulderPain : return "Shoulder pain"
        case .skinRashes : return "Skin rashes"
        case .soreThroat : return "Sore throat"
        case .urinaryProblems : return "Urinary problems"
        case .runnyNose : return "Runny nose"
        case .vision : return "Vision Problems"
        case .vomiting : return "Vomiting"
        case .wheezing : return "Wheezing"
            
            
        }
        
    }
    
    
}
