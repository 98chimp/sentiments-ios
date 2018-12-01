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

var sentimentScores = [Double]()
var angerScores = [Double]()
var disgustScores = [Double]()
var fearScores = [Double]()
var joyScores = [Double]()
var sadnessScores = [Double]()

class ResultsTableViewCell: UITableViewCell
{
    @IBOutlet weak var analyzedTextLabel: UILabel!
    @IBOutlet weak var sentimentCategoryLabel: UILabel!
    @IBOutlet weak var sentimentValueLabel: UILabel!
    @IBOutlet weak var angerValueLabel: UILabel!
    @IBOutlet weak var disgustValueLabel: UILabel!
    @IBOutlet weak var fearValueLabel: UILabel!
    @IBOutlet weak var joyValueLabel: UILabel!
    @IBOutlet weak var sadnessValueLabel: UILabel!
    @IBOutlet weak var faceView: FaceView!
    
    func configureCell(with analysisResult: AnalysisResults)
    {
        let sentimentValue = analysisResult.sentiment?.document?.score ?? 0
        let emotion = analysisResult.emotion?.document?.emotion
        let angerValue = emotion?.anger ?? 0
        let disgustValue = emotion?.disgust ?? 0
        let fearValue = emotion?.fear ?? 0
        let joyValue = emotion?.joy ?? 0
        let sadnessValue = emotion?.sadness ?? 0
        analyzedTextLabel.text = analysisResult.analyzedText
        sentimentCategoryLabel.text = analysisResult.sentiment?.document?.label
        sentimentValueLabel.text = "\(rounded(value: sentimentValue))"
        angerValueLabel.text = "\(rounded(value: angerValue))"
        disgustValueLabel.text = "\(rounded(value: disgustValue))"
        fearValueLabel.text = "\(rounded(value: fearValue))"
        joyValueLabel.text = "\(rounded(value: joyValue))"
        sadnessValueLabel.text = "\(rounded(value: sadnessValue))"
        faceView.smiliness = rounded(value: sentimentValue)
        
        sentimentScores.append(sentimentValue)
        angerScores.append(angerValue)
        disgustScores.append(disgustValue)
        fearScores.append(fearValue)
        joyScores.append(joyValue)
        sadnessScores.append(sadnessValue)
    }
}
