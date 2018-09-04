//
//  FZ_PT_VP_ViewController.swift
//  Filzanzug
//
//  Created by Richard Willis on 12/11/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

public protocol FZViewControllerProtocol: class, FZSignalReceivableProtocol {//}, FZSignalsEntitySetterProtocol {
	func set(_ signals: FZSignalsService, and presenter: FZPresenterProtocol)
}
