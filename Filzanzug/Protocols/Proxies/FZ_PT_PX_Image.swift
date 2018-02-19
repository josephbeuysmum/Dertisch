//
//  FZ_PT_PX_Image.swift
//  Filzanzug
//
//  Created by Richard Willis on 17/02/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import UIKit

public protocol FZImageProxyProtocol: FZModelClassProtocol {
//	func clearStorage ()
	func getImage ( by url: String, block: ( ( String, Any? ) -> Void )? ) -> UIImage?
	func loadImage ( by url: String )
}
