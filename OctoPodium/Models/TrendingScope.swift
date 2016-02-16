//
//  TrendingScope.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 31/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

enum TrendingScope: String {
    
    case Day = "Daily"
    case Week = "Weekly"
    case Month = "Monthly"
   
    static let enumerateElements: [TrendingScope] = [Day, Week, Month]
    
    var message: String {
        switch self {
        case .Day: return "Today"
        case .Week: return "This week"
        case .Month: return "This month"
        }
    }
}