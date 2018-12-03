//
//  EmotionSpiderView.swift
//  Sentiments
//
//  Created by Shahin on 2018-12-01.
//  Copyright © 2018 98%Chimp. All rights reserved.
//

import Foundation
import DDSpiderChart
import Charts
import PureLayout

class EmotionSpiderView: ChartViewDelegate
{
    private var spiderView = DDSpiderChartView(frame: .zero)
    private var spiderChart = RadarChartView(frame: .zero)
    fileprivate let minSentiment: CGFloat = -1.0
    fileprivate let maxSentiment: CGFloat = 1.0
    var emotions = [Double]() {
        didSet { setChartData() }
    }
    fileprivate let axes = ["anger", "disgust", "fear", "joy", "sadness"]
    
    func create(for superView: UIView)
    {
        spiderView.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(spiderView)
        spiderView.autoPinEdgesToSuperviewEdges()
        spiderView.axes = axes
        spiderView.backgroundColor = .clear
    }
    
    func add(dataSet: [Float], color: UIColor = .blue, animated: Bool = true)
    {
        spiderView.addDataSet(values: dataSet, color: color, animated: animated)
    }
    
    func createChart(for superView: UIView)
    {
        spiderChart.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(spiderChart)
        spiderChart.autoPinEdgesToSuperviewEdges()
        configureChart()
        setChartData()
    }
    
    fileprivate func configureChart()
    {
        spiderChart.delegate = self
        
        spiderChart.chartDescription?.enabled = false
        spiderChart.webLineWidth = 1
        spiderChart.innerWebLineWidth = 1
        spiderChart.webColor = .lightGray
        spiderChart.innerWebColor = .lightGray
        spiderChart.webAlpha = 1
        
        let xAxis = spiderChart.xAxis
        xAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
        xAxis.xOffset = 0
        xAxis.yOffset = 0
        xAxis.valueFormatter = self
        xAxis.labelTextColor = .black
        
        let yAxis = spiderChart.yAxis
        yAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
        yAxis.labelCount = 5
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 1
        yAxis.drawLabelsEnabled = false
        
        spiderChart.legend.enabled = false
        spiderChart.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutBack)
        
        guard let marker = RadarMarkerView.viewFromXib() else { return }
        marker.chartView = spiderChart
        spiderChart.marker = marker
    }
    
    fileprivate func setChartData()
    {
        var dataEntries = [RadarChartDataEntry]()
        emotions.forEach { dataEntries.append(RadarChartDataEntry(value: $0)) }
        let dataSet = RadarChartDataSet(values: dataEntries, label: nil)
        dataSet.setColor(UIColor(red: 103/255, green: 110/255, blue: 129/255, alpha: 1))
        dataSet.fillColor = UIColor(red: 103/255, green: 110/255, blue: 129/255, alpha: 1)
        dataSet.drawFilledEnabled = true
        dataSet.fillAlpha = 0.7
        dataSet.lineWidth = 2
        dataSet.drawHighlightCircleEnabled = true
        dataSet.setDrawHighlightIndicators(false)
        
        let data = RadarChartData(dataSets: [dataSet])
        data.setValueFont(.systemFont(ofSize: 8, weight: .light))
        data.setDrawValues(false)
        data.setValueTextColor(.black)
        data.highlightEnabled = true
        
        spiderChart.data = data
    }
}

extension EmotionSpiderView: IAxisValueFormatter
{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        return axes[Int(value) % axes.count]
    }
}

public class RadarMarkerView: MarkerView {
    @IBOutlet var label: UILabel!
    
    public override func awakeFromNib() {
        self.offset.x = -self.frame.size.width / 2.0
        self.offset.y = -self.frame.size.height - 7.0
    }
    
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        label.text = String(format: "%.2f", entry.y)
        layoutIfNeeded()
    }
}
/*
class RadarChartViewController: DemoBaseViewController {
    
    @IBOutlet var chartView: RadarChartView!
    
    let activities = ["Burger", "Steak", "Salad", "Pasta", "Pizza"]
    var originalBarBgColor: UIColor!
    var originalBarTintColor: UIColor!
    var originalBarStyle: UIBarStyle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Radar Chart"
        self.options = [.toggleValues,
                        .toggleHighlight,
                        .toggleHighlightCircle,
                        .toggleXLabels,
                        .toggleYLabels,
                        .toggleRotate,
                        .toggleFilled,
                        .animateX,
                        .animateY,
                        .animateXY,
                        .spin,
                        .saveToGallery,
                        .toggleData]
        
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        chartView.webLineWidth = 1
        chartView.innerWebLineWidth = 1
        chartView.webColor = .lightGray
        chartView.innerWebColor = .lightGray
        chartView.webAlpha = 1
        
        let marker = RadarMarkerView.viewFromXib()!
        marker.chartView = chartView
        chartView.marker = marker
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
        xAxis.xOffset = 0
        xAxis.yOffset = 0
        xAxis.valueFormatter = self
        xAxis.labelTextColor = .white
        
        let yAxis = chartView.yAxis
        yAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
        yAxis.labelCount = 5
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 80
        yAxis.drawLabelsEnabled = false
        
        let l = chartView.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .top
        l.orientation = .horizontal
        l.drawInside = false
        l.font = .systemFont(ofSize: 10, weight: .light)
        l.xEntrySpace = 7
        l.yEntrySpace = 5
        l.textColor = .white
        //        chartView.legend = l
        
        self.updateChartData()
        
        chartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.15) {
            let navBar = self.navigationController!.navigationBar
            self.originalBarBgColor = navBar.barTintColor
            self.originalBarTintColor = navBar.tintColor
            self.originalBarStyle = navBar.barStyle
            
            navBar.barTintColor = self.view.backgroundColor
            navBar.tintColor = .white
            navBar.barStyle = .black
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.15) {
            let navBar = self.navigationController!.navigationBar
            navBar.barTintColor = self.originalBarBgColor
            navBar.tintColor = self.originalBarTintColor
            navBar.barStyle = self.originalBarStyle
        }
    }
    
    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        self.setChartData()
    }
    
    func setChartData() {
        let mult: UInt32 = 80
        let min: UInt32 = 20
        let cnt = 5
        
        let block: (Int) -> RadarChartDataEntry = { _ in return RadarChartDataEntry(value: Double(arc4random_uniform(mult) + min))}
        let entries1 = (0..<cnt).map(block)
        let entries2 = (0..<cnt).map(block)
        
        let set1 = RadarChartDataSet(values: entries1, label: "Last Week")
        set1.setColor(UIColor(red: 103/255, green: 110/255, blue: 129/255, alpha: 1))
        set1.fillColor = UIColor(red: 103/255, green: 110/255, blue: 129/255, alpha: 1)
        set1.drawFilledEnabled = true
        set1.fillAlpha = 0.7
        set1.lineWidth = 2
        set1.drawHighlightCircleEnabled = true
        set1.setDrawHighlightIndicators(false)
        
        let set2 = RadarChartDataSet(values: entries2, label: "This Week")
        set2.setColor(UIColor(red: 121/255, green: 162/255, blue: 175/255, alpha: 1))
        set2.fillColor = UIColor(red: 121/255, green: 162/255, blue: 175/255, alpha: 1)
        set2.drawFilledEnabled = true
        set2.fillAlpha = 0.7
        set2.lineWidth = 2
        set2.drawHighlightCircleEnabled = true
        set2.setDrawHighlightIndicators(false)
        
        let data = RadarChartData(dataSets: [set1, set2])
        data.setValueFont(.systemFont(ofSize: 8, weight: .light))
        data.setDrawValues(false)
        data.setValueTextColor(.white)
        
        chartView.data = data
    }
    
    override func optionTapped(_ option: Option) {
        switch option {
        case .toggleXLabels:
            chartView.xAxis.drawLabelsEnabled = !chartView.xAxis.drawLabelsEnabled
            chartView.data?.notifyDataChanged()
            chartView.notifyDataSetChanged()
            chartView.setNeedsDisplay()
            
        case .toggleYLabels:
            chartView.yAxis.drawLabelsEnabled = !chartView.yAxis.drawLabelsEnabled
            chartView.setNeedsDisplay()
            
        case .toggleRotate:
            chartView.rotationEnabled = !chartView.rotationEnabled
            
        case .toggleFilled:
            for set in chartView.data!.dataSets as! [RadarChartDataSet] {
                set.drawFilledEnabled = !set.drawFilledEnabled
            }
            
            chartView.setNeedsDisplay()
            
        case .toggleHighlightCircle:
            for set in chartView.data!.dataSets as! [RadarChartDataSet] {
                set.drawHighlightCircleEnabled = !set.drawHighlightCircleEnabled
            }
            chartView.setNeedsDisplay()
            
        case .animateX:
            chartView.animate(xAxisDuration: 1.4)
            
        case .animateY:
            chartView.animate(yAxisDuration: 1.4)
            
        case .animateXY:
            chartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4)
            
        case .spin:
            chartView.spin(duration: 2, fromAngle: chartView.rotationAngle, toAngle: chartView.rotationAngle + 360, easingOption: .easeInCubic)
            
        default:
            super.handleOption(option, forChartView: chartView)
        }
    }
}

extension RadarChartViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return activities[Int(value) % activities.count]
    }
}
*/
