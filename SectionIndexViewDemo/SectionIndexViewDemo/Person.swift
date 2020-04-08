//
//  Person.swift
//
//  https://github.com/0xcj/SectionIndexView
//
//
//

import UIKit

class Person: NSObject {
    let fullName: String
    let firstCharacter: String
    init(dic: Dictionary<String, String>) {
        self.fullName = dic["FirstNameLastName"] ?? "Bryon Grady"
        self.firstCharacter = String(self.fullName.prefix(1))
        super.init()
    }
}
