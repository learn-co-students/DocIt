//
//  Pain.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/30/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

struct Pain {

    var content: String
    var timestamp: String
    var uniqueID: String
    var naturalTime: String?


    init(dictionary: [String : Any]) {

        content = dictionary["content"] as? String ?? "No Content"
        timestamp = dictionary["timestamp"] as? String ?? "No Time"
        uniqueID = dictionary["uniqueID"] as? String ?? "No UniqueID"
        naturalTime = dictionary["naturalTime"] as? String ?? "No Natural Time"
        

    }

    init(content: String, timestamp: String, uniqueID: String) {
        print("Creating an instance of pain")

        self.content = content
        self.timestamp = timestamp
        self.uniqueID = uniqueID

    }

    func serialize() -> [String : Any] {
        print("Serializing a pain")

        return ["content" : content,
                "timestamp" : timestamp,
                "uniqueID" : uniqueID,
                "postType" : "pain",
                "naturalTime" : getNaturalTime()]

    }

    func getNaturalTime() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy @ h:mma"

        return dateFormatter.string(from: currentDate).uppercased()

    }

}
