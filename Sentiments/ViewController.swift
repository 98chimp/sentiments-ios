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
    @IBOutlet fileprivate weak var resultsTableView: UITableView!
    @IBOutlet weak var sentimentCategoryLabel: UILabel!
    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var faceView: FaceView!
    @IBOutlet weak var angerLabel: UILabel!
    @IBOutlet weak var disgustLabel: UILabel!
    @IBOutlet weak var fearLabel: UILabel!
    @IBOutlet weak var joyLabel: UILabel!
    @IBOutlet weak var sadnessLabel: UILabel!
    
    var sentimentAvg: Double {
        return sentimentScores.isEmpty ? 0 : sentimentScores.reduce(0) { $0 + $1 } / Double(sentimentScores.count)
    }
    var angerAvg: Double {
        return angerScores.isEmpty ? 0 : angerScores.reduce(0) { $0 + $1 } / Double(angerScores.count)
    }
    var disgustAvg: Double {
        return disgustScores.isEmpty ? 0 : disgustScores.reduce(0) { $0 + $1 } / Double(disgustScores.count)
    }
    var fearAvg: Double {
        return fearScores.isEmpty ? 0 : fearScores.reduce(0) { $0 + $1 } / Double(fearScores.count)
    }
    var joyAvg: Double {
        return joyScores.isEmpty ? 0 : joyScores.reduce(0) { $0 + $1 } / Double(joyScores.count)
    }
    var sadnessAvg: Double {
        return sadnessScores.isEmpty ? 0 : sadnessScores.reduce(0) { $0 + $1 } / Double(sadnessScores.count)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupTableView()
        submitCommentsForAnalysis()
    }
    
    fileprivate func setupSummary()
    {
        sentimentLabel.text = "\(rounded(value: sentimentAvg))"
        faceView.smiliness = rounded(value: sentimentAvg)
        angerLabel.text = "\(rounded(value: angerAvg))"
        disgustLabel.text = "\(rounded(value: disgustAvg))"
        fearLabel.text = "\(rounded(value: fearAvg))"
        joyLabel.text = "\(rounded(value: joyAvg))"
        sadnessLabel.text = "\(rounded(value: sadnessAvg))"
    }
    
    fileprivate func setupTableView()
    {
        resultsTableView.rowHeight = UITableViewAutomaticDimension
        resultsTableView.estimatedRowHeight = 180.0
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
        watsonNLU.analyze(parameters: parameters) { [weak self] (results) in
            self?.analysisResults.append(results)
            DispatchQueue.main.async {
                self?.resultsTableView.reloadData()
                self?.setupSummary()
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
        resultsCell.configureCell(with: analysisResults[indexPath.row])
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

