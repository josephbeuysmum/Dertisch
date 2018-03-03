//
//  FZ_ET_CL_ModelClassEntities.swift
//  Filzanzug
//
//  Created by Richard Willis on 03/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

extension FZModelClassEntities: FZModelClassEntitiesCollectionProtocol {}

public class FZModelClassEntities {
	public var localAccess: FZLocalAccessProxy? { return _localAccess }
	public var urlSession: FZUrlSessionService? { return _urlSession }
	
	fileprivate var
	_localAccess: FZLocalAccessProxy?,
	_urlSession: FZUrlSessionService?
	
	
	
	public required init ( localAccess: FZLocalAccessProxy? = nil, urlSession: FZUrlSessionService? = nil ) {
		_localAccess = localAccess
		_urlSession = urlSession
	}
	
	public func deallocate () {
		_localAccess = nil
		_urlSession = nil
	}
}
