//
//  DT_PX_Settings.swift
//  Dertisch
//
//  Created by Richard Willis on 03/07/2018.
//

import Foundation

public struct DTJsonSettings {
	let settings: Dictionary<String, String>
	
	public subscript(key: String) -> String? {
		get { return settings[key] }
	}
}

extension DTBundledJson: DTBundledJsonProtocol {
//	public var closet: DTKitchenCloset { return closet_ }
	public var settings: DTJsonSettings? { return settings_ }
	
	public func startShift() {}
	
	public func decode<T>(json fileName: String, into type: T.Type) -> T? where T : Decodable {
		guard
			// todo add sub-directories to jsonPath
			let jsonPath = Bundle.main.path(forResource: fileName, ofType: "json"),
			let jsonData = (NSData(contentsOfFile: jsonPath)) as Data?
			else { return nil }
		do {
			let json = try JSONDecoder().decode(type.self, from: jsonData)
//			jsons_[fileName] = json
//			parse(json)
			return json
			// todo complete error catching
		} catch DecodingError.dataCorrupted(let context) {
			handle(decodingError: context)
			return nil
		} catch DecodingError.keyNotFound(_, let context) {
			handle(decodingError: context)
			return nil
		} catch DecodingError.typeMismatch(_, let context) {
			handle(decodingError: context)
			return nil
		} catch DecodingError.valueNotFound(_, let context){
			handle(decodingError: context)
			return nil
		} catch {
			return nil
		}
	}
	
	fileprivate func handle(decodingError context: DecodingError.Context) {
		lo(context.debugDescription)
	}
	
	fileprivate func parseSettings() {
		guard let decodedSettings = decode(json: DTPrivateSettings.CodingKeys.data.rawValue, into: DTPrivateSettings.self) else { return }
		var settings: Dictionary<String, String> = [:]
		for setting in decodedSettings.data {
			guard settings[setting.key] == nil else { fatalError("DUPLICATED SETTING") }
			settings[setting.key] = setting.value
		}
		settings_ = DTJsonSettings(settings: settings)
	}
}

public class DTBundledJson {
	fileprivate let orders_:DTOrders
	
	fileprivate var
//	key_: DTKey!,
//	closet_: DTKitchenCloset!,
	settings_: DTJsonSettings?
	
	required public init(orders: DTOrders, kitchenStaffMembers: [DTKitchenProtocol]?) {
		orders_ = orders
//		key_ = DTKey(self)
//		closet_ = DTKitchenCloset(self, key: key_)
		parseSettings()
	}
	
	deinit {}
}

fileprivate struct DTPrivateSettings: Decodable {
	let data: [DTPrivateSetting]
	
	enum CodingKeys: String, CodingKey {
		case data = "settings"
	}
}

fileprivate struct DTPrivateSetting: Decodable {
	let key: String
	let value: String
}
