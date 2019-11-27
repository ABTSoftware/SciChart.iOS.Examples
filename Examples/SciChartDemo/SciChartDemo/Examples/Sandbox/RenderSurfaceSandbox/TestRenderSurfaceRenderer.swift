//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// TestRenderSurfaceRenderer.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import UIKit

class TestRenderSurfaceRenderer: NSObject, ISCIRenderSurfaceRenderer {
    struct M {
        static let horizontalItemsCount = CGFloat(4)
        static let verticalItemsCount = CGFloat(12)
        static let spacing = CGFloat(7)
    }
    
    var dx: Float = 0.0
    var dy: Float = 0.0
    var degrees: Float = 0.0
    var opacity: Float = 0.0
    var scale: Float = 0.0
    
    var frameSize: CGSize!
    
    let xAxisArrow: [Float] = [0.0, 0.0, 50.0, 0.0, 30.0, -10.0, 50.0, 0.0, 30.0, 10.0, 50.0, 0.0]
    let yAxisArrow: [Float] = [0.0, 0.0, 0.0, 50.0, -10.0, 30.0, 0.0, 50.0, 10.0, 30.0, 0.0, 50.0]
    
    let sprite2Rect = CGRect(origin: .zero, size: CGSize(width: 0.5, height: 0.5))
    let sprite3Rect = CGRect(origin: CGPoint(x: 0.25, y: 0.25), size: CGSize(width: 0.75, height: 0.75))
    
    let solidStyle = SCISolidBrushStyle(colorCode: 0xeeffc9a8)
    let linearGradient = SCILinearGradientBrushStyle(start: CGPoint(x: 0.5, y: 0.0), end: CGPoint(x: 0.5, y: 1.0), startColorCode: 0xeeffc9a8, endColorCode: 0xee1324a5)
    let radialGradient = SCIRadialGradientBrushStyle(center: CGPoint(x: 0.5, y: 0.5), radius: 1.0, centerColorCode: 0xeeffc9a8, edgeColorCode: 0xee1324a5)
    let textureStyle: SCITextureBrushStyle!
    
    let simpleLineStyle = SCISolidPenStyle(colorCode: 0xffff0000, thickness: 1.0, strokeDashArray: nil, antiAliasing: false)
    let aaLineStyle = SCISolidPenStyle(colorCode: 0xff00ff00, thickness: 1.0, strokeDashArray: nil, antiAliasing: true)
    let texturedLineStyle: SCIPenStyle!
    let texturedAaLineStyle: SCIPenStyle!
    
    let dashedSimpleLineStyle = SCISolidPenStyle(colorCode: 0xff0000ff, thickness: 1.0, strokeDashArray: [2, 4, 2, 4], antiAliasing: false)
    let dashedAaLineStyle = SCISolidPenStyle(colorCode: 0xffff00ff, thickness: 1.0, strokeDashArray: [4, 2, 4, 2], antiAliasing: true)
    let dashedTexturedLineStyle: SCIPenStyle!
    let dashedTexturedAaLineStyle: SCIPenStyle!
    
    let thickSimpleLineStyle = SCISolidPenStyle(colorCode: 0xffff0000, thickness: 5.0, strokeDashArray: nil, antiAliasing: false)
    let thickAaLineStyle = SCISolidPenStyle(colorCode: 0xff00ff00, thickness: 5.0, strokeDashArray: nil, antiAliasing: true)
    let thickTexturedLineStyle: SCIPenStyle!
    let thickTexturedAaLineStyle: SCIPenStyle!
    
    let dashedThickSimpleLineStyle = SCISolidPenStyle(colorCode: 0xff0000ff, thickness: 15.0, strokeDashArray: [2, 4, 2, 4], antiAliasing: false)
    let dashedThickAaLineStyle = SCISolidPenStyle(colorCode: 0xffff00ff, thickness: 15.0, strokeDashArray: [0, 8, 4, 2], antiAliasing: true)
    let dashedThickTexturedLineStyle: SCIPenStyle!
    let dashedThickTexturedAaLineStyle: SCIPenStyle!
    
    // let fontStyle
    // let customFontStyle
    
    let bitmap: SCIBitmap
    
    init(bitmap: SCIBitmap) {
        self.bitmap = bitmap
        textureStyle = SCITextureBrushStyle(texture: bitmap)
        
        texturedLineStyle = SCITexturePenStyle(gradientStyle: textureStyle, antiAliasing: false, thickness: 1.0, strokeDashArray: nil)
        texturedAaLineStyle = SCITexturePenStyle(gradientStyle: textureStyle, antiAliasing: true, thickness: 1.0, strokeDashArray: nil)
        
        dashedTexturedLineStyle = SCITexturePenStyle(gradientStyle: textureStyle, antiAliasing: false, thickness: 1.0, strokeDashArray: [2, 4, 2, 4])
        dashedTexturedAaLineStyle = SCITexturePenStyle(gradientStyle: textureStyle, antiAliasing: true, thickness: 1.0, strokeDashArray: [4, 2, 4, 2])
        
        thickTexturedLineStyle = SCITexturePenStyle(gradientStyle: textureStyle, antiAliasing: false, thickness: 5.0, strokeDashArray: nil)
        thickTexturedAaLineStyle = SCITexturePenStyle(gradientStyle: textureStyle, antiAliasing: true, thickness: 5.0, strokeDashArray: nil)
        
        dashedThickTexturedLineStyle = SCITexturePenStyle(gradientStyle: textureStyle, antiAliasing: false, thickness: 15.0, strokeDashArray: [2, 4, 2, 4])
        dashedThickTexturedAaLineStyle = SCITexturePenStyle(gradientStyle: textureStyle, antiAliasing: true, thickness: 15.0, strokeDashArray: [0, 8, 4, 2])
        
        super.init()
    }
    
    func onSurfaceAttached(_ renderSurface: ISCIRenderSurface!) { }
    
    func onSurfaceDetached(_ renderSurface: ISCIRenderSurface!) { }
    
    func onDraw(_ renderContext: ISCIRenderContext2D, assetManager: ISCIAssetManager2D) {
        let width = (frameSize.width / 2 - M.spacing * (M.horizontalItemsCount + 1)) / M.horizontalItemsCount
        let height = (frameSize.height - M.spacing * (M.verticalItemsCount + 1)) / M.verticalItemsCount
        let spacing = M.spacing
        
        let center = CGPoint(x: width / 2, y: height / 2)
        let size = CGSize(width: width, height: height)
        let rect = CGRect(origin: .zero, size: size)
        
        renderContext.translateX(by: dx, yBy: dy)
        renderContext.scaleX(by: scale, yBy: scale)
        renderContext.rotate(byDegrees: degrees)
        
        let solidBrushPerScreen = assetManager.brush(with: solidStyle, textureMappingMode: .perScreen, andOpacity: opacity)
        let radialGradientBrushPerScreen = assetManager.brush(with: radialGradient, textureMappingMode: .perScreen, andOpacity: opacity)
        let linearGradientBrushPerScreen = assetManager.brush(with: linearGradient, textureMappingMode: .perScreen, andOpacity: opacity)
        let textureBrushPerScreen = assetManager.brush(with: textureStyle, textureMappingMode: .perScreen, andOpacity: opacity)
        
        let solidBrushPerPrimitive = assetManager.brush(with: solidStyle, textureMappingMode: .perPrimitive, andOpacity: opacity)
        let radialGradientBrushPerPrimitive = assetManager.brush(with: radialGradient, textureMappingMode: .perPrimitive, andOpacity: opacity)
        let linearGradientBrushPerPrimitive = assetManager.brush(with: linearGradient, textureMappingMode: .perPrimitive, andOpacity: opacity)
        let textureBrushPerPrimitive = assetManager.brush(with: textureStyle, textureMappingMode: .perPrimitive, andOpacity: opacity)

        let simpleLine = assetManager.pen(with: simpleLineStyle, andOpacity: opacity)
        let aaLine = assetManager.pen(with: aaLineStyle, andOpacity: opacity)
        let dashedSimpleLine = assetManager.pen(with: dashedSimpleLineStyle, andOpacity: opacity)
        let dashedAaLine = assetManager.pen(with: dashedAaLineStyle, andOpacity: opacity)
        let thickSimpleLine = assetManager.pen(with: thickSimpleLineStyle, andOpacity: opacity)
        let thickAaLine = assetManager.pen(with: thickAaLineStyle, andOpacity: opacity)
        let dashedThickSimpleLine = assetManager.pen(with: dashedThickSimpleLineStyle, andOpacity: opacity)
        let dashedThickAaLine = assetManager.pen(with: dashedThickAaLineStyle, andOpacity: opacity)
        
        let texturedLine = assetManager.pen(with: texturedLineStyle, andOpacity: opacity)
        let texturedAaLine = assetManager.pen(with: texturedAaLineStyle, andOpacity: opacity)
        let dashedTexturedLine = assetManager.pen(with: dashedTexturedLineStyle, andOpacity: opacity)
        let dashedTexturedAaLine = assetManager.pen(with: dashedTexturedAaLineStyle, andOpacity: opacity)
        let thickTexturedLine = assetManager.pen(with: thickTexturedLineStyle, andOpacity: opacity)
        let thickTexturedAaLine = assetManager.pen(with: thickTexturedAaLineStyle, andOpacity: opacity)
        let dashedThickTexturedLine = assetManager.pen(with: dashedThickTexturedLineStyle, andOpacity: opacity)
        let dashedThickTexturedAaLine = assetManager.pen(with: dashedThickTexturedAaLineStyle, andOpacity: opacity)
        
//        final IFont font = assetManager.createFont(this.fontStyle);
//        final IFont customFont = assetManager.createFont(this.customFontStyle);
        
        let sprite1 = assetManager.texture(with: bitmap)
        let sprite2 = assetManager.texture(with: bitmap, region: sprite2Rect)
        let sprite3 = assetManager.texture(with: bitmap, region: sprite3Rect)

        // MARK: - Draw Arrows
        renderContext.drawLines(with: simpleLine, points: UnsafeMutablePointer<Float>(mutating: xAxisArrow), start: 0, count: Int32(xAxisArrow.count))
        renderContext.drawLines(with: aaLine, points: UnsafeMutablePointer<Float>(mutating: yAxisArrow), start: 0, count: Int32(yAxisArrow.count))
        
        renderContext.translateX(by: Float(spacing), yBy: Float(spacing))
        renderContext.save();
        
        // MARK: - Draw Lines
        renderContext.save();
        renderContext.drawLine(with: simpleLine, atStart: .zero, end: CGPoint(x: width, y: height))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawLine(with: aaLine, atStart: .zero, end: CGPoint(x: width, y: height))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawLine(with: dashedSimpleLine, atStart: .zero, end: CGPoint(x: width, y: height))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawLine(with: dashedAaLine, atStart: .zero, end: CGPoint(x: width, y: height))
        renderContext.restore()
        
        renderContext.translateX(by: 0, yBy: Float(height + spacing))
        
        renderContext.save();
        renderContext.drawLine(with: thickSimpleLine, atStart: .zero, end: CGPoint(x: width, y: height))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawLine(with: thickAaLine, atStart: .zero, end: CGPoint(x: width, y: height))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawLine(with: dashedThickSimpleLine, atStart: .zero, end: CGPoint(x: width, y: height))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawLine(with: dashedThickAaLine, atStart: .zero, end: CGPoint(x: width, y: height))
        renderContext.restore()
        
        renderContext.translateX(by: 0, yBy: Float(height + spacing))
        
        // MARK: - Draw Textured Lines
        renderContext.save();
        renderContext.drawLine(with: texturedLine, atStart: .zero, end: CGPoint(x: width, y: height))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawLine(with: texturedAaLine, atStart: .zero, end: CGPoint(x: width, y: height))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawLine(with: dashedTexturedLine, atStart: .zero, end: CGPoint(x: width, y: height))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawLine(with: dashedTexturedAaLine, atStart: .zero, end: CGPoint(x: width, y: height))
        renderContext.restore()
        
        renderContext.translateX(by: 0, yBy: Float(height + spacing))
        
        renderContext.save();
        renderContext.drawLine(with: thickTexturedLine, atStart: .zero, end: CGPoint(x: width, y: height))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawLine(with: thickTexturedAaLine, atStart: .zero, end: CGPoint(x: width, y: height))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawLine(with: dashedThickTexturedLine, atStart: .zero, end: CGPoint(x: width, y: height))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawLine(with: dashedThickTexturedAaLine, atStart: .zero, end: CGPoint(x: width, y: height))
        renderContext.restore()
        
        renderContext.translateX(by: 0, yBy: Float(height + spacing))
        
        // MARK: - Draw Rects
        renderContext.save();
        renderContext.draw(rect, with: simpleLine)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.draw(rect, with: aaLine)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.draw(rect, with: dashedSimpleLine)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.draw(rect, with: dashedAaLine)
        renderContext.restore()
        
        renderContext.translateX(by: 0, yBy: Float(height + spacing))
        
        renderContext.save();
        renderContext.draw(rect, with: thickSimpleLine)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.draw(rect, with: thickAaLine)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.draw(rect, with: dashedThickSimpleLine)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.draw(rect, with: dashedThickAaLine)
        renderContext.restore()
        
        renderContext.translateX(by: 0, yBy: Float(height + spacing))
        
        // MARK: - Draw Textured Rects
        renderContext.save();
        renderContext.draw(rect, with: texturedLine)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.draw(rect, with: texturedAaLine)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.draw(rect, with: dashedTexturedLine)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.draw(rect, with: dashedTexturedAaLine)
        renderContext.restore()
        
        renderContext.translateX(by: 0, yBy: Float(height + spacing))
        
        renderContext.save();
        renderContext.draw(rect, with: thickTexturedLine)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.draw(rect, with: thickTexturedAaLine)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.draw(rect, with: dashedThickTexturedLine)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.draw(rect, with: dashedThickTexturedAaLine)
        renderContext.restore()
        
        renderContext.translateX(by: 0, yBy: Float(height + spacing))
        
        // MARK: - Fill Rects
        renderContext.save();
        renderContext.fill(rect, with: solidBrushPerScreen)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.fill(rect, with: linearGradientBrushPerScreen)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.fill(rect, with: radialGradientBrushPerScreen)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.fill(rect, with: textureBrushPerScreen)
        renderContext.restore()
        
        renderContext.translateX(by: 0, yBy: Float(height + spacing))
        
        renderContext.save();
        renderContext.fill(rect, with: solidBrushPerPrimitive)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.fill(rect, with: linearGradientBrushPerPrimitive)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.fill(rect, with: radialGradientBrushPerPrimitive)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.fill(rect, with: textureBrushPerPrimitive)
        renderContext.restore()
        
        renderContext.restore()
        renderContext.save()
        
        renderContext.translateX(by: Float(frameSize.width / 2 + spacing), yBy: 0)
        
        // MARK: - Draw Ellipses
        renderContext.save();
        renderContext.drawEllipse(with: simpleLine, brush: solidBrushPerScreen, andSize: size, at: center)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawEllipse(with: aaLine, brush: linearGradientBrushPerScreen, andSize: size, at: center)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawEllipse(with: dashedSimpleLine, brush: radialGradientBrushPerScreen, andSize: size, at: center)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawEllipse(with: dashedAaLine, brush: textureBrushPerScreen, andSize: size, at: center)
        renderContext.restore()
        
        renderContext.translateX(by: 0, yBy: Float(height + spacing))

        renderContext.save();
        renderContext.drawEllipse(with: thickSimpleLine, brush: solidBrushPerPrimitive, andSize: size, at: center)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawEllipse(with: thickAaLine, brush: linearGradientBrushPerPrimitive, andSize: size, at: center)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawEllipse(with: dashedThickSimpleLine, brush: radialGradientBrushPerPrimitive, andSize: size, at: center)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawEllipse(with: dashedThickAaLine, brush: textureBrushPerPrimitive, andSize: size, at: center)
        renderContext.restore()

        renderContext.translateX(by: 0, yBy: Float(height + spacing))

        // MARK: - Draw Textured Ellipses
        renderContext.save();
        renderContext.drawEllipse(with: texturedLine, brush: solidBrushPerScreen, andSize: size, at: center)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawEllipse(with: texturedAaLine, brush: linearGradientBrushPerScreen, andSize: size, at: center)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawEllipse(with: dashedTexturedLine, brush: radialGradientBrushPerScreen, andSize: size, at: center)
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawEllipse(with: dashedTexturedAaLine, brush: textureBrushPerScreen, andSize: size, at: center)
        renderContext.restore()

        renderContext.translateX(by: 0, yBy: Float(height + spacing))

        renderContext.save();
        renderContext.drawEllipse(with: thickTexturedLine, brush: solidBrushPerPrimitive, andSize: size, at: center);
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawEllipse(with: thickTexturedAaLine, brush: linearGradientBrushPerPrimitive, andSize: size, at: center);
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawEllipse(with: dashedThickTexturedLine, brush: radialGradientBrushPerPrimitive, andSize: size, at: center);
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawEllipse(with: dashedThickTexturedAaLine, brush: textureBrushPerPrimitive, andSize: size, at: center);
        renderContext.restore()

        // TODO: - drawing text doesn't work yet
        // MARK: - Draw Text
//        renderContext.drawText(font, 0, 0, fontStyle.textColor, "ABCDEFGHIJKLMNOPQRSTUVWXYZ");
//        renderContext.drawText(font, 0, 50, fontStyle.textColor, "abcdefghijklmnopqrstuvwxyz");
//        renderContext.drawText(font, 0, 100, fontStyle.textColor, "1234567890~!@#$%^&*()-+=/|\\'\"");
//
//        renderContext.drawText(customFont, 0, 150, customFontStyle.textColor, "ABCDEFGHIJKLMNOPQRSTUVWXYZ");
//        renderContext.drawText(customFont, 0, 200, customFontStyle.textColor, "abcdefghijklmnopqrstuvwxyz");
//        renderContext.drawText(customFont, 0, 250, customFontStyle.textColor, "1234567890~!@#$%^&*()-+=/|\\'\"");

        renderContext.translateX(by: 0, yBy: Float(height + spacing))

        // MARK: - Draw Sprites
        renderContext.save();
        renderContext.drawSprite(sprite1, at: .zero, withOpacity: opacity)
        renderContext.translateX(by: Float(CGFloat(sprite1.width) + spacing), yBy: 0)
        renderContext.drawSprite(sprite2, at: .zero, withOpacity: opacity)
        renderContext.translateX(by: Float(CGFloat(sprite2.width) + spacing), yBy: 0)
        renderContext.drawSprite(sprite3, at: .zero, withOpacity: opacity)
        renderContext.restore()
        
        renderContext.translateX(by: 0, yBy: Float(CGFloat(sprite1.height / 2) + spacing))
        
        sprite1.dispose()
        sprite2.dispose()
        sprite3.dispose()
        
        // MARK: - Draw Lines + Triangles strips
        let fHeight = Float(height)
        let fWidth = Float(width)
        let stripsPoints: [Float] = [0.0, fHeight / 2,
                                     fWidth / 2, 0.0,
                                     fWidth, fHeight / 2,
                                     fWidth, fHeight,
                                     0.0, fHeight / 2]
        let points = UnsafeMutablePointer<Float>(mutating: stripsPoints)
        
        renderContext.save();
        renderContext.drawTrianglesStrip(with: solidBrushPerScreen, points: points, start: 0, count: Int32(stripsPoints.count))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawTrianglesStrip(with: linearGradientBrushPerScreen, points: points, start: 0, count: Int32(stripsPoints.count))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawTrianglesStrip(with: radialGradientBrushPerScreen, points: points, start: 0, count: Int32(stripsPoints.count))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawTrianglesStrip(with: textureBrushPerScreen, points: points, start: 0, count: Int32(stripsPoints.count))
        renderContext.restore()
        
        renderContext.translateX(by: 0, yBy: Float(height + spacing))
        
        renderContext.save();
        renderContext.drawTrianglesStrip(with: solidBrushPerPrimitive, points: points, start: 0, count: Int32(stripsPoints.count))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawTrianglesStrip(with: linearGradientBrushPerPrimitive, points: points, start: 0, count: Int32(stripsPoints.count))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawTrianglesStrip(with: radialGradientBrushPerPrimitive, points: points, start: 0, count: Int32(stripsPoints.count))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawTrianglesStrip(with: textureBrushPerPrimitive, points: points, start: 0, count: Int32(stripsPoints.count))
        renderContext.restore()
        
        renderContext.translateX(by: 0, yBy: Float(height + spacing))
        
        renderContext.save();
        renderContext.drawLinesStrip(with: aaLine, points: points, start: 0, count: Int32(stripsPoints.count))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawLinesStrip(with: dashedAaLine, points: points, start: 0, count: Int32(stripsPoints.count))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawLinesStrip(with: thickAaLine, points: points, start: 0, count: Int32(stripsPoints.count))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawLinesStrip(with: dashedThickAaLine, points: points, start: 0, count: Int32(stripsPoints.count))
        renderContext.restore()
        
        renderContext.translateX(by: 0, yBy: Float(height + spacing))
        
        renderContext.save();
        renderContext.drawLinesStrip(with: texturedAaLine, points: points, start: 0, count: Int32(stripsPoints.count))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawLinesStrip(with: dashedTexturedAaLine, points: points, start: 0, count: Int32(stripsPoints.count))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawLinesStrip(with: thickTexturedAaLine, points: points, start: 0, count: Int32(stripsPoints.count))
        renderContext.translateX(by: Float(width + spacing), yBy: 0)
        renderContext.drawLinesStrip(with: dashedThickTexturedAaLine, points: points, start: 0, count: Int32(stripsPoints.count))
        renderContext.restore()        
    }
}
