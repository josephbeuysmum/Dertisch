//
//  FZ_PX_Image.swift
//  Dertisch
//
//  Created by Richard Willis on 25/11/2015.
//  Copyright © 2015 Richard Willis. All rights reserved.
//

import UIKit

extension FZImageProxy: FZImageProxyProtocol {
//	public var closet: FZModelClassCloset { return closet_ }
	
	
	
	public func activate() {}
	
	public func getImage ( by url: String, callback:( ( String, Any? ) -> Void )? = nil ) -> UIImage? {
		let image = getLocalImage( by: url )
		guard image == nil else { return image }
		guard callback != nil else { return nil }
		let urlKey = getUrlKey( by: url )
		signals_.scanOnceFor( signal: urlKey, scanner: self ) { [weak self] _, data in
			guard let strongSelf = self, strongSelf.assess( result: data ) else { return }
			callback!( url, strongSelf.getLocalImage( by: url ) )
		}
		loadImage( by: url )
		return nil
	}
	
	public func loadImage ( by url: String ) {
		_ = signals_.scanOnceFor( signal: url, scanner: self ) { [weak self] _, data in
			guard let strongSelf = self else { return }
			if let urlIndex = strongSelf.urlsResolving.index( of: url ) { strongSelf.urlsResolving.remove( at: urlIndex ) }
			guard strongSelf.assess( result: data ) else { return }
			let result = data as! FZApiResult
			strongSelf.raw_images[ url ] = result.data as? Data
			strongSelf.signals_.transmit(signal: strongSelf.getUrlKey( by: url ), with: url )
		}
		url_session.call( url: url, method: FZUrlSessionService.methods.GET )
	}
	
	
	
	fileprivate func assess ( result: Any? ) -> Bool {
		guard
			let result = result as? FZApiResult,
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

public class FZImageProxy {
	// herehere...
	/*
	- test changes
	- forced unwraps for url_session and key_ is unacceptable, revisit this
	- rename signals to orders?
	- rename interactors to headChefs etc?
	*/
	fileprivate let
	signals_: FZSignalsService,
	key_: String

	fileprivate var
	urlsResolving: [ String ],
	raw_images: Dictionary< String, Data >,
//	key_: FZKey!,
	url_session: FZUrlSessionService!
//	closet_: FZModelClassCloset!

	required public init(signals: FZSignalsService, modelClasses: [FZModelClassProtocol]?) {
		signals_ = signals
		key_ = NSUUID().uuidString
		if let strongModelClasses = modelClasses {
			for modelClass in strongModelClasses {
				if type(of: modelClass) == FZUrlSessionService.self {
					url_session = modelClass as! FZUrlSessionService
					break
				}
			}
		}
		urlsResolving = []
		raw_images = [:]
//		key_ = FZKey(self)
//		closet_ = FZModelClassCloset(self, key: key_)
	}
	
	deinit {}
}
