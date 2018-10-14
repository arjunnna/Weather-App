//
//  StringExtensions.swift
//  Weather
//
//  Created by Mallikarjuna Chilakala on 10/14/18.
//


import Foundation

/// Extensions to the String class.
extension String {
 
    /**
     Returns an URL encoded string of this string.
     
     - returns: String that is an URL-encoded representation of this string.
     */
    public var urlEncoded: String? {
        get {
            return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        }
    }

}




