//
//  MultiplePieChartRenderer.swift
//  Charts
//
//  Created by Yuichi Fujiki on 8/21/15.
//  Copyright (c) 2015 dcg. All rights reserved.
//

import UIKit

public class MultiplePieChartRenderer: PieChartRenderer {
    public override func drawData(context context: CGContext?)
    {
        if (_chart !== nil)
        {
            let pieData = _chart.data

            if (pieData != nil)
            {
                let datasets = pieData!.dataSets as! [PieChartDataSet]
                for (index, set) in datasets.enumerate() {
                    if (set.isVisible)
                    {
                        drawDataSet(context: context, dataSet: set, setIndex: index)
                    }
                }
            }
        }
    }

    public func drawDataSet(context context: CGContext?, dataSet: PieChartDataSet, setIndex: Int)
    {
        var angle = _chart.rotationAngle

        var cnt = 0

        var entries = dataSet.yVals
        var drawAngles = (_chart as! MultiplePieChartView).drawAnglesPerDataSet[setIndex]
        let circleBox = _chart.circleBox
        let factor = (CGFloat(3) + (CGFloat(setIndex + 1) / CGFloat(_chart.data!.dataSetCount))) / CGFloat(4)
        let radius = _chart.radius * factor
        NSLog("Factor/Radius for \(setIndex) is \(factor)/\(radius)")
        var innerRadius: CGFloat = 0

        if setIndex > 0 {
            innerRadius = radius * 0.9
        } else if drawHoleEnabled && holeTransparent {
            innerRadius = radius * holeRadiusPercent
        }
        NSLog("Inner Radius for \(setIndex) is \(innerRadius)")

        CGContextSaveGState(context)

        for (var j = 0; j < entries.count; j++)
        {
            let newangle = drawAngles[cnt]
            let sliceSpace = dataSet.sliceSpace

            let e = entries[j]
            NSLog("Value for \(setIndex), \(j) : \(e.value)")

            // draw only if the value is greater than zero
            if ((abs(e.value) > 0.000001))
            {
                if (!_chart.needsHighlight(xIndex: e.xIndex,
                    dataSetIndex: _chart.data!.indexOfDataSet(dataSet)))
                {
                    let startAngle = angle + sliceSpace / 2.0
                    var sweepAngle = newangle * _animator.phaseY
                        - sliceSpace / 2.0
                    if (sweepAngle < 0.0)
                    {
                        sweepAngle = 0.0
                    }
                    let endAngle = startAngle + sweepAngle

                    let path = CGPathCreateMutable()
                    CGPathMoveToPoint(path, nil, circleBox.midX, circleBox.midY)
                    CGPathAddArc(path, nil, circleBox.midX, circleBox.midY, radius, startAngle * ChartUtils.Math.FDEG2RAD, endAngle * ChartUtils.Math.FDEG2RAD, false)
                    CGPathCloseSubpath(path)

                    if (innerRadius > 0.0)
                    {
                        CGPathMoveToPoint(path, nil, circleBox.midX, circleBox.midY)
                        CGPathAddArc(path, nil, circleBox.midX, circleBox.midY, innerRadius, startAngle * ChartUtils.Math.FDEG2RAD, endAngle * ChartUtils.Math.FDEG2RAD, false)
                        CGPathCloseSubpath(path)
                    }

                    CGContextBeginPath(context)
                    CGContextAddPath(context, path)
                    CGContextSetFillColorWithColor(context, dataSet.colorAt(j).CGColor)
                    CGContextEOFillPath(context)
                }
            }

            angle += newangle * _animator.phaseX
            cnt++
        }

        CGContextRestoreGState(context)
    }


    public override func drawValues(context context: CGContext?)
    {
        //        var center = _chart.centerCircleBox
        //
        //        // get whole the radius
        //        var r = _chart.radius
        //        var rotationAngle = _chart.rotationAngle
        //        var drawAngles = _chart.drawAngles
        //        var absoluteAngles = _chart.absoluteAngles
        //
        //        var off = r / 10.0 * 3.0
        //
        //        if (drawHoleEnabled)
        //        {
        //            off = (r - (r * _chart.holeRadiusPercent)) / 2.0
        //        }
        //
        //        r -= off; // offset to keep things inside the chart
        //
        //        var data: ChartData! = _chart.data
        //        if (data === nil)
        //        {
        //            return
        //        }
        //
        //        var defaultValueFormatter = _chart.valueFormatter
        //
        //        var dataSets = data.dataSets
        //        var drawXVals = drawXLabelsEnabled
        //
        //        var cnt = 0
        //
        //        for (var i = 0; i < dataSets.count; i++)
        //        {
        //            var dataSet = dataSets[i] as! PieChartDataSet
        //
        //            var drawYVals = dataSet.isDrawValuesEnabled
        //
        //            if (!drawYVals && !drawXVals)
        //            {
        //                continue
        //            }
        //
        //            var valueFont = dataSet.valueFont
        //            var valueTextColor = dataSet.valueTextColor
        //
        //            var formatter = dataSet.valueFormatter
        //            if (formatter === nil)
        //            {
        //                formatter = defaultValueFormatter
        //            }
        //
        //            var entries = dataSet.yVals
        //
        //            for (var j = 0, maxEntry = Int(min(ceil(CGFloat(entries.count) * _animator.phaseX), CGFloat(entries.count))); j < maxEntry; j++)
        //            {
        //                if (drawXVals && !drawYVals && (j >= data.xValCount || data.xVals[j] == nil))
        //                {
        //                    continue
        //                }
        //
        //                // offset needed to center the drawn text in the slice
        //                var offset = drawAngles[cnt] / 2.0
        //
        //                // calculate the text position
        //                var x = (r * cos(((rotationAngle + absoluteAngles[cnt] - offset) * _animator.phaseY) * ChartUtils.Math.FDEG2RAD) + center.x)
        //                var y = (r * sin(((rotationAngle + absoluteAngles[cnt] - offset) * _animator.phaseY) * ChartUtils.Math.FDEG2RAD) + center.y)
        //
        //                var value = usePercentValuesEnabled ? entries[j].value / _chart.yValueSum * 100.0 : entries[j].value
        //
        //                var val = formatter!.stringFromNumber(value)!
        //
        //                var lineHeight = valueFont.lineHeight
        //                y -= lineHeight
        //
        //                // draw everything, depending on settings
        //                if (drawXVals && drawYVals)
        //                {
        //                    ChartUtils.drawText(context: context, text: val, point: CGPoint(x: x, y: y), align: .Center, attributes: [NSFontAttributeName: valueFont, NSForegroundColorAttributeName: valueTextColor])
        //
        //                    if (j < data.xValCount && data.xVals[j] != nil)
        //                    {
        //                        ChartUtils.drawText(context: context, text: data.xVals[j]!, point: CGPoint(x: x, y: y + lineHeight), align: .Center, attributes: [NSFontAttributeName: valueFont, NSForegroundColorAttributeName: valueTextColor])
        //                    }
        //                }
        //                else if (drawXVals && !drawYVals)
        //                {
        //                    ChartUtils.drawText(context: context, text: data.xVals[j]!, point: CGPoint(x: x, y: y + lineHeight / 2.0), align: .Center, attributes: [NSFontAttributeName: valueFont, NSForegroundColorAttributeName: valueTextColor])
        //                }
        //                else if (!drawXVals && drawYVals)
        //                {
        //                    ChartUtils.drawText(context: context, text: val, point: CGPoint(x: x, y: y + lineHeight / 2.0), align: .Center, attributes: [NSFontAttributeName: valueFont, NSForegroundColorAttributeName: valueTextColor])
        //                }
        //
        //                cnt++
        //            }
        //        }
    }

    public override func drawExtras(context context: CGContext?)
    {
        //        drawHole(context: context)
        //        drawCenterText(context: context)
    }

    /// draws the hole in the center of the chart and the transparent circle / hole
    private func drawHole(context context: CGContext?)
    {
        //        if (_chart.drawHoleEnabled)
        //        {
        //            CGContextSaveGState(context)
        //
        //            var radius = _chart.radius
        //            var holeRadius = radius * holeRadiusPercent
        //            var center = _chart.centerCircleBox
        //
        //            if (holeColor !== nil && holeColor != UIColor.clearColor())
        //            {
        //                // draw the hole-circle
        //                CGContextSetFillColorWithColor(context, holeColor!.CGColor)
        //                CGContextFillEllipseInRect(context, CGRect(x: center.x - holeRadius, y: center.y - holeRadius, width: holeRadius * 2.0, height: holeRadius * 2.0))
        //            }
        //
        //            if (transparentCircleRadiusPercent > holeRadiusPercent)
        //            {
        //                var secondHoleRadius = radius * transparentCircleRadiusPercent
        //
        //                // make transparent
        //                CGContextSetFillColorWithColor(context, holeColor!.colorWithAlphaComponent(CGFloat(0x60) / CGFloat(0xFF)).CGColor)
        //
        //                // draw the transparent-circle
        //                CGContextFillEllipseInRect(context, CGRect(x: center.x - secondHoleRadius, y: center.y - secondHoleRadius, width: secondHoleRadius * 2.0, height: secondHoleRadius * 2.0))
        //            }
        //
        //            CGContextRestoreGState(context)
        //        }
    }
    
    /// draws the description text in the center of the pie chart makes most sense when center-hole is enabled
    private func drawCenterText(context context: CGContext?)
    {
        return
    }
    
    public override func drawHighlighted(context context: CGContext?, indices: [ChartHighlight])
    {
        return
    }
}
