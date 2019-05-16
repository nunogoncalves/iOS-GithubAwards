//
//  Helpers.swift
//  OctoPodiumTests
//
//  Created by Nuno Gonçalves on 15/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation

func waitSync(for timeInterval: TimeInterval) {
    RunLoop.main.run(until: Date(timeIntervalSinceNow: timeInterval))
}
