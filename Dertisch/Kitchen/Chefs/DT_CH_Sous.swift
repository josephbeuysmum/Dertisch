//
//  DT_SC_SousChef.swift
//  UsThree
//
//  Created by Richard Willis on 25/01/2019.
//  Copyright © 2019 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public protocol SousChefForIngredients {
	mutating func cook(_ rawIngredients: RawIngredients)
}

public protocol SousChefForHeadChef {
	var headChef: HeadChefForSousChef? { get set }
}

public protocol SousChef: SousChefForIngredients, SousChefForHeadChef, KitchenResource, StaffMember {}

public extension SousChef {
	public mutating func cook(_ rawIngredients: RawIngredients) { lo() }
	public func beginShift() { lo() }
	public mutating func endShift() { lo() }
}
