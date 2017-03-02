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
    
    case bloodInStool = "Blood in stool"
    case chestPain = "Chest pain"
    case constipation = "Constipation"
    case cough = "Cough"
    case diarrhea = "Diarrhea"
    case dizziness = "Dizziness"
    case earache = "Earache"
    case eyeDiscomfort = "Eye discomfort and redness"
    case fever = "Fever"
    case footPain = "Foot pain"
    case footSwelling = "Foot swelling"
    case headache = "Headache"
    case heartpalpitations = "Heart palpitations"
    case itchiness = "Itchiness"
    case kneePain = "Knee pain"
    case legSwelling = "Leg swelling"
    case musclePain = "Joint pain or muscle pain"
    case nasalcongestion = "Nasal congestion"
    case nausea = "Nausea"
    case neckPain = "Neck pain"
    case shortBreath = "Shortness of breath"
    case shoulderPain = "Shoulder pain"
    case skinRashes = "Skin rashes"
    case soreThroat = "Sore throat"
    case stomachache = "Stomachache"
    case urinaryProblems = "Urinary problems"
    case runnyNose = "Runny nose"
    case vision = "Vision Problems"
    case vomiting = "Vomiting"
    case wheezing = "Wheezing"
    
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
        case .stomachache : return "Stomachache"
        case .urinaryProblems : return "Urinary problems"
        case .runnyNose : return "Runny nose"
        case .vision : return "Vision Problems"
        case .vomiting : return "Vomiting"
        case .wheezing : return "Wheezing"
        }
    }
    
}
