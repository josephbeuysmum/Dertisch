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
	fileprivate let key: String
	
	fileprivate var
	urlsResolving: [String],
	rawImages: [String: Data],
	foodDelivery: FoodDelivery?
	
	required public init(_ resources: [String: KitchenResource]? = nil) {
		key = NSUUID().uuidString
		foodDelivery = resources?[FoodDelivery.staticId] as? FoodDelivery
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
		rawImages[rawIngredients.url] = image
		lo(rawIngredients)
	}
}

extension Images: ImagesProtocol {
	public subscript(url: String) -> UIImage? {
		if let image = getImage(by: url) {
			return image
		} else {
			_ = load(by: url)
			return nil
		}
	}
	
	func has(by url: String) -> Bool {
		return rawImages[url] != nil
	}
	
	public func load(by url: String) -> Bool {
		guard
			urlsResolving.index(of: url) == nil,
			foodDelivery != nil
			else { return false }
		return foodDelivery!.call(url, from: self)
	}
	
	private func getImage(by url: String) -> UIImage? {
		return rawImages[url] != nil ? UIImage(data: rawImages[url]!) : nil
	}
}
