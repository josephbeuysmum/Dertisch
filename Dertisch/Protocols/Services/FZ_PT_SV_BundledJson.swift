//
//  DT_PT_SV_BundledJson.swift
//  Dertisch
//
//  Created by Richard Willis on 05/07/2018.
//

public protocol DTBundledJsonServiceProtocol: DTKitchenProtocol {
	var settings: DTJsonSettings? { get }
	func decode<T>(json fileName: String, into type: T.Type) -> T? where T : Decodable
}
