//
//  Tasks+CoreDataProperties.swift
//  CD
//
//  Created by Константин Козлов on 26.10.2021.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var name: String?
    @NSManaged public var important: Bool

}

extension Tasks : Identifiable {

}
