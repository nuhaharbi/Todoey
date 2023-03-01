//
//  Item.swift
//  Todoey
//
//  Created by Nuha Alharbi on 26/02/2023.
//

import Foundation
import RealmSwift

class ToDoItem: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String = ""
    @Persisted var isChecked: Bool = false
    @Persisted var dateCrated: Date = Date()
    
    @Persisted(originProperty: "items") var assignee: LinkingObjects<ToDoCategory>
    
    convenience init(title: String, isChecked: Bool) {
        self.init()
        self.title = title
        self.isChecked = isChecked
    }
}
