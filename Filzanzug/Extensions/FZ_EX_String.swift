//
//  FZ_EX_String.swift
//  Filzanzug
//
//  Created by Richard Willis on 14/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

extension String {
	// lots of ways of identifying and measuring emojis in Strings
	// from: stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
	var containsEmojis: Bool { return !unicodeScalars.filter{ $0.isEmoji }.isEmpty }
	
	// from: stackoverflow.com/questions/25138339/nsrange-to-rangestring-index#26517690
	func getRange ( From nsRange: NSRange ) -> Range< String.Index >? {
		guard
			let from16 = utf16.index( utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex ),
			let to16 = utf16.index( from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex ),
			let from = from16.samePosition( in: self ),
			let to = to16.samePosition( in: self )
			else { return nil }
		return from ..< to
	}
}
