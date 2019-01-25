//
//  DT_IG_Ingredients.swift
//  Dertisch
//
//  Created by Richard Willis on 11/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

public protocol Ingredients: KitchenResource {}

extension Ingredients {
	public var sousChef: SousChefForIngredients? {
		get { return nil }
		set {}
	}
}
