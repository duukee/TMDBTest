//
//  Dictionary+Merge.swift
//  DXCmoviesApp
//
//  Created by Alex Zaragoza Chazarra on 6/11/21.
//

import Foundation
public func + <KeyType, ValueType> (left: [KeyType: ValueType], right: [KeyType: ValueType]) -> [KeyType: ValueType] {
  var out = left

  for (k, v) in right {
    out.updateValue(v, forKey: k)
  }

  return out
}
