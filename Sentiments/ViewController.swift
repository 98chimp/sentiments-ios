//
//  ViewController.swift
//  Sentiments
//
//  Created by Shahin on 2018-11-10.
//  Copyright © 2018 98%Chimp. All rights reserved.
//

import UIKit
import NaturalLanguageUnderstanding

class ViewController: UIViewController
{
    fileprivate let watsonNLU = NaturalLanguageUnderstanding(version: "2018-03-16", apiKey: "rC26f38AVIJh0cR68-rn503LXckcqS9GWCvFzKYjTtD7")
    fileprivate var analysisResults = [AnalysisResults]()
    fileprivate let cellIdentifier = "ResultsTableViewCell"
    fileprivate let emotionsSpiderChart = EmotionSpiderView()
    fileprivate let sentimentGuageView = SentimentGuageView()
    @IBOutlet fileprivate weak var resultsTableView: UITableView!
    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var guageView: UIView!
    @IBOutlet weak var spiderView: UIView!
    var emotionDataAddedToChart = false
    let scores = Scores()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupTableView()
        submitCommentsForAnalysis()
        sentimentGuageView.create(for: guageView)
        emotionsSpiderChart.createChart(for: spiderView)
    }
    
    fileprivate func updateSummary()
    {
        sentimentGuageView.sentiment = CGFloat(scores.sentiment.average)
        sentimentLabel.text = "\(rounded(value: scores.sentiment.average))"
        emotionsSpiderChart.emotions = [scores.anger.average, scores.disgust.average, scores.fear.average, scores.joy.average, scores.sadness.average]
    }
    
    fileprivate func setupTableView()
    {
        resultsTableView.rowHeight = UITableViewAutomaticDimension
        resultsTableView.estimatedRowHeight = 180.0
        resultsTableView.allowsSelection = false
    }
    
    fileprivate func submitCommentsForAnalysis()
    {
        for comment in Comments.comments {
            analyzeSentiment(for: comment)
        }
    }
    
    fileprivate func analyzeSentiment(for text: String)
    {
        let features = Features(concepts: nil, emotion: EmotionOptions(document: true, targets: nil), entities: nil, keywords: nil, metadata: nil, relations: nil, semanticRoles: nil, sentiment: SentimentOptions(document: true, targets: nil), categories: nil)
        let parameters = Parameters(features: features, text: text, html: nil, url: nil, clean: nil, xpath: nil, fallbackToRaw: nil, returnAnalyzedText: true, language: "en", limitTextCharacters: nil)
        watsonNLU.analyze(parameters: parameters) { [unowned self] (results) in
            self.analysisResults.append(results)
            DispatchQueue.main.async {
                self.updateSummary()
                self.resultsTableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return analysisResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let resultsCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ResultsTableViewCell
        resultsCell.configureCell(with: analysisResults[indexPath.row], and: scores)
        return resultsCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
}

extension Collection where Element: Numeric
{
    /// Returns the total sum of all elements in the array
    var total: Element { return reduce(0, +) }
}

extension Collection where Element: BinaryInteger
{
    /// Returns the average of all elements in the array
    var average: Double {
        return isEmpty ? 0 : Double(Int(total)) / Double(count)
    }
}

extension Collection where Element: BinaryFloatingPoint
{
    /// Returns the average of all elements in the array
    var average: Element {
        return isEmpty ? 0 : total / Element(count)
    }
}
