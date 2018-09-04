//
//  DT_PX_Image.swift
//  Dertisch
//
//  Created by Richard Willis on 25/11/2015.
//  Copyright © 2015 Richard Willis. All rights reserved.
//

import UIKit

extension DTImageSousChef: DTImageSousChefProtocol {
//	public var closet: DTKitchenCloset { return closet_ }
	
	
	
	public func startShift() {}
	
	public func getImage ( by url: String, callback:( ( String, Any? ) -> Void )? = nil ) -> UIImage? {
		let image = getLocalImage( by: url )
		guard image == nil else { return image }
		guard callback != nil else { return nil }
		let urlKey = getUrlKey( by: url )
		orders_.listenForOneOff( order: urlKey, order: self ) { [weak self] _, data in
			guard let strongSelf = self, strongSelf.assess( result: data ) else { return }
			callback!( url, strongSelf.getLocalImage( by: url ) )
		}
		loadImage( by: url )
		return nil
	}
	
	public func loadImage ( by url: String ) {
		_ = orders_.listenForOneOff( order: url, order: self ) { [weak self] _, data in
			guard let strongSelf = self else { return }
			if let urlIndex = strongSelf.urlsResolving.index( of: url ) { strongSelf.urlsResolving.remove( at: urlIndex ) }
			guard strongSelf.assess( result: data ) else { return }
			let result = data as! DTRawIngredient
			strongSelf.raw_images[ url ] = result.data as? Data
			strongSelf.orders_.make(order: strongSelf.getUrlKey( by: url ), with: url )
		}
		url_session.call( url: url, method: DTUrlSessionSousChef.methods.GET )
	}
	
	
	
	fileprivate func assess ( result: Any? ) -> Bool {
		guard
			let result = result as? DTRawIngredient,
			let success = result.success,
			success,
			result.data is Data
			else { return false }
		return true
	}
	
	fileprivate func getLocalImage ( by url: String ) -> UIImage? {
		return raw_images[ url ] != nil ? UIImage( data: raw_images[ url ]! ) : nil
	}
	
	fileprivate func getUrlKey(by url: String) -> String { return "\(key_)_\(url)" }
}

public class DTImageSousChef {
	// herehere...
	/*
	- test changes
	- forced unwraps for url_session and key_ is unacceptable, revisit this
	- rename orders to orders?
	- rename headChefs to headChefs etc?
	*/
	fileprivate let
	orders_: DTOrders,
	key_: String

	fileprivate var
	urlsResolving: [ String ],
	raw_images: Dictionary< String, Data >,
//	key_: DTKey!,
	url_session: DTUrlSessionSousChef!
//	closet_: DTKitchenCloset!

	required public init(orders: DTOrders, kitchenStaffMembers: [DTKitchenProtocol]?) {
		orders_ = orders
		key_ = NSUUID().uuidString
		if let strongModelClasses = kitchenStaffMembers {
			for modelClass in strongModelClasses {
				if type(of: modelClass) == DTUrlSessionSousChef.self {
					url_session = modelClass as! DTUrlSessionSousChef
					break
				}
			}
		}
		urlsResolving = []
		raw_images = [:]
//		key_ = DTKey(self)
//		closet_ = DTKitchenCloset(self, key: key_)
	}
	
	deinit {}
}
