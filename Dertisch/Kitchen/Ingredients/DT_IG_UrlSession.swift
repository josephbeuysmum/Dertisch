//
//  DT_SV_API.swift
//  Dertisch
//
//  Created by Richard Willis on 19/10/2015.
//  Copyright © 2015 Richard Willis. All rights reserved.
//

import Foundation

public protocol UrlSessionProtocol: Ingredients {
//	func call(_ url: String, from sousChef: SousChefForIngredients, method: Methods?) -> Bool
}

public class UrlSession {
	private var sousChefs: [String: SousChefForIngredients]
	
	enum Methods: String { case GET, POST, DELETE }
	
	required public init(_ resources: [String: KitchenResource]? = nil) {
		sousChefs = [:]
	}
}

extension UrlSession: UrlSessionProtocol {
	func call(_ url: String, from sousChef: SousChefForIngredients, method: Methods? = .GET) -> Bool {
		guard let validUrl = URL(string: url) else { return false }
		sousChefs[url] = sousChef
		var request = URLRequest(url: validUrl)
		request.httpMethod = method!.rawValue
		_ = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
			guard error == nil else {
				lo("ERROR NEEDS HANDLING")
				return
			}
			guard
				let strongSelf = self,
				let rawIngredients = data,
				var sousChef = strongSelf.sousChefs[url]
				else {
					lo("EITHER MISSING SELF, DATA, OR DELEGATE NEEDS HANDLING")
					return
			}
			strongSelf.sousChefs.removeValue(forKey: url)
			sousChef.cook(rawIngredients)
			}.resume()
		return true
	}
}
