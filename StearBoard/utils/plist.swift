//
//  plist.swift
//  StearBoard
//
//  Created by 李毓琪 on 2023/8/16.
//

import Foundation

    
func PlistGetData<T>(_ key: String) -> T {
    return Bundle.main.infoDictionary?[key] as! T
}

