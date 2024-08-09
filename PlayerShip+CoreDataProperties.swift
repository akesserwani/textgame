//
//  PlayerShip+CoreDataProperties.swift
//  textgame
//
//  Created by Ashby Marriott on 8/9/24.
//
//

import Foundation
import CoreData


extension PlayerShip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerShip> {
        return NSFetchRequest<PlayerShip>(entityName: "PlayerShip")
    }

    @NSManaged public var goldAmount: Int32
    @NSManaged public var condition: Int32
    @NSManaged public var crewSatisfaction: Int32
    @NSManaged public var playerShipType: String?

}

extension PlayerShip : Identifiable {

}
