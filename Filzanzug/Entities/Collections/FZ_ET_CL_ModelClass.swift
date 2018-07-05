//
//  FZ_ET_CL_ModelClassEntities.swift
//  Filzanzug
//
//  Created by Richard Willis on 03/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

extension FZModelClassEntities: FZModelClassEntitiesCollectionProtocol {
	public var bespokeRail: FZBespokeEntities { return bespoke_entities! }
	public var bundledJson: FZBundledJsonService? { return bundled_json }
	public var coreData: FZCoreDataProxy? { return core_data }
	public var urlSession: FZUrlSessionService? { return url_session }
	
	public func deallocate () {
		bundled_json?.deallocate()
		bespoke_entities?.deallocate()
//		core_data?.deallocate()
		url_session?.deallocate()
		bespoke_entities = nil
		core_data = nil
		url_session = nil
	}
	
	public func set(bundledJson newValue: FZBundledJsonService) {
		guard bundled_json == nil else { return }
		bundled_json = newValue
	}
	
	public func set(coreData newValue: FZCoreDataProxy) {
		guard core_data == nil else { return }
		core_data = newValue
	}
	
	public func set(urlSession newValue: FZUrlSessionService) {
		guard url_session == nil else { return }
		url_session = newValue
	}
}

public class FZModelClassEntities {
	fileprivate var
	bundled_json: FZBundledJsonService?,
	core_data: FZCoreDataProxy?,
	url_session: FZUrlSessionService?
	
	fileprivate lazy var bespoke_entities: FZBespokeEntities? = FZBespokeEntities()
}
