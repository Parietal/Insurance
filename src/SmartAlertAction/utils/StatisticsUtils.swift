//
//  StatisticsUtils.swift
//  SmartAlertAction
//
//  Created by QiangRen on 11/10/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class StatisticsUtils {

    class func percentile(value:Double, sorted_array:[Double]) -> UInt {
        var n:Double = Double(sorted_array.count)
        assert(n > 0, "sorted_array must not be empty")
        var b:Double = 0 // less than value
        var e:Double = 0 // equal to value
        for v in sorted_array {
            if (v < value) {
                b++
            } else if (v == value) {
                e++
            } else {
                break
            }
        }
        return UInt((b + 0.5 * e) / n * 100)
    }

}
