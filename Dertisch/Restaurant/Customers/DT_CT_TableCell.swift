//
//  DT_TableCell.swift
//  Dertisch
//
//  Created by Richard Willis on 27/07/2018.
//

import UIKit

//public protocol RestaurantTableViewCellProtocol: class {}//, DTServeCustomerProtocol {}

open class RestaurantTableViewCell: UITableViewCell {//}, RestaurantTableViewCellProtocol {
	// todo make this a serve(entrees)
	open func serve<T>(with data: T?) {}
}
