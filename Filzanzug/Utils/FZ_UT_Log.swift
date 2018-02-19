//
//  FZ_UT_Logs.swift
//  Filzanzug
//
//  Created by Richard Willis on 14/10/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

// adds filename, time, and code line to print functions
public func lo ( _ args: Any?... , file: String = #file, function: String = #function, line: Int = #line ) {
	_lo( args, file: file, function: function, line: line )
}

// loops through an object, printing all of its keys and associated values
public func lobject ( _ object: [ String: Any ], file: String = #file, function: String = #function, line: Int = #line ) {
	for ( key, value ) in object {
		_lo( [ key, ":", value ], file: file, function: function, line: line )
	}
}

// differing levels of log (see FZConsts logLevel and logModes)
public func loInfo ( _ args: Any... , file: String = #file, function: String = #function, line: Int = #line ) {
	guard FZLogConsts.logModes.index( of: FZLogConsts.logLevel.info ) != nil else { return }
	_lo( args, file: file, function: function, line: line )
}

public func loFeedback ( _ args: Any... , file: String = #file, function: String = #function, line: Int = #line ) {
	guard FZLogConsts.logModes.index( of: FZLogConsts.logLevel.feedback ) != nil else { return }
	_lo( args, file: file, function: function, line: line )
}

public func loWarning ( _ args: Any... , file: String = #file, function: String = #function, line: Int = #line ) {
	guard FZLogConsts.logModes.index( of: FZLogConsts.logLevel.warning ) != nil else { return }
	_lo( args, file: file, function: function, line: line )
}

public func loError ( _ args: Any... , file: String = #file, function: String = #function, line: Int = #line ) {
	guard FZLogConsts.logModes.index( of: FZLogConsts.logLevel.error ) != nil else { return }
	_lo( args, file: file, function: function, line: line )
}



fileprivate func _lo ( _ args: [ Any? ], file: String, function: String, line: Int ) {
	let printableArgs = args.count > 0 ? args : [ "\( function ) ()" ]
	// if a file name is passed, create a shortened version of it to aid logging
	if  let lastSlash = FZString.getLastIndexOf( subString: "/", inString: file ) as Int?,
		let lastDot = FZString.getLastIndexOf( subString: ".", inString: file ) as Int?,
		let shortenedFileName = FZString.getSubStringOf( string: file, between: lastSlash + 1, and: lastDot ),
		let fileName = FZString.set( length: 16, ofText: shortenedFileName ),
		let shortenedLine = FZString.set( length: 4, ofText: String( line ) ),
		let shortenedInterval = FZString.set(
			length: 5,
			ofText: String( FZTime.getInterval( format: FZTime.IntervalFormats.withoutHoursAndMinutes ) ) ) {
		_log( printableArgs, location: "\( fileName ) \( shortenedLine ) \( shortenedInterval )" )
	// otherwise just log the args as-are
	} else {
		_log( printableArgs )
	}
}

fileprivate func _log ( _ args: [ Any? ], location: String? = nil ) {
	var mutableArgs = args
	// occasionally args is just a one-value array that contains the real args
	if  args.count == 1, let args = args[ 0 ] as? [ Any ] { mutableArgs = args }
	// turn args into single message string
	guard mutableArgs.count > 0 else { return }
	var message = FZCharConsts.emptyString
	_ = mutableArgs.map { element in
		if let messageSuffix = FZString.serialise( value: _serialise( arg: element ) ) {
			message = "\( message )  \( messageSuffix )"
		}
	}
	
	// hack: ^ lets us filter out all the nasty debug the XCode team have currently left in, hopefully just temporarily
	let
	prefix = "^",
	output = location == nil ? message : "\( location! ) \( message )"
	
	// turning this off whilst https://github.com/robbiehanson/XcodeColors is not XCode 8+ compatible
	//	let escape = "\u{001b}[", reset = escape + ";"
	//	message = "\( escape )fg204,153,51;\( message )\( reset )"
	//
	//	let
	//	prefix = "\( escape )fg204,0,102;> \( reset )"
	//	, output = location == nil ?
	//		message :
	//		"\( escape )fg51,51,51;\( location! )\( reset ) \( message )"
	//		"\( escape )fg51,51,51;\( location! )\( reset )\n\( message )"
	
	// log!
	print( "\( prefix )\( output )" )
//	print( "\( prefix )\( output )\( FZCharConsts.lineBreak )" )
}

fileprivate func _serialise ( arg: Any? ) -> String {
	return arg != nil ? "\( arg! )" : "nil"
}
