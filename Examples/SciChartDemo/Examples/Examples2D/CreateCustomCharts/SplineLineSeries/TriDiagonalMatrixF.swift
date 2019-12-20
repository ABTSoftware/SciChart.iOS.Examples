//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// TriDiagonalMatrixF.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class TriDiagonalMatrixF {
    public var A : [Float]
    public var B : [Float]
    public var C : [Float]
    
    public init(_ n: Int) {
        A = [Float](repeating: 0, count: n)
        B = [Float](repeating: 0, count: n)
        C = [Float](repeating: 0, count: n)
    }
    
    public func solve(_ d : [Float]) -> [Float] {
        let n : Int = A.count;
        
        if (d.count != n) {
            return [Float]()
        }
        
        // cPrime
        var cPrime : [Float] = [Float](repeating:0, count:n);
        cPrime[0] = C[0] / B[0];
        
        for i in 1 ..< n {
            cPrime[i] = C[i] / (B[i] - cPrime[i - 1] * A[i]);
        }
        
        // dPrime
        var dPrime : [Float] = [Float](repeating:0, count:n);
        dPrime[0] = d[0] / B[0];
        
        for i in 1 ..< n {
            dPrime[i] = (d[i] - dPrime[i - 1] * A[i]) / (B[i] - cPrime[i - 1] * A[i]);
        }
        
        // Back substitution
        var x : [Float] = [Float](repeating:0, count:n);
        x[n - 1] = dPrime[n - 1];
        
        for i in (0...n-2).reversed() {
            x[i] = dPrime[i] - cPrime[i] * x[i + 1];
        }
        
        return x;
    }
}
