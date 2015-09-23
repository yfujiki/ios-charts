//
//  MultiplePieChartView.swift
//  Charts
//
//  Created by Yuichi Fujiki on 8/21/15.
//  Copyright (c) 2015 dcg. All rights reserved.
//

import UIKit

public class MultiplePieChartView: PieChartView {

    internal var _drawAnglesPerDataSet: [[CGFloat]]?
    internal var _absoluteAnglesPerDataSet: [[CGFloat]]?

    public var drawAnglesPerDataSet: [[CGFloat]] {
        return _drawAnglesPerDataSet ?? [[CGFloat]]()
    }

    public var absoluteAnglesPerDataSet: [[CGFloat]] {
        return _absoluteAnglesPerDataSet ?? [[CGFloat]]()
    }

    internal override func initialize()
    {
        super.initialize()

        renderer = MultiplePieChartRenderer(chart: self, animator: _animator, viewPortHandler: _viewPortHandler)
    }

    /// calculates the needed angle for a given value
    private func calcAngle(value: Double, dataSet: ChartDataSet) -> CGFloat
    {
        return CGFloat(value) / CGFloat(dataSet.yValueSum) * 360.0
    }

    override internal func calcAngles()
    {
        _drawAnglesPerDataSet = [[CGFloat]]()
        _absoluteAnglesPerDataSet = [[CGFloat]]()

        var dataSets = _data.dataSets

        for (var i = 0; i < _data.dataSetCount; i++)
        {
            var drawAngles = [CGFloat]()
            var absoluteAngles = [CGFloat]()

            drawAngles.reserveCapacity(_data.yValCount)
            absoluteAngles.reserveCapacity(_data.yValCount)

            var cnt = 0

            let set = dataSets[i]
            var entries = set.yVals

            for (var j = 0; j < entries.count; j++)
            {
                drawAngles.append(calcAngle(abs(entries[j].value), dataSet: set))

                if (cnt == 0)
                {
                    absoluteAngles.append(drawAngles[cnt])
                }
                else
                {
                    absoluteAngles.append(absoluteAngles[cnt - 1] + drawAngles[cnt])
                }

                cnt++
            }

            _drawAnglesPerDataSet!.append(drawAngles)
            _absoluteAnglesPerDataSet!.append(absoluteAngles)
        }
    }
}
