//
//  SentimentGuageView.swift
//  Sentiments
//
//  Created by Shahin on 2018-12-01.
//  Copyright © 2018 98%Chimp. All rights reserved.
//

import Foundation
import ABGaugeViewKit
import PureLayout

class SentimentGuageView
{
    private var guageView = ABGaugeView(frame: CGRect.zero)
    fileprivate let minSentiment: CGFloat = -1.0
    fileprivate let maxSentiment: CGFloat = 1.0
    var sentiment: CGFloat = 0 {
        didSet {
            guageView.needleValue = ((sentiment - minSentiment) * 100) / (maxSentiment - minSentiment)
        }
    }
    func create(for superView: UIView)
    {
        guageView.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(guageView)
        guageView.autoPinEdgesToSuperviewEdges()
        
        sentiment = 50.0
        guageView.colorCodes = "FF0000,FF6633,FFCC00,CCFF66,00FF00"
        guageView.backgroundColor = .clear
        guageView.blinkAnimate = false
    }
}
