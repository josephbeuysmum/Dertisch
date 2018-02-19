//
//  FZ_PT_ET_WO_Presenter.swift
//  Hasenblut
//
//  Created by Richard Willis on 28/09/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

public protocol FZPresenterEntityProtocol {
	func getPresenterBy ( key: String ) -> FZPresenterProtocol?
	func set ( presenter: FZPresenterProtocol )
}
