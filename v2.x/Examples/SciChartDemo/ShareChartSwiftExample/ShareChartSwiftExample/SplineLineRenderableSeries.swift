//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SplineLineRenderableSeries.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import SciChart

class TriDiagonalMatrixF {
    public var A : [Double]
    public var B : [Double]
    public var C : [Double]
    
    public init(_ n: Int) {
        A = [Double](repeating: 0, count: n)
        B = [Double](repeating: 0, count: n)
        C = [Double](repeating: 0, count: n)
    }
    
    public func solve(_ d : [Double]) -> [Double] {
        let n : Int = A.count;
    
        if (d.count != n) {
            return [Double]()
        }
    
        // cPrime
        var cPrime : [Double] = [Double](repeating:0, count:n);
        cPrime[0] = C[0] / B[0];
    
        for i in 1 ..< n {
            cPrime[i] = C[i] / (B[i] - cPrime[i - 1] * A[i]);
        }
    
        // dPrime
        var dPrime : [Double] = [Double](repeating:0, count:n);
        dPrime[0] = d[0] / B[0];
    
        for i in 1 ..< n {
            dPrime[i] = (d[i] - dPrime[i - 1] * A[i]) / (B[i] - cPrime[i - 1] * A[i]);
        }
    
        // Back substitution
        var x : [Double] = [Double](repeating:0, count:n);
        x[n - 1] = dPrime[n - 1];
    
        for i in (0...n-2).reversed() {
            x[i] = dPrime[i] - cPrime[i] * x[i + 1];
        }
    
        return x;
    }
}

class CubicSpline {
    var a : [Double]
    var b : [Double]
    
    var xOrig : [Double]
    var yOrig : [Double]
    
    var _lastIndex : Int = 0
    
    init() {
        a = [Double]()
        b = [Double]()
        xOrig = [Double]()
        yOrig = [Double]()
    }
    
    private func fit(x : [Double], y : [Double], startSlope : Double, endSlope : Double) -> Void {
        
        // Save x and y for eval
        self.xOrig = x;
        self.yOrig = y;
        
        let n : Int = x.count
        var r : [Double] = [Double](repeating:0, count:n)
        
        let m : TriDiagonalMatrixF = TriDiagonalMatrixF(Int(n));
        var dx1 : Double, dx2 : Double, dy1 : Double, dy2 : Double;
        
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
        let k : [Double] = m.solve(r);
        
        // a and b are each spline's coefficients
        self.a = [Double](repeating:0, count:n-1);
        self.b = [Double](repeating:0, count:n-1);
        
        for i in 1..<n {
            dx1 = x[i] - x[i - 1];
            dy1 = y[i] - y[i - 1];
            a[i - 1] = k[i - 1] * dx1 - dy1; // equation 10 from the article
            b[i - 1] = -k[i] * dx1 + dy1; // equation 11 from the article
        }
    }
    
    private func getNextXIndex(_ x : Double) -> Int {
        while ((_lastIndex < xOrig.count - 2) && (x > xOrig[_lastIndex + 1])) {
            _lastIndex = _lastIndex + 1;
        }
        return _lastIndex;
    }
    
    private func evalSpline(x : Double, j : Int) -> Double {
        let dx : Double = xOrig[j + 1] - xOrig[j];
        let t : Double = (x - xOrig[j]) / dx;
        let y : Double = (1 - t) * yOrig[j] + t * yOrig[j + 1] + t * (1 - t) * (a[j] * (1 - t) + b[j] * t); // equation 9
        return y;
    }
    
    private func eval(x : [Double]) -> [Double] {
        let n : Int = x.count
        var y : [Double] = [Double](repeating:0, count:n)
        _lastIndex = 0 // Reset simultaneous traversal in case there are multiple calls
    
        for i in 0 ..< n {
            // Find which spline can be used to compute this x (by simultaneous traverse)
            let j : Int = getNextXIndex(x[i])
            // Evaluate using j'th spline
            y[i] = evalSpline(x: x[i], j: j)
        }
        return y
    }
    
    
    func fitAndEval(x : [Double], y : [Double], xs : [Double], startSlope : Double, endSlope : Double) -> [Double] {
        fit(x: x, y: y, startSlope: startSlope, endSlope: endSlope);
        return eval(x: xs);
    }

}

class SplineLineRenderableSeries: SCICustomRenderableSeries {
    var upSampleFactor : Int32 = 0
    var isSplineEnabled : Bool = true
    
    func convert<T>(count: Int, data: UnsafePointer<T>) -> [T] {
        let buffer = UnsafeBufferPointer(start: data, count: count)
        return Array(buffer)
    }
    
    private func computeSplineSeries(renderPassData : SCIRenderPassDataProtocol, isSplineEnabled : Bool, upSampleFactor : Int32) -> SCIPointSeriesProtocol {
        if (!isSplineEnabled) {
            return renderPassData.pointSeries()
        }
        
        // Spline enabled
        let n : Int = Int( self.currentRenderPassData.pointSeries().count() * upSampleFactor )
        let xAC : SCIArrayControllerProtocol = currentRenderPassData.pointSeries().xValues()
        let yAC : SCIArrayControllerProtocol = currentRenderPassData.pointSeries().yValues()
        let x : [Double] = convert(count: Int(xAC.count()), data: xAC.doubleData())
        let y : [Double] = convert(count: Int(yAC.count()), data: yAC.doubleData())
        var xs : [Double] = [Double](repeating:0, count:Int(n))
        let stepSize : Double = (x[x.count - 1] - x[0]) / Double(n - 1)
        
        for i in 0..<n {
            xs [i] = x[0] + Double(i) * stepSize
        }
        
        var ys : [Double] = [Double](repeating:0, count:Int(n))
        let cubicSpline : CubicSpline = CubicSpline()
        ys = cubicSpline.fitAndEval(x: x, y: y, xs: xs, startSlope: Double.nan, endSlope: Double.nan)
        
        let result : SCIPointSeries = SCIPointSeries(capacity: Int32(n))
        result.xValues().appendRange(xs)
        result.yValues().appendRange(ys)
        return result
    }
    
    override func internalDraw(withContext renderContext: SCIRenderContext2DProtocol!, withData renderPassData: SCIRenderPassDataProtocol!) -> Void {
        let strokeStyle : SCIPenStyle! = self.strokeStyle as! SCIPenStyle!
        if (strokeStyle == nil) { return }
        
        let splinePoints = computeSplineSeries(renderPassData: renderPassData, isSplineEnabled: isSplineEnabled, upSampleFactor: upSampleFactor)
        let points : SCIPointSeriesProtocol = renderPassData.pointSeries()
        
        renderContext.setDrawingArea(renderContext.parentRenderSurface.chartFrame())
        let pen = renderContext.createPen(fromStyle: strokeStyle)

        let xCalc : SCICoordinateCalculatorProtocol = renderPassData.xCoordinateCalculator()
        let yCalc : SCICoordinateCalculatorProtocol = renderPassData.yCoordinateCalculator()
        
        var pointCount : Int = Int(splinePoints.count())
        var x : [Double] = convert(count: pointCount, data: splinePoints.xValues().doubleData())
        var y : [Double] = convert(count: pointCount, data: splinePoints.yValues().doubleData())
        let xCoord = xCalc.getCoordinateFrom(x[0])
        let yCoord = yCalc.getCoordinateFrom(y[0])
        renderContext.beginPolyline(withBrush: pen, withPointX: Float(xCoord), y: Float(yCoord))
        for i in 1..<pointCount {
            let xCoord = xCalc.getCoordinateFrom(x[i])
            let yCoord = yCalc.getCoordinateFrom(y[i])
            renderContext.extendPolyline(withBrush: pen, withPointX: Float(xCoord), y: Float(yCoord))
        }
        
        if (pointMarker != nil) {
            pointCount = Int(points.count())
            x = convert(count: pointCount, data: points.xValues().doubleData())
            y = convert(count: pointCount, data: points.yValues().doubleData())
            for i in 0..<pointCount {
                let xCoord = xCalc.getCoordinateFrom(x[i])
                let yCoord = yCalc.getCoordinateFrom(y[i])
                pointMarker.draw(toContext: renderContext, atX: Float(xCoord), y: Float(yCoord))
            }
        }
    }
}
