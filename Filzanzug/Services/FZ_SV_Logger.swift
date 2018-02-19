//
//  HB_SV_Logger.swift
//  Boilerplate
//
//  Created by Richard Willis on 09/03/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import QorumLogs

// provides remote logging to an external Google spreadsheet via QorumLogs
class HBLoggerService: HBLoggerServiceProtocol {
	public var signalBox: HBSignalsEntity
	
	// when false outputs to the output window, when true outputs to a Google spreadsheet
	public var isRemote: Bool {
		get { return _isRemote }
		set { _setRemoteness( newValue ) }
	}
	// must be one of the four static let values immediately below
	public var severity: Int {
		get { return _severity }
		set { _setSeverity( newValue ) }
	}
	
	static let
	DEBUG =				1,
	INFO =				2,
	WARNING =			3,
	ERROR =				4
	
	fileprivate var
	_isRemote: Bool,
	_googleDocSet: Bool,
	_severity: Int
	
	
	
	required init () {
//		_signals = signals
		signalBox = HBSignalsEntity()
		_googleDocSet = false
		_isRemote = false
		_severity = HBLoggerService.DEBUG
		_setRemoteness( _isRemote )
		_setSeverity( _severity )
	}
	
	deinit {}
	
	
	
	// "ger" as instances of this service get named "log", as in "log.ger"
	public func ger (
		_ args: Any...,
		severity: Int = -1,
		file: String = #file,
		function: String = #function,
		line: Int = #line ){
		guard let message = HBString.serialise( value: args ) else { return }
		let previousSeverity = _severity
		
		// temporarily change severity if a value is passed
		if severity > -1 { _setSeverity( severity ) }
		
		_log( message, file: file, function: function, line: line )
		
		// reset severity
		if severity > -1 { _setSeverity( previousSeverity ) }
	}
	
	// if logging as isRemote, this needs to be set
	public func setGoogleDoc (
		_ URL: String,
		versionTextFieldID: String,
		userTextFieldID: String,
		functionTextFieldID: String,
		severityTextFieldID: String ){
		QorumOnlineLogs.setupOnlineLogs(
			formLink: URL,
			versionField: versionTextFieldID,
			userInfoField: userTextFieldID,
			methodInfoField: functionTextFieldID,
			textField: severityTextFieldID
		)
		
		_googleDocSet = true
	}
	
	
	
	fileprivate func _log ( _ message: String, file: String, function: String, line: Int ) {
		switch _severity {
		case HBLoggerService.DEBUG:				QL1( message, file, function, line )
		case HBLoggerService.INFO:				QL2( message, file, function, line )
		case HBLoggerService.WARNING:			QL3( message, file, function, line )
		case HBLoggerService.ERROR:				QL4( message, file, function, line )
		default:								print( file, function, line, message )
		}
	}
	
	fileprivate func _setRemoteness ( _ logIsRemote: Bool ) {
		_isRemote = logIsRemote
		QorumLogs.enabled = !_isRemote
		QorumOnlineLogs.enabled = _isRemote
	}
	
	fileprivate func _setSeverity ( _ logSeverity: Int ) {
		switch logSeverity {
		case
		HBLoggerService.INFO,
		HBLoggerService.WARNING,
		HBLoggerService.ERROR:					_severity = logSeverity
		default:								_severity = HBLoggerService.DEBUG
		}
		
		QorumLogs.minimumLogLevelShown = _severity
		QorumOnlineLogs.minimumLogLevelShown = _severity
	}
}
