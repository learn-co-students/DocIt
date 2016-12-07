//
//  Temp.swift
//  emeraldHail
//
//  Created by Henry Ly on 11/29/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

struct Temp {

    var content: String
    var timestamp: String
    var uniqueID: String
    var naturalTime: String?
    var tempType : String

    init(dictionary: [String : Any]) {

        content = dictionary["content"] as? String ?? "No Content"
        timestamp = dictionary["timestamp"] as? String ?? "No Time"
        uniqueID = dictionary["uniqueID"] as? String ?? "No UniqueID"
        naturalTime = dictionary["naturalTime"] as? String ?? "No Natural Time"
        tempType = dictionary["tempType"] as? String ?? "Not Temperature Type"

    }

    init(content: String, timestamp: String, uniqueID: String, tempType: String) {
        print("Creating an instance of Temp")

        self.content = content
        self.timestamp = timestamp
        self.uniqueID = uniqueID
        self.tempType = tempType
    }

    func serialize() -> [String : Any] {
        print("Serializing a Temp")

        return ["content" : content,
                "timestamp" : timestamp,
                "uniqueID" : uniqueID,
                "postType" : "temp",
                "naturalTime" : getNaturalTime(),
                "tempType": tempType]

    }

    func getNaturalTime() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy @ h:mma"
        return dateFormatter.string(from: currentDate).uppercased()

    }

}
