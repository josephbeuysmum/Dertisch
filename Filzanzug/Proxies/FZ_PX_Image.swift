//
//  FZ_PX_Image.swift
//  Filzanzug
//
//  Created by Richard Willis on 25/11/2015.
//  Copyright © 2015 Richard Willis. All rights reserved.
//

import UIKit

extension FZImageProxy: FZImageProxyProtocol {
	public var closet: FZModelClassEntities { return closet_ }
	
	
	
	public func activate () {}
	
	public func getImage ( by url: String, callback:( ( String, Any? ) -> Void )? = nil ) -> UIImage? {
		let image = getLocalImage( by: url )
		guard image == nil else { return image }
		guard
			callback != nil,
			let signals = closet_.signals(key_.hash)
			else { return nil }
		let urlKey = getUrlKey( by: url )
		signals.scanOnceFor( signal: urlKey, scanner: self ) { [weak self] _, data in
			guard let safeSelf = self, safeSelf.assess( result: data ) else { return }
			callback!( url, safeSelf.getLocalImage( by: url ) )
		}
		loadImage( by: url )
		return nil
	}
	
	public func loadImage ( by url: String ) {
		guard
			let urlSession = closet_.urlSession(key_.hash),
			let signals = closet_.signals(key_.hash)
			else { return }
		_ = signals.scanOnceFor( signal: url, scanner: self ) { [weak self] _, data in
			guard let safeSelf = self else { return }
			if let urlIndex = safeSelf.urlsResolving.index( of: url ) { safeSelf.urlsResolving.remove( at: urlIndex ) }
			guard safeSelf.assess( result: data ) else { return }
			let result = data as! FZApiResult
			safeSelf.raw_images[ url ] = result.data as? Data
			signals.transmit(signal: safeSelf.getUrlKey( by: url ), with: url )
		}
		urlSession.call( url: url, method: FZUrlSessionService.methods.GET )
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
	
	fileprivate func getUrlKey ( by url: String ) -> String { return "\( key_.hash )_\( url )" }
}

public class FZImageProxy {
	fileprivate var
	urlsResolving: [ String ],
	raw_images: Dictionary< String, Data >,
	key_: FZKeyring!,
	closet_: FZModelClassEntities!

	required public init() {
		urlsResolving = []
		raw_images = [:]
		key_ = FZKeyring(delegate: self)
		closet_ = FZModelClassEntities(delegate: self, key: key_.hash)
	}
	
	deinit {}
}
