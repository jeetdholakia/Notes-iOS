//
//  Note.swift
//  Notes
//
//  Created by Jeet Dholakia on 13/11/22.
//

import Foundation

struct Note: Identifiable, Codable {
    var id: String { _id }
    var _id: String
    var note: String
}
