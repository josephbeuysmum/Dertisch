//
//  FZ_PX_Settings.swift
//  Filzanzug
//
//  Created by Richard Willis on 03/07/2018.
//

import Foundation

public struct FZJsonSettings {
	let settings: Dictionary<String, String>
	
	public subscript(key: String) -> String? {
		get { return settings[key] }
	}
}

extension FZBundledJsonService: FZBundledJsonServiceProtocol {
//	public var closet: FZModelClassCloset { return closet_ }
	public var settings: FZJsonSettings? { return settings_ }
	
	public func activate() {}
	
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
		guard let decodedSettings = decode(json: FZPrivateSettings.CodingKeys.data.rawValue, into: FZPrivateSettings.self) else { return }
		var settings: Dictionary<String, String> = [:]
		for setting in decodedSettings.data {
			guard settings[setting.key] == nil else { fatalError("DUPLICATED SETTING") }
			settings[setting.key] = setting.value
		}
		settings_ = FZJsonSettings(settings: settings)
	}
}

public class FZBundledJsonService {
	fileprivate let signals_:FZSignalsService
	
	fileprivate var
//	key_: FZKey!,
//	closet_: FZModelClassCloset!,
	settings_: FZJsonSettings?
	
	required public init(signals: FZSignalsService, modelClasses: [FZModelClassProtocol]?) {
		signals_ = signals
//		key_ = FZKey(self)
//		closet_ = FZModelClassCloset(self, key: key_)
		parseSettings()
	}
	
	deinit {}
}

fileprivate struct FZPrivateSettings: Decodable {
	let data: [FZPrivateSetting]
	
	enum CodingKeys: String, CodingKey {
		case data = "settings"
	}
}

fileprivate struct FZPrivateSetting: Decodable {
	let key: String
	let value: String
}
