//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CubicSpline.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class CubicSpline {
    var a: [Float]
    var b: [Float]
    
    var xOrig: [Float]
    var yOrig: [Float]
    
    var _lastIndex: Int = 0
    
    init() {
        a = [Float]()
        b = [Float]()
        xOrig = [Float]()
        yOrig = [Float]()
    }
    
    func fitAndEval(x: [Float], y: [Float], xs: [Float], startSlope: Float, endSlope: Float) -> SCIFloatValues {
        fit(x: x, y: y, startSlope: startSlope, endSlope: endSlope);
        return eval(x: xs);
    }
    
    private func fit(x: [Float], y: [Float], startSlope: Float, endSlope: Float) -> Void {
        // Save x and y for eval
        self.xOrig = x;
        self.yOrig = y;
        
        let n: Int = x.count
        var r: [Float] = [Float](repeating:0, count:n)
        
        let m: TriDiagonalMatrixF = TriDiagonalMatrixF(Int(n));
        var dx1: Float, dx2: Float, dy1: Float, dy2: Float;
        
        // First row is different (equation 16 from the article)
        if (startSlope.isNaN) {
            dx1 = x[1] - x[0];
            m.C[0] = 1.0 / dx1;
            m.B[0] = 2.0 * m.C[0];
            r[0] = 3 * (y[1] - y[0]) / (dx1 * dx1);
        } else {
            m.B[0] = 1;
            r[0] = startSlope;
        }
        
        // Body rows (equation 15 from the article)
        for i in 1..<n-1 {
            dx1 = x[i] - x[i - 1];
            dx2 = x[i + 1] - x[i];
            
            m.A[i] = 1.0 / dx1;
            m.C[i] = 1.0 / dx2;
            m.B[i] = 2.0 * (m.A[i] + m.C[i]);
            
            dy1 = y[i] - y[i - 1];
            dy2 = y[i + 1] - y[i];
            r[i] = 3 * (dy1 / (dx1 * dx1) + dy2 / (dx2 * dx2));
        }
        
        // Last row also different (equation 17 from the article)
        if (endSlope.isNaN) {
            dx1 = x[n - 1] - x[n - 2];
            dy1 = y[n - 1] - y[n - 2];
            m.A[n - 1] = 1.0 / dx1;
            m.B[n - 1] = 2.0 * m.A[n - 1];
            r[n - 1] = 3 * (dy1 / (dx1 * dx1));
        } else {
            m.B[n - 1] = 1;
            r[n - 1] = endSlope;
        }
        
        // k is the solution to the matrix
        let k : [Float] = m.solve(r);
        
        // a and b are each spline's coefficients
        self.a = [Float](repeating:0, count:n-1);
        self.b = [Float](repeating:0, count:n-1);
        
        for i in 1..<n {
            dx1 = x[i] - x[i - 1];
            dy1 = y[i] - y[i - 1];
            a[i - 1] = k[i - 1] * dx1 - dy1; // equation 10 from the article
            b[i - 1] = -k[i] * dx1 + dy1; // equation 11 from the article
        }
    }
    
    private func eval(x : [Float]) -> SCIFloatValues {
        let n = x.count
        let y = SCIFloatValues(capacity: n)
        
        _lastIndex = 0 // Reset simultaneous traversal in case there are multiple calls
        
        for i in 0 ..< n {
            // Find which spline can be used to compute this x (by simultaneous traverse)
            let j = getNextXIndex(x[i])
            // Evaluate using j'th spline
            let yValue = evalSpline(x: x[i], j: j)
            y.add(yValue)
        }
        return y
    }
    
    private func getNextXIndex(_ x: Float) -> Int {
        while ((_lastIndex < xOrig.count - 2) && (x > xOrig[_lastIndex + 1])) {
            _lastIndex = _lastIndex + 1;
        }
        return _lastIndex;
    }
    
    private func evalSpline(x : Float, j : Int) -> Float {
        let dx: Float = xOrig[j + 1] - xOrig[j];
        let t: Float = (x - xOrig[j]) / dx;
        let y: Float = (1 - t) * yOrig[j] + t * yOrig[j + 1] + t * (1 - t) * (a[j] * (1 - t) + b[j] * t); // equation 9
        return y;
    }
}
