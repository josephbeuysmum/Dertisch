//
//  FZ_UT_String.swift
//  Filzanzug
//
//  Created by Richard Willis on 15/02/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import UIKit

public class FZString {
	// returns a string with the first char uppercase, and the remaining chars lowercase
	public static func capitalise ( string: String, firstCharOnly: Bool = false ) -> String? {
		guard
			let firstChar = getSubStringOf( string: string, between: 0, and: 1 ),
			let restOfString = getSubStringOf( string: string, between: 1, and: string.count )
		else { return nil }
		let firstCharUppercase = firstChar.uppercased()
		return firstCharOnly ?
			"\( firstCharUppercase )\( restOfString )" :
			"\( firstCharUppercase )\( restOfString.lowercased() )"
	}
	
	public static func decimalise ( double: Double ) -> String {
		let
		stringDouble = String( double ),
		pointIndex = FZString.getIndexOf( subString: FZCharConsts.dot, inString: stringDouble )
		return pointIndex != nil && pointIndex! + 2 < stringDouble.count ? stringDouble : "\( stringDouble )0"
	}
	
	// returns an attributed string with the section between "start" and "end" bold
	// or nil where "start" and "end" are invalid indices
	public static func embolden (
		subString: NSMutableAttributedString,
		withFontSizeOf fontSize: CGFloat,
		between startIndex: Int? = nil,
		and endIndex: Int? = nil ) -> NSMutableAttributedString? {
		let indices = _getIndicesFrom( subString: subString, startIndex: startIndex, andEndIndex: endIndex )
		if let range = _getRangeFrom( attributedText: subString, between: indices[ 0 ], and: indices[ 1 ] ) {
			subString.addAttributes( [ NSAttributedStringKey.font: UIFont.boldSystemFont( ofSize: fontSize ) ], range: range )
			return subString
		} else {
			return nil
		}
	}
	
	// returns an attributed string with the section between "start" and "end" bold,
	// or nil where "start" and "end" are invalid indices
	public static func embolden (
		subString: String,
		withFontSizeOf fontSize: CGFloat,
		between startIndex: Int? = nil,
		and endIndex: Int? = nil ) -> NSMutableAttributedString? {
		let indices = _getIndicesFrom( subString: subString, startIndex: startIndex, andEndIndex: endIndex )
		return embolden(
			subString: NSMutableAttributedString( string: subString ) as NSMutableAttributedString,
			withFontSizeOf: fontSize,
			between: indices[ 0 ],
			and: indices[ 1 ] )
	}
	
	public static func getFileName ( from url: String ) -> String? {
		guard let slashIndex = getLastIndexOf( subString: FZCharConsts.slash, inString: url ) else { return nil }
		return getSubStringOf( string: url, between: slashIndex + 1, and: url.count )
	}
	
	// returns the first index of the given substring, or nil if it cannot be found
	public static func getIndexOf ( subString: String, inString string: String, startingAt startIndex: Int? = 0 ) -> Int? {
		let
		count = string.count,
		shortenedRange = string.index( string.startIndex, offsetBy: startIndex! ) ..< string.index( string.startIndex, offsetBy: count ),
		shortenedValue = String( string.suffix( from: shortenedRange.lowerBound ) ),
		range = shortenedValue.range( of: subString )
		return range != nil ?
			shortenedValue.distance( from: shortenedValue.startIndex, to: range!.lowerBound ) + startIndex! :
			nil
	}
	
	// returns a Range from the String, or nil where "start" and "end" are invalid indices
	public static func getIndexRangeOf (
		string: String,
		between startIndex: Int,
		and endIndex: Int ) -> Range < String.Index >? {
		let range = _getRangeFrom( string: string, between: startIndex, and: endIndex )
		return range != nil ? string.getRange( From: range! ) : nil
	}
	
	// returns the indices of the given one-char String, or nil if none can be found
	public static func getIndicesOf ( subString: String, inString string: String ) -> [ Int ]? {
		var
		subStringIndex = FZString.getIndexOf( subString: subString, inString: string, startingAt: 0 ),
		indices: [ Int ] = []
		while subStringIndex != nil {
			indices.append( subStringIndex! )
			subStringIndex = FZString.getIndexOf(
				subString: subString,
				inString: string,
				startingAt: subStringIndex! + 1 )
		}
		return indices.count > 0 ? indices : nil
	}
	
	// returns the last index of the given substring, or nil if it cannot be found
	public static func getLastIndexOf ( subString: String, inString string: String ) -> Int? {
		var
		indexOf = getIndexOf( subString: subString, inString: string ),
		lastIndexOf: Int?
		while indexOf != nil {
			lastIndexOf = indexOf
			indexOf = getIndexOf( subString: subString, inString: string, startingAt: indexOf! + 1 )
		}
		return lastIndexOf
	}
	
	
	// returns a subString from the given string, or nil where "start" and "end" are invalid indices
	public static func getSubStringOf ( string: String, between startIndex: Int, and endIndex: Int ) -> String? {
		return string.containsEmojis ?
			_getSubStringByScalarsFrom( string: string, between: startIndex, and: endIndex ) :
			_getSubStringOf( string: string, between: startIndex, and: endIndex )
	}
	
	// checks to see if a char is alphabetic (includes accented Roman chars)
	public static func isChar ( alphabetic char: String ) -> Bool {
		guard
			char.count == 1,
			let unichar = UnicodeScalar( char )
			else { return false }
		return CharacterSet.letters.contains( unichar )
	}
	
	// checks to see if a char is alphanumeric (includes accented Roman chars)
	public static func isChar ( alphanumeric char: String ) -> Bool {
		return isChar( alphabetic: char ) || isChar( numeric: char )
	}
	
	// checks to see if a char is numeric
	public static func isChar ( numeric char: String ) -> Bool {
		guard
			char.count == 1,
			let unichar = UnicodeScalar( char )
			else { return false }
		return CharacterSet.decimalDigits.contains( unichar )
	}
	
	// removes instances of the given substring from the given string
	public static func removeInstancesOf ( subString: String, from string: String ) -> String {
		let countSubString = subString.count
		var
		newValue = string,
		subStringIndex = getIndexOf( subString: subString, inString: newValue )
		// while there is at least one index of the substring remaining, cut it out of the string
		while subStringIndex != nil {
			newValue = "\( String( describing: getSubStringOf( string: newValue, between: 0, and: subStringIndex! ) ) )\( String( describing: getSubStringOf( string: newValue, between: subStringIndex! + countSubString, and: newValue.count ) ) )"
			subStringIndex = getIndexOf( subString: subString, inString: newValue )
		}
		return newValue
	}
	
	// removes instances of the given substring from the given string with the new substring
	public static func replaceInstancesOf (
		subString oldSubString: String,
		with newSubString: String,
		inString string: String
		) -> String {
		let countOldSubString = oldSubString.count
		var
		newValue = string,
		oldSubStringIndex = getIndexOf( subString: oldSubString, inString: newValue )
		// while there is at least one index of the old substring remaining, replace it with the new one
		while oldSubStringIndex != nil {
			newValue = "\( String( describing: getSubStringOf( string: newValue, between: 0, and: oldSubStringIndex! ) ) )\( newSubString )\( String( describing: getSubStringOf( string: newValue, between: oldSubStringIndex! + countOldSubString, and: newValue.count ) ) )"
			oldSubStringIndex = getIndexOf( subString: oldSubString, inString: newValue )
		}
		return newValue
	}
	
	public static func serialise ( params: Dictionary< String, String > ) -> String? {
		var
		serialisedParams = FZCharConsts.openSquareBracket,
		countValues: Int
		// iterate through params collection
		for ( key, value ) in params {
			// split into arrays in case there are any comma-delineated values
			let values = value.split { $0 == "," }.map { String( $0 ) }
			countValues = values.count
			// iterate through the array and build the serialised param string
			_ = values.map { element in serialisedParams = "\( serialisedParams )\( FZCharConsts.doubleQuote )\( key )\( FZCharConsts.doubleQuote )\( FZCharConsts.colon )\( FZCharConsts.space ) \( FZCharConsts.doubleQuote )\( element )\( FZCharConsts.doubleQuote )\( FZCharConsts.comma )\( FZCharConsts.space )" }
		}
		// knock off trailing ampersand and return
		countValues = serialisedParams.count
		guard countValues > 0 else { return nil }
		serialisedParams = String( serialisedParams.prefix( upTo: serialisedParams.index(
			serialisedParams.startIndex,
			offsetBy: countValues - 2 ) ) )
		return "\( serialisedParams )\( FZCharConsts.closedSquareBracket )"
	}
	
	public static func serialise ( array: [ Any ]?, withSeparator separator: String? = " " ) -> String? {
		guard array != nil else { return nil }
//		let countValues = values.count
		var result = FZCharConsts.emptyString
		// serialise first value
		if array!.count > 0 { result = "\( array![ 0 ] )" }
		// loop through rest serialising then adding them
		_ = array!.map { element in result = "\( result )\( String( describing: separator ) )\( element )" }
		return result
	}
	
	public static func serialise ( value: Any? ) -> String? {
		guard let value = value else { return nil }
		// only arrays need special treatment...
		let values = value as? [ Any ]
		return values != nil ? serialise( array: values ) : "\( value )"
	}
	
	public static func setFontSizeFor (
		string: NSMutableAttributedString,
		of fontSize: CGFloat
		) -> NSMutableAttributedString {
		string.addAttributes(
			[ NSAttributedStringKey.font: UIFont.systemFont( ofSize: fontSize ) ],
			range: NSMakeRange( 0, string.mutableString.length )
		)
		return string
	}
	
	public static func setFontSizeFor ( string: String, of fontSize: CGFloat ) -> NSMutableAttributedString {
		return setFontSizeFor( string: NSMutableAttributedString( string: string ), of: fontSize )
	}
	
	public static func set ( length newLength: Int, ofText string: String ) -> String? {
		var adjustedString: String? = string
		switch true {
		// if the new length is shorter, just shorten it...
		case adjustedString!.count > newLength:
			adjustedString = getSubStringOf( string: string, between: 0, and: newLength )
		// ...otherwise keep adding a space to the end until the new length is reached
		case adjustedString!.count < newLength:
			let space = FZCharConsts.space
			while adjustedString!.count < newLength { adjustedString = "\( adjustedString! )\( space )" }
		default: ()
		}
		return adjustedString
	}
	
	public static func simplify ( description: String ) -> String? {
		guard
			let lessThanIndex = getIndexOf( subString: FZCharConsts.lessThan, inString: description ) as Int?,
			lessThanIndex > -1,
			let colonIndex = getIndexOf( subString: FZCharConsts.colon, inString: description ),
			let simplifiedString = getSubStringOf( string: description, between: lessThanIndex + 1, and: colonIndex )
			else { return nil }
		return simplifiedString
	}
	
	public static func split ( string: String, withSplitter splitter: String ) -> [ String ] {
		// split the string if the splitter exists in the string...
		return getIndexOf( subString: splitter, inString: string ) != nil ?
			string.components( separatedBy: CharacterSet( charactersIn: splitter ) ) :
			[ string ]
	}
	
	public static func tint (
		subString: NSMutableAttributedString,
		withColor color: UIColor,
		between startIndex: Int,
		and endIndex: Int
		) -> NSMutableAttributedString? {
		// we can only tint the string if the start and end indices are valid
		if let range = _getRangeFrom( attributedText: subString, between: startIndex, and: endIndex ) {
			subString.addAttribute(
				NSAttributedStringKey.foregroundColor,
				value: color,
				range: range )
			return subString
		} else {
			return nil
		}
	}
	
	public static func tint (
		subString: String,
		withColor color: UIColor,
		between startIndex: Int,
		and endIndex: Int ) -> NSMutableAttributedString? {
		// ordinary Strings cannot be tinted, so attribute it and pass it on to the other tinting function
		return tint(
			subString: NSMutableAttributedString( string: subString ) as NSMutableAttributedString,
			withColor: color,
			between: startIndex,
			and: endIndex )
	}
	
	public static func translate ( intToText number: Int ) -> String? {
		guard number > 9 else { return self._translate( singleDigitInt: number ) }
		guard number > 99 else { return self._translate( doubleDigitInt: number ) }
		let
		serialisedNumber = "\( number )",
		countIntChars = serialisedNumber.count
		guard countIntChars < 5 else { fatalError( "CLAUSE NEEDS WRITING FOR THIS NUMBER" ) }
		let countIntCharsMinusTwo = countIntChars - 2
		var value = FZCharConsts.emptyString
		
		for i in 0..<countIntCharsMinusTwo {
			if  let substring = getSubStringOf( string: serialisedNumber, between: i, and: i + 1 ),
				let int = Int( substring ),
				int > 0 {
				switch countIntChars - i {
				case 4:		value = "\( value )\( String( describing: _translate( singleDigitInt: int ) ) ) thousand, "
				case 3:		value = "\( value )\( String( describing: _translate( singleDigitInt: int ) ) ) hundred, "
				default:	()
				}
			}
		}
		// remove last comma
		value = getSubStringOf( string: value, between: 0, and: value.count - 2 )!
		guard
			let lastIntAsString = getSubStringOf( string: serialisedNumber, between: countIntChars - 2, and: countIntChars ),
			let lastInt = Int( lastIntAsString ),
			lastInt > 0
		else { return nil }
		// add "and"
		value = "\( value ) and "
		return lastInt < 10 ?
			"\( value )\( String( describing: _translate( singleDigitInt: lastInt ) ) )" :
			"\( value )\( String( describing: _translate( doubleDigitInt: lastInt ) ) )"
	}
	
	// just removing empty space from beginning and end of strings
	public static func trim ( string: String ) -> String {
		return string.trimmingCharacters( in: CharacterSet.whitespacesAndNewlines )
	}
	
	public static func underline (
		subString: NSMutableAttributedString,
		between startIndex: Int,
		and endIndex: Int
		) -> NSMutableAttributedString? {
		// we can only underline the string if the start and end indices are valid
		if let range = _getRangeFrom( attributedText: subString, between: startIndex, and: endIndex ) {
			subString.addAttribute(
				NSAttributedStringKey.underlineStyle,
				value: NSUnderlineStyle.styleSingle.rawValue,
				range: range )
			return subString
		} else {
			return nil
		}
	}
	
	public static func underline ( subString: String, between startIndex: Int, and endIndex: Int ) -> NSMutableAttributedString? {
		// ordinary Strings cannot be underlined, so attribute it and pass it on to the other underlining function
		return underline(
			subString: NSMutableAttributedString( string: subString ) as NSMutableAttributedString,
			between: startIndex,
			and: endIndex )
	}
	
	
	
	fileprivate static func _getIndicesFrom (
		subString: NSMutableAttributedString,
		startIndex: Int?,
		andEndIndex endIndex: Int? ) -> [ Int ] {
		return [
			startIndex != nil ? startIndex! : 0,
			endIndex != nil ? endIndex! : subString.length ]
	}
	
	fileprivate static func _getIndicesFrom (
		subString: String,
		startIndex: Int?,
		andEndIndex endIndex: Int? ) -> [ Int ] {
		return [
			startIndex != nil ? startIndex! : 0,
			endIndex != nil ? endIndex! : subString.count ]
	}
	
	fileprivate static func _getRangeFrom (
		attributedText: NSMutableAttributedString,
		between startIndex: Int,
		and endIndex: Int ) -> NSRange? {
		// attributed Strings cannot be used to find ranges,
		// so normalise it and pass it on to the other range-finding function
		return _getRangeFrom( string: attributedText.string, between: startIndex, and: endIndex )
	}
	
	fileprivate static func _getRangeFrom ( string: String, between startIndex: Int, and endIndex: Int ) -> NSRange? {
		// only return a range if the passed indices are valid
		return startIndex < endIndex && startIndex > -1 && endIndex <= string.count ?
			NSMakeRange( startIndex, endIndex - startIndex ) :
			nil
	}
	
	fileprivate static func _getSubStringOf ( string: String, between startIndex: Int, and endIndex: Int ) -> String? {
		// only return a range if the passed indices are valid
		guard let range = getIndexRangeOf( string: string, between: startIndex, and: endIndex ) else { return nil }
		return String( string[ range ] )
	}
	
	// this method of getting substrings ensures that emojis are treated as individual chars
	fileprivate static func _getSubStringByScalarsFrom (
		string: String,
		between startIndex: Int,
		and endIndex: Int ) -> String {
		// runs through scalars scalar-by-scalar building the phrase
		var
		index = 0,
		subStringByScalars = FZCharConsts.emptyString
		for scalar in string.unicodeScalars {
			// keep skipping scalars until we get to the desired start index,
			// then progressively add each char until we reach the end of the phrase
			if index >= startIndex { subStringByScalars = "\( subStringByScalars )\( String( scalar ) )" }
			if index == endIndex { break }
			index += 1
		}
		//	lo( "subStringByScalars: <<<\( subStringByScalars )>>>" )
		return subStringByScalars
	}
	
	fileprivate static func _translate ( doubleDigitInt number: Int ) -> String? {
		guard number > 9, number < 100 else {
			fatalError( "doubleDigitInt has a number of digits that does not equal two" )
		}
		let teen = "teen"
		switch number {
		case 10:			return "ten"
		case 11:			return "eleven"
		case 12:			return "twelve"
		case 13:			return "thir\( teen )"
		case 15:			return "fif\( teen )"
		case 18:			return "eigh\( teen )"
		default:
			let serialisedNumber = "\( number )"
			guard
				let firstDigitAsString = getSubStringOf( string: serialisedNumber, between: 0, and: 1 ),
				let firstDigit = Int( firstDigitAsString ),
				let secondDigitAsString = getSubStringOf( string: serialisedNumber, between: 1, and: 2 ),
				let secondDigit = Int( secondDigitAsString ),
				let secondDigitString = _translate( singleDigitInt: secondDigit )
			else { return nil }
			if firstDigit == 1 {
				return "\( secondDigitString )teen"
			} else {
				let
				ty = "ty",
				secondDigitSuffix = secondDigit > 0 ? "\( FZCharConsts.hyphen )\( secondDigitString )" : ""
				switch firstDigit {
				case 2:		return "twen\( ty )\( secondDigitSuffix )"
				case 3:		return "thir\( ty )\( secondDigitSuffix )"
				case 4:		return "for\( ty )\( secondDigitSuffix )"
				case 5:		return "fif\( ty )\( secondDigitSuffix )"
				case 8:		return "eigh\( ty )\( secondDigitSuffix )"
				default:	return "\( String( describing: _translate( singleDigitInt: firstDigit ) ) )\( ty )\( secondDigitSuffix )"
				}
			}
		}
	}
	
	fileprivate static func _translate ( singleDigitInt number: Int ) -> String? {
		guard number > -1, number < 10 else { return nil }
		switch number {
		case 1:		return "one"
		case 2:		return "two"
		case 3:		return "three"
		case 4:		return "four"
		case 5:		return "five"
		case 6:		return "six"
		case 7:		return "seven"
		case 8:		return "eight"
		case 9:		return "nine"
		default:	return "zero"
		}
	}
}
