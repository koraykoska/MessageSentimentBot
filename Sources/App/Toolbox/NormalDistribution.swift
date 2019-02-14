//
//  NormalDistribution.swift
//  App
//
//  Created by Koray Koska on 15.02.19.
//

import Foundation

let standardNormalDistribution:(Double) -> Double = normalDistribution(μ: 0.0, σ: 1.0)

func ø(x:Double) -> Double {
    return standardNormalDistribution(x)
}

func normalDistribution(μ: Double, σ: Double) -> (_ x:Double) -> Double {
    return { x in
        let a = exp(-1 * pow(x - μ, 2) / (2 * pow(σ,2)))
        let b = σ * sqrt(2 * Double.pi)
        return a / b
    }
}
