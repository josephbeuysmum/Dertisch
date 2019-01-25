//
//  DT_PX_Image.swift
//  Dertisch
//
//  Created by Richard Willis on 25/11/2015.
//  Copyright © 2015 Richard Willis. All rights reserved.
//

import UIKit

public protocol ImagesProtocol: SousChef {
//	func getImage(by url: String, callback: ((String, Any?) -> Void)?) -> UIImage?
//	func loadImage(by url: String)
}

public class Images {
	public var headChef: HeadChefForSousChef?
	
	// todo forced unwraps for url_session and key is unacceptable, revisit this
	fileprivate let key: String
	
	fileprivate var
	urlsResolving: [String],
	raw_images: Dictionary<String, Data>,
	url_session: UrlSession!
	
	required public init(_ resources: [String: KitchenResource]? = nil) {
		key = NSUUID().uuidString
		url_session = resources?[UrlSession.staticId] as? UrlSession
		urlsResolving = []
		raw_images = [:]
	}
	
	deinit {}
}

extension Images: ImagesProtocol {
	public func getImage(by url: String, callback:((String, Any?) -> Void )? = nil) -> UIImage? {
		let image = getLocalImage( by: url )
		guard image == nil else { return image }
		guard callback != nil else { return nil }
//		let urlKey = getUrlKey( by: url )
//		dishes_.takeSingle( order: urlKey, orderer: self ) { [weak self] _, data in
//			guard let strongSelf = self, strongSelf.assess( result: data ) else { return }
//			callback!( url, strongSelf.getLocalImage( by: url ) )
//		}
		loadImage( by: url )
		return nil
	}
	
	public func loadImage(by url: String) {
//		_ = dishes_.takeSingle(order: url, orderer: self) { [weak self] _, data in
//			guard let strongSelf = self else { return }
//			if let urlIndex = strongSelf.urlsResolving.index(of: url) { strongSelf.urlsResolving.remove( at: urlIndex ) }
//			guard strongSelf.assess(result: data) else { return }
//			let result = data as! RawIngredients
//			strongSelf.raw_images[url] = result.data as? Data
//			strongSelf.dishes_.make(order: strongSelf.getUrlKey(by: url), with: url)
//		}
		_ = url_session.call(url, from: self)
	}
	
	
	
	fileprivate func assess(result: Any?) -> Bool {
		guard
			let result = result as? RawIngredients,
			let success = result.success,
			success,
			result.data is Data
			else { return false }
		return true
	}
	
	fileprivate func getLocalImage(by url: String) -> UIImage? {
		return raw_images[url] != nil ? UIImage(data: raw_images[url]!) : nil
	}
	
	fileprivate func getUrlKey(by url: String) -> String { return "\(key)_\(url)" }
}
