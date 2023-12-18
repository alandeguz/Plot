//
//  String.swift
//
//
//  Created by Alan DeGuzman on 12/18/23.
//

import Foundation

extension String {
    
    // adds a trailing slash to a Path if it's a directory (not a *.*)
     func addSlash() -> String {
        let testString = self.components(separatedBy: "/").last ?? self
        if testString.components(separatedBy: ".").count == 1 {
            return self + "/"
        }
        return self
    }
    
}
