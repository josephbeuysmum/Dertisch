//
//  FZ_SV_API.swift
//  Filzanzug
//
//  Created by Richard Willis on 19/10/2015.
//  Copyright © 2015 Richard Willis. All rights reserved.
//

import UIKit

extension FZUrlSessionService: FZUrlSessionServiceProtocol {
	public enum methods: String { case GET = "GET", POST = "POST", DELETE = "DELETE" }
	
	public var closet: FZModelClassCloset { return closet_ }
	
	
	
	public func activate() {}
	
	public func call (
		url: String,
		method: FZUrlSessionService.methods,
		parameters: Dictionary< String, String >? = nil,
		scanner: FZSignalReceivableProtocol? = nil,
		callback: ( ( String, Any? ) -> Void )? = nil ) {
		guard
			ongoing_calls.index( of: url ) == nil,
			let validUrl = URL( string: url )
			else { return }
		ongoing_calls.append( url )
		if scanner != nil && callback != nil {
			closet_.signals(key_)?.scanOnceFor(signal: url, scanner: scanner!, callback: callback! )
		}
		var request = URLRequest( url: validUrl )
		request.httpMethod = method.rawValue
		// todo serialise json for POSTs here?
		
		_ = URLSession.shared.dataTask( with: request ) { [weak self] data, response, error in
			guard let safeSelf = self else { return }
			guard error == nil else {
				lo( "todo ERROR to be handled here", url )
				return
			}
			guard data != nil else {
				lo( "todo NO DATA to be handled here" )
				return
			}
			// todo reintroduce stopwatch so hanging calls can be cancelled?
			if let callIndex = safeSelf.ongoing_calls.index( of: url ) {
				safeSelf.ongoing_calls.remove( at: callIndex )
			}
			do {
				switch data!.mimeType {
				case Data.mimeTypes.RTF:		try safeSelf.cast( richText: data!, with: url )
				case Data.mimeTypes.BMP,
					 Data.mimeTypes.GIF,
					 Data.mimeTypes.JPG,
					 Data.mimeTypes.PNG:		try safeSelf.cast( image: data!, with: url )
				default: ()						// todo process other mime types here as and when required...
				}
			} catch {
				safeSelf.transmit( success: false, with: url )
			}
			}.resume()
	}
	
	
	
	// unadulterated transmission because FZImageProxy deals with post-processing
	fileprivate func cast ( image data: Data, with url: String ) throws {
		transmit( success: true, with: url, and: data )
	}
	
	fileprivate func cast ( richText data: Data, with url: String ) throws {
		do {
			guard let json = try JSONSerialization.jsonObject( with: data, options: [] ) as? [ String: Any ] else { return }
			//			let success = json[ FZKeyConsts.success ] is Bool ? json[ FZKeyConsts.success ] as? Bool : nil
			let castArray: [ Dictionary< String, Any > ]
			if let rawData = json[ "data" ] {
				castArray = ( rawData is NSArray ? ( rawData as! NSArray ) as? [ Dictionary< String, AnyObject > ] : nil )!
			} else {
				castArray = [ json ]
			}
			transmit( success: true, with: url, and: castArray[ 0 ] )
		} catch {
			transmit( success: false, with: url )
		}
	}
	
	
	
	fileprivate func transmit ( success: Bool, with url: String, and data: Any? = nil ) {
		closet_.signals(key_)?.transmit(signal: url, with: FZApiResult(success: success, url: url, data: data))
	}
}

public class FZUrlSessionService {
	fileprivate var
	ongoing_calls: [ String ],
	key_: FZKey!,
	closet_: FZModelClassCloset!
	
	required public init() {
		ongoing_calls = []
		key_ = FZKey(self)
		closet_ = FZModelClassCloset(self, key: key_)
//		time_out = 3.0
	}
	
	deinit {}
}
