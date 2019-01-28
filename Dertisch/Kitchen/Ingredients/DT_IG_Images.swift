//
//  DT_IG_Images.swift
//  Dertisch
//
//  Created by Richard Willis on 25/11/2015.
//  Copyright © 2015 Richard Willis. All rights reserved.
//

import UIKit

public protocol ImagesProtocol: Ingredients {
//	func image(by url: String) -> UIImage?
//	func has(by url: String) -> Bool
//	func load(by url: String) -> Bool
}

public class Images {
	private var
	resources: [String: KitchenResource],
	urlsResolving: [String],
	rawImages: [String: Data],
	foodDelivery: FoodDelivery?
	
	required public init(_ resources: [String: KitchenResource]? = nil) {
		foodDelivery = resources?[FoodDelivery.staticId] as? FoodDelivery
		self.resources = [:]
		urlsResolving = []
		rawImages = [:]
	}
	
	deinit {}
}

extension Images: IngredientsForIngredients {
	public func blend(_ rawIngredients: RawIngredients) {
		guard
			rawIngredients.success,
			let image = rawIngredients.data
			else { return }
		let url = rawIngredients.url
		rawImages[url] = image
		guard let resource = resources[url] else { return }
		resources.removeValue(forKey: url)
		if var sousChef = resource as? SousChefForIngredients {
			sousChef.cook(rawIngredients)
		} else if let complexIngredients = resource as? IngredientsForIngredients {
			complexIngredients.blend(rawIngredients)
		}
	}
}

extension Images: ImagesProtocol {
	public subscript(url: String) -> UIImage? {
		return getImage(by: url)
	}
	
	func has(_ url: String) -> Bool {
		return rawImages[url] != nil
	}
	
	public func load(by url: String, from resource: KitchenResource) -> Bool {
		guard
			urlsResolving.index(of: url) == nil,
			foodDelivery != nil
			else { return false }
		resources[url] = resource
		return foodDelivery!.call(url, from: self)
	}
	
	private func getImage(by url: String) -> UIImage? {
		return rawImages[url] != nil ? UIImage(data: rawImages[url]!) : nil
	}
}
