//  File name   : FwiFormParam.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 12/3/14
//  --------------------------------------------------------------
//  Copyright © 2012, 2018 Fiision Studio. All Rights Reserved.
//  --------------------------------------------------------------
//
//  Permission is hereby granted, free of charge, to any person obtaining  a  copy
//  of this software and associated documentation files (the "Software"), to  deal
//  in the Software without restriction, including without limitation  the  rights
//  to use, copy, modify, merge,  publish,  distribute,  sublicense,  and/or  sell
//  copies of the Software,  and  to  permit  persons  to  whom  the  Software  is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF  ANY  KIND,  EXPRESS  OR
//  IMPLIED, INCLUDING BUT NOT  LIMITED  TO  THE  WARRANTIES  OF  MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO  EVENT  SHALL  THE
//  AUTHORS OR COPYRIGHT HOLDERS  BE  LIABLE  FOR  ANY  CLAIM,  DAMAGES  OR  OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING  FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN  THE
//  SOFTWARE.
//
//
//  Disclaimer
//  __________
//  Although reasonable care has been taken to  ensure  the  correctness  of  this
//  software, this software should never be used in any application without proper
//  testing. Fiision Studio disclaim  all  liability  and  responsibility  to  any
//  person or entity with respect to any loss or damage caused, or alleged  to  be
//  caused, directly or indirectly, by the use of this software.

import Foundation

struct FwiFormParam {
    // MARK: Class's constructors
    public init(key: String = "", value: String = "") {
        self.key = key
        self.value = value
    }

    // MARK: Class's properties
    public private(set) var key: String
    public private(set) var value: String

    // MARK: Struct's private methods
    public var hashValue: Int {
        return key.hashValue ^ value.hashValue
    }
}

// MARK: CustomStringConvertible's members
extension FwiFormParam: CustomStringConvertible {
    public var description: String {
        if key[0] == "#" {
            return "#\(key.substring(startIndex: 1).encodeHTML())=\(value.encodeHTML())"
        }
        return "\(key.encodeHTML())=\(value.encodeHTML())"
    }
}

// MARK: Custom Operator
extension FwiFormParam {
    static func < (left: FwiFormParam, right: FwiFormParam) -> Bool {
        if left.key[left.key.startIndex] == "#" && right.key[right.key.startIndex] != "#" {
            return true
        } else if left.key[left.key.startIndex] != "#" && right.key[right.key.startIndex] == "#" {
            return false
        } else if left.key[left.key.startIndex] == "#" && right.key[right.key.startIndex] == "#" {
            let key1 = left.key.substring(startIndex: 1, reverseIndex: 0)
            let key2 = right.key.substring(startIndex: 1, reverseIndex: 0)
            return key1 < key2
        }
        return left.key < right.key
    }

    static func < (left: FwiFormParam, right: FwiFormParam?) -> Bool {
        guard let r = right else {
            return false
        }
        return left < r
    }

    static func == (left: FwiFormParam, right: FwiFormParam) -> Bool {
        return left.hashValue == right.hashValue
    }

    static func == (left: FwiFormParam, right: FwiFormParam?) -> Bool {
        guard let r = right else {
            return false
        }
        return left == r
    }
}
