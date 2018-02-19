//
//  HB_PT_SV_Logger.swift
//  Boilerplate
//
//  Created by Richard Willis on 09/03/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

protocol HBLoggerServiceProtocol {
	var isRemote: Bool { get set }
	var severity: Int { get set }
	func ger ( _ args: Any..., severity: Int, file: String, function: String, line: Int )
	func setGoogleDoc (
		_ URL: String,
		versionTextFieldID: String,
		userTextFieldID: String,
		functionTextFieldID: String,
		severityTextFieldID: String )
}
