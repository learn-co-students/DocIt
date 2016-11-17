//
//  symptoms.swift
//  emeraldHail
//
//  Created by Mirim An on 11/15/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

enum Symptoms: String {
    
    case bloodInStool = "Blood in stool",
    chestPain = "Chest pain",
    constipation = "Constipation",
    cough="Cough",
    diarrhea="Diarrhea",
    dizziness="Dizziness",
    earache="Earache",
    eyeDiscomfort="Eye discomfort and redness",
    fever="Fever",
    footPain="Foot pain",
    footSwelling="Foot swelling",
    headache="Headache",
    heartpalpitations="Heart palpitations",
    itchiness="Itchiness",
    kneePain="Knee pain",
    legSwelling="Leg swelling",
    musclePain="Joint pain or muscle pain",
    nasalcongestion="Nasal congestion",
    nausea="Nausea",
    neckPain="Neck pain",
    shortBreath="Shortness of breath",
    shoulderPain="Shoulder pain",
    skinRashes="Skin rashes",
    soreThroat="Sore throat",
    urinaryProblems="Urinary problems",
    vision="Vision Problems",
    vomiting="Vomiting",
    wheezing="Wheezing",
    disgusted= "Disgusted"
    
}


struct Mood {
    enum Happy: String {
        case amused = "Amused",
        cheerful = "Cheerful",
        energetic = "Energetic",
        excited = "Excited",
        good = "Good",
        happy = "Happy",
        relaxed = "Relaxed"
    }
    
    enum Moody: String {
        case anxious = "Anxious",
        depressed = "Depressed",
        frustrated = "Frustrated",
        restless = "Restless",
        sad = "Sad",
        stressed = "Stressed",
        tired = "Tired"
    }
    
}

