//
//  Tasks+CoreDataProperties.swift
//  CD
//
//  Created by Константин Козлов on 09.11.2021.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var important: Bool
    @NSManaged public var name: String?
    @NSManaged public var date: Date?

}

extension Tasks : Identifiable {

}
