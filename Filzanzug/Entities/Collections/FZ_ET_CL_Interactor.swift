//
//  FZ_ET_CL_InteractorEntities.swift
//  Filzanzug
//
//  Created by Richard Willis on 03/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

extension FZInteractorEntities: FZInteractorEntitiesCollectionProtocol {}

public class FZInteractorEntities {
	fileprivate let key: String
	
	fileprivate var
	image: FZImageProxy?,
	presenter: FZPresenterProtocol?
	
	
	
	public init ( _ key: String ) { self.key = key }
	
	
	
	public func deallocate () {
		image = nil
		presenter = nil
	}
	
	public func getImageProxyBy ( key: String ) -> FZImageProxy? { return key == self.key ? image : nil }
	
	public func getPresenterBy ( key: String ) -> FZPresenterProtocol? { return key == self.key ? presenter : nil }
	
	public func set ( imageProxy: FZImageProxy ) {
		guard image == nil else { return }
		image = imageProxy
	}
	
	public func set ( presenter: FZPresenterProtocol ) {
		guard self.presenter == nil else { return }
		self.presenter = presenter
	}
}
