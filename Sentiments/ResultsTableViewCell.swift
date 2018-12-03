//
//  ResultsTableViewCell.swift
//  Sentiments
//
//  Created by Shahin on 2018-11-11.
//  Copyright © 2018 98%Chimp. All rights reserved.
//

import UIKit
import NaturalLanguageUnderstanding

func rounded(value: Double) -> Double { return round(100 * value) / 100 }

class Scores: NSObject
{
    @objc dynamic var sentiment = [Double]()
    @objc dynamic var anger = [Double]()
    @objc dynamic var disgust = [Double]()
    @objc dynamic var fear = [Double]()
    @objc dynamic var joy = [Double]()
    @objc dynamic var sadness = [Double]()
}

class ResultsTableViewCell: UITableViewCell
{
    @IBOutlet weak var analyzedTextLabel: UILabel!
    @IBOutlet weak var guageView: UIView!
    @IBOutlet weak var chartView: UIView!
    
    fileprivate let sentimentGuageView = SentimentGuageView()
    fileprivate let emotionSpiderChart = EmotionSpiderView()
    
    func configureCell(with analysisResult: AnalysisResults, and scores: Scores)
    {
        let sentimentValue = analysisResult.sentiment?.document?.score ?? 0
        let emotion = analysisResult.emotion?.document?.emotion
        let angerValue = emotion?.anger ?? 0
        let disgustValue = emotion?.disgust ?? 0
        let fearValue = emotion?.fear ?? 0
        let joyValue = emotion?.joy ?? 0
        let sadnessValue = emotion?.sadness ?? 0
        analyzedTextLabel.text = analysisResult.analyzedText

        sentimentGuageView.create(for: guageView)
        sentimentGuageView.sentiment = CGFloat(sentimentValue)
        
        emotionSpiderChart.createChart(for: chartView)
        emotionSpiderChart.emotions = [angerValue, disgustValue, fearValue, joyValue, sadnessValue]
        scores.sentiment.append(sentimentValue)
        scores.anger.append(angerValue)
        scores.disgust.append(disgustValue)
        scores.fear.append(fearValue)
        scores.joy.append(joyValue)
        scores.sadness.append(sadnessValue)
    }
}
