//
//  DT_EX_Data.swift
//  Dertisch
//
//  Created by Richard Willis on 11/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import Foundation

// taken from Dmitry Isaev at https://stackoverflow.com/questions/21789770/determine-mime-type-from-nsdata#32765708
extension Data {
	enum mimeTypes: String {
		case AVI, BMP, GIF, JPG, MP3, OCT, OGG, PDF, PNG, /*RAR,*/ RTF, TAR, TIFF, /*TXT,*/ VND, /*WAV,*/ XML, ZIP
	}

	var mimeType: Data.mimeTypes {
		var c: UInt8 = 0
		copyBytes(to: &c, count: 1)
		return Data.mimeTypeSignatures[c] ?? mimeTypes.OCT
	}
	
	
	
	// todo check these are correct, distinguish between clashing MIMEs like 0x52
	// see: https://en.wikipedia.org/wiki/List_of_file_signatures
	private static let mimeTypeSignatures: [UInt8: Data.mimeTypes] = [
		0x1F: Data.mimeTypes.TAR,
		0x25: Data.mimeTypes.PDF,
		0x3C: Data.mimeTypes.XML,
		0x46: Data.mimeTypes.BMP,
//		0x46: Data.mimeTypes.TXT,
		0x47: Data.mimeTypes.GIF,
		0x49: Data.mimeTypes.MP3,
//		0x49: Data.mimeTypes.TIFF,
		0x4D: Data.mimeTypes.TIFF,
		0x4F: Data.mimeTypes.OGG,
		0x50: Data.mimeTypes.ZIP,
//		0x52: Data.mimeTypes.RAR,
//		0x52: Data.mimeTypes.WAV,
		0x75: Data.mimeTypes.TAR,
		0x7B: Data.mimeTypes.RTF,
		0x89: Data.mimeTypes.PNG,
		0xD0: Data.mimeTypes.VND,
		0xFF: Data.mimeTypes.JPG
	]
}
