//
//  FZ_ET_CL_ModelClassEntities.swift
//  Filzanzug
//
//  Created by Richard Willis on 03/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

extension FZModelClassEntities: FZModelClassEntitiesCollectionProtocol {
	public var bespokeRail: FZBespokeEntities { return bespoke_entities! }
	public var localAccess: FZLocalAccessProxy? { return local_access }
	public var urlSession: FZUrlSessionService? { return url_session }
	
	public func deallocate () {
		bespoke_entities?.deallocate()
		local_access?.deallocate()
		url_session?.deallocate()
		bespoke_entities = nil
		local_access = nil
		url_session = nil
	}
}

public class FZModelClassEntities {
	fileprivate var
	local_access: FZLocalAccessProxy?,
	url_session: FZUrlSessionService?
	
	fileprivate lazy var bespoke_entities: FZBespokeEntities? = FZBespokeEntities()
	
	public required init ( localAccess: FZLocalAccessProxy? = nil, urlSession: FZUrlSessionService? = nil ) {
		local_access = localAccess
		url_session = urlSession
	}
}
