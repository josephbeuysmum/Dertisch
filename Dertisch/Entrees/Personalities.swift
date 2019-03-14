//
//  Personalities.swift
//  Dertisch
//
//  Created by Richard Willis on 14/03/2019.
//

public struct CustomerPersonality {
	let forSeat: CustomerForSeat.Type
	let forMaitreD: CustomerForMaitreD.Type
	let forSommelier: CustomerForSommelier.Type
	let forWaiter: CustomerForWaiter.Type?
}

public struct WaiterPersonality {
	let forCustomer: WaiterForCustomer.Type?
	let forHeadChef: WaiterForHeadChef.Type?
}

public struct HeadChefPersonality {
	let forWaiter: HeadChefForWaiter.Type?
	let forSousChef: HeadChefForSousChef.Type?
}
