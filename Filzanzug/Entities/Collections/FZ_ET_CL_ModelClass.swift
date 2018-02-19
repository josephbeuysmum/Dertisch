//
//  FZ_ET_CL_ModelClassEntities.swift
//  Filzanzug
//
//  Created by Richard Willis on 03/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

extension FZModelClassEntities: FZModelClassEntitiesCollectionProtocol {}

public class FZModelClassEntities {
	fileprivate let key: String
	
	fileprivate var
	api: FZUrlSessionService?,
	localAccess: FZLocalAccessProxy?
	
	
	
	public init ( _ key: String ) { self.key = key }
	
	
	
	public func deallocate () {
		api = nil
		localAccess = nil
	}
	
	public func getApiServiceBy ( key: String ) -> FZUrlSessionService? { return key == self.key ? api : nil }
	
	public func getLocalAccessProxyBy ( key: String ) -> FZLocalAccessProxy? { return key == self.key ? localAccess : nil }
	
	public func set ( apiService: FZUrlSessionService ) {
		guard api == nil else { return }
		api = apiService
	}
	
	public func set ( localAccessProxy: FZLocalAccessProxy ) {
		guard localAccess == nil else { return }
		localAccess = localAccessProxy
	}
}
