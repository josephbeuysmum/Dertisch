//
//  FZCoreDataProxyTests.swift
//  DertischTests
//
//  Created by Richard Willis on 22/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

// I may be completely wrong about this, but it seems that unit tests on code that contains references to NSPersistentContainer instances in a Cocoa Touch Framework project (like this) cannot be run as the unit test framework is incapable of finding the DB.xcdatamodeld file it needs to establish a DB connection. Keeping this file for now solely as a note of this problem.
