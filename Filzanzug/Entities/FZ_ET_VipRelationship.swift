//
//  FZ_ET_VipRelationship.swift
//  Filzanzug
//
//  Created by Richard Willis on 13/03/2018.
//

// todo a bunch more files can be made internal, no?
internal struct FZVipRelationship {
	let
	viewControllerType: FZViewControllerProtocol.Type,
	interactorType: FZInteractorProtocol.Type,
	presenterType: FZPresenterProtocol.Type,
	interactorDependencyTypes: [ FZModelClassProtocol.Type ]?
}

