//
//  File.swift
//  Todoey
//
//  Created by Nuha Alharbi on 27/02/2023.
//

import Foundation
import RealmSwift

class ToDoCategory: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String = ""
    @Persisted var items = List<ToDoItem>()
    
    convenience init(title: String) {
        self.init()
        self.title = title
        
    }
}
