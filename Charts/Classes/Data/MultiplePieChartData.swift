//
//  MultiplePieChartData.swift
//  Charts
//
//  Created by Yuichi Fujiki on 8/21/15.
//  Copyright (c) 2015 dcg. All rights reserved.
//

import UIKit

public class MultiplePieChartData: PieChartData {
    override public func getDataSetByIndex(index: Int) -> ChartDataSet? {
        if index < 0 || index >= dataSets.count {
            return nil
        }

        return dataSets[index]
    }

    override public func getDataSetByLabel(label: String, ignorecase: Bool) -> ChartDataSet? {
        let index = getDataSetIndexByLabel(label, ignorecase: true)

        if index < 0 || index >= dataSets.count {
            return nil
        } else {
            return dataSets[index]
        }
    }
}
