//
//  ShapeType.swift
//  GeometryFighter
//
//  Created by Liudong on 16/5/28.
//  Copyright © 2016年 Liudong. All rights reserved.
//

import Foundation

public enum ShapeType:Int {
    case Box = 0
    case Sphere
    case Pyramid
    case Torus
    case Capsule
    case Cylinder
    case Cone
    case Tube
    
    static func random() ->ShapeType {
        let maxValue = Tube.rawValue
        let rand = arc4random_uniform(UInt32(maxValue + 1))
        
        return ShapeType(rawValue: Int(rand))!
    }
}