//
//  FZ_PT_ET_Image.swift
//  Filzanzug
//
//  Created by Richard Willis on 28/09/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

public protocol FZImageEntityProtocol {
	func getImageProxyBy ( key: String ) -> FZImageProxy?
	func set ( imageProxy: FZImageProxy )
}
