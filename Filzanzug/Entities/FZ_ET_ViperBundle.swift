//
//  FZ_ET_ViperBundle.swift
//  Filzanzug
//
//  Created by Richard Willis on 27/07/2018.
//

internal struct FZViperBundle: FZDeallocatableProtocol {
	var
	viewController: FZViewController?,
	interactor: FZInteractorProtocol?,
	presenter: FZPresenterProtocol?
	
	mutating func deallocate() {
		viewController?.removeFromParentViewController()
//		presenter_?.checkIn()
		// todo see note on checkIn in FZPresenterProtocol
		interactor?.deallocate()
		presenter?.deallocate()
		viewController?.deallocate()
		interactor = nil
		presenter = nil
		viewController = nil
	}
}
