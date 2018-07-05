//
//  FZ_PT_SV_BundledJson.swift
//  Filzanzug
//
//  Created by Richard Willis on 05/07/2018.
//

public protocol FZBundledJsonServiceProtocol: FZModelClassProtocol {
	var settings: FZJsonSettings? { get }
	func decode<T>(json fileName: String, by type: T.Type) -> T? where T : Decodable
	//	subscript(key: String) -> String? { get }
}
