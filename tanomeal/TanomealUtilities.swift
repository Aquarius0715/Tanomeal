//
//  TanomealUtilities.swift
//  tanomeal
//
//  Created by 北野正樹 on 2022/08/20.
//

import Foundation


struct TanomealUtilities {
    public func getDomain(mailAddress: String) -> String {
        let result = mailAddress.range(of: "@")
        var afterStr = ""
        if let theRange = result {
            afterStr = mailAddress[theRange.upperBound...].description
        }
        return afterStr
    }
}
