//
//  FZ_EX_UnicodeScalar.swift
//  Filzanzug
//
//  Created by Richard Willis on 14/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

extension UnicodeScalar {
	// tell us whethere the scalar in question is an emoji or not, but examining it's value against known emoji ranges
	// from: stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
	var isEmoji: Bool {
		switch value
		{
		case 0x3030, 0x00AE, 0x00A9, // Special Characters
		0x1D000 ... 0x1F77F, // Emoticons
		0x2100 ... 0x27BF, // Misc symbols and Dingbats
		0xFE00 ... 0xFE0F, // Variation Selectors
		0x1F900 ... 0x1F9FF: // Supplemental Symbols and Pictographs
			return true
			
		default: return false
		}
	}
}
