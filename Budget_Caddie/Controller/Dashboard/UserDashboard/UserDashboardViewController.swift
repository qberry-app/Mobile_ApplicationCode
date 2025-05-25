//
//  UserDashboardViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 10/02/25.
//

import UIKit
import DropDown


class UserDashboardViewController: UIViewController {

    @IBOutlet weak var GoalProgressView: UIView!
    @IBOutlet weak var top3SpendingView: UIView!
    var chartXArray: [String] = ["Food", "Groceries", "Shopping", "Outing", "Fuel"]
    var charAmountArray: [Float] = [200.0, 400.0, 600.0, 700.0, 350.0]
    @IBOutlet weak var financialShapshotChartView: DPBarChartView!
    @IBOutlet weak var financialSnapShotView: UIView!
    @IBOutlet weak var upcomingSubscriptionView: UIView!
    @IBOutlet weak var top3Spendingsprogress1: ALProgressBar!
    @IBOutlet weak var top3Spendingsprogress2: ALProgressBar!
    @IBOutlet weak var top3Spendingsprogress3: ALProgressBar!
    @IBOutlet weak var aiInsightsView: UIView!
    @IBOutlet weak var goalPieChartView: DPLineChartView!
    @IBOutlet weak var totalSpendingView: UIView!
    let dropDown = DropDown()
    @IBOutlet weak var chooseSpendingView: UIView!
    @IBOutlet weak var insightsView1: UIView!
    
    @IBOutlet weak var dashboardScrollView: UIScrollView!
    
    @IBOutlet weak var mainContentView: UIView!
    
    @IBOutlet weak var progressPercentageLabel: UILabel!
    @IBOutlet weak var spendingNameLabel: UILabel!
    var lineChartData:[String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewArray = [GoalProgressView, top3SpendingView, upcomingSubscriptionView, financialSnapShotView, insightsView1, totalSpendingView, chooseSpendingView]
        for i in viewArray {
            Utils.shared.setupCornerRadius(for: i!, borderWidth: 0.4)
        }
        Utils.shared.setupCornerRadiusAndGradient(for: aiInsightsView, borderWidth: 0.4, startColor: UIColor.init(red: 12/255, green: 123/255, blue: 179.255, alpha: 1.0), endColor: UIColor.init(red: 242/255, green: 186/255, blue: 232/255, alpha: 1.0))
        callDataSetFunctions()
        initFinancialSnapShotChart()
        dropDown.dataSource = ["Total", "Groceries", "Movies","Food", "Hiking", "Fishing", "GirlFriend"]
        dropDown.anchorView = chooseSpendingView
        dropDown.direction = .any
        
    }
    
    override func viewDidLayoutSubviews() {
        dashboardScrollView.scrollRectToVisible(CGRect(x: 0, y: 1, width: dashboardScrollView.width, height: dashboardScrollView.height), animated: true)
       
    }
    func initPieChart() {
        goalPieChartView.datasource = self
        goalPieChartView.delegate = self
        goalPieChartView.touchEnabled = true
        goalPieChartView.bezierCurveEnabled = true
        goalPieChartView.areaEnabled = false
        goalPieChartView.areaGradientEnabled = true
        goalPieChartView.xAxisTitle = "Spending"
        goalPieChartView.yAxisTitle = "Budget"
        goalPieChartView.xAxisTitleColor = UIColor.red
        goalPieChartView.yAxisTitleColor = UIColor.blue
        goalPieChartView.yAxisMinValue = 0
        goalPieChartView.yAxisMaxValue = 100
        goalPieChartView.yAxisTitleSpacing = 4
        goalPieChartView.animationsEnabled = true
        goalPieChartView.xAxisMarkersCount = lineChartData.count
        goalPieChartView.yAxisMarkersCount = 9
        goalPieChartView.markersLabelsTextFont = UIFont.systemFont(ofSize: 10.0)
        goalPieChartView.reloadData()
    }
    
    @IBAction func didClickOpenAIChat(_ sender: UIButton) {
        print("Open AI chat clicked")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatVCID") as! ChatViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
        
    }
    func callDataSetFunctions() {
        
        if let lastDay = getLastDayOfMonth(year: 2025, month: 3) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            print("Last day: \(formatter.string(from: lastDay))") // Output: 2024-02-29
            lineChartData = generateGraphLabels(startDate: "2025-03-01", endDate: lastDay.stringWithoutFormatChange())
            print(lineChartData)
            initPieChart()
        }
        setTop3SpendingsData()
    }
    
    func generateGraphLabels(startDate: String, endDate: String, dateFormat: String = "yyyy-MM-dd") -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.current

        let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "dd"
        
        guard let start = dateFormatter.date(from: startDate),
              let end = dateFormatter.date(from: endDate) else {
            return []
        }

        var labels: [String] = []
        var currentDate = start

        while currentDate <= end {
            labels.append(dayFormatter.string(from: currentDate))
            if let nextDate = Calendar.current.date(byAdding: .day, value: 3, to: currentDate) {
                currentDate = nextDate
            } else {
                break
            }
        }
        if labels.last != dayFormatter.string(from: end) {
            labels.append(dayFormatter.string(from: end))
        }
        return labels
    }
    func getLastDayOfMonth(year: Int, month: Int) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month + 1 // Move to next month
        components.day = 0 // The 0th day of the next month is the last day of the current month
        return Calendar.current.date(from: components)
    }
    @IBAction func didClickChooseSpendingType(_ sender: UIButton) {
        dropDown.show()
        dropDown.selectionAction = { (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.spendingNameLabel.text = item
            self.progressPercentageLabel.text = "\(Int.random(in: 10...100))%"
        }
    }
    func setTop3SpendingsData() {
        top3Spendingsprogress1.setProgress(0.4, animated: true)
        top3Spendingsprogress2.setProgress(0.2, animated: true)
        top3Spendingsprogress3.setProgress(0.6, animated: true)
        let spendingsArray = [top3Spendingsprogress1, top3Spendingsprogress2, top3Spendingsprogress3]
        for i in spendingsArray {
            i?.startColor = UIColor.random()
            i?.endColor = UIColor.random()
        }
    }
}
extension UserDashboardViewController: DPLineChartViewDataSource {
    func lineChartView(_ lineChartView: DPLineChartView, valueForLineAtIndex lineIndex: Int, forPointAtIndex index: Int) -> CGFloat {
        if lineIndex == 0 {
            if index == 0 {
                return 0.0
            } else if index == 1 {
                return 10.0
            } else if index == 2 {
                return 20.0
            } else if index == 3 {
                return 60.0
            } else if index == 4 {
                return 80
            } else {
                return 30.0
            }
        } else if lineIndex == 1 {
            if index == 0 {
                return 0.0
            } else if index == 1 {
                return 80.0
            } else if index == 2 {
                return 40.0
            } else if index == 3 {
                return 10.0
            } else if index == 4 {
                return 90.0
            } else {
                return 70
            }
        } else if lineIndex == 2 {
            if index == 0 {
                return 0.0
            } else if index == 1 {
                return 50.0
            } else if index == 2 {
                return 10.0
            } else {
                return 40.0
            }
        } else if lineIndex == 3 {
            if index == 0 {
                return 0.0
            } else if index == 1 {
                return 20.0
            } else if index == 2 {
                return 100.0
            } else {
                return 50.0
            }
        } else if lineIndex == 4 {
            if index == 0 {
                return 0.0
            } else if index == 1 {
                return 50.0
            } else if index == 2 {
                return 100.0
            } else {
                return 70.0
            }
        }
        return 0.0
    }
    
    func numberOfLines(_ lineChartView: DPLineChartView) -> Int {
        return 2
    }
    
    func numberOfPoints(_ lineChartView: DPLineChartView) -> Int {
        return 5
    }
    func lineChartView(_ lineChartView: DPLineChartView, colorForLineAtIndex lineIndex: Int) -> UIColor {
        UIColor.random()
    }
    func lineChartView(_ lineChartView: DPLineChartView, widthForLineAtIndex lineIndex: Int) -> CGFloat {
        return 1.5
    }
    func lineChartView(_ lineChartView: DPLineChartView, yAxisLabelAtIndex index: Int, for value: CGFloat) -> String? {
        if index == 0 {
            return "$ 0"
        } else if index == 1 {
            return "$ 12"
        } else if index == 2 {
            return "$ 25"
        } else if index == 3 {
            return "$ 37"
        } else if index == 4 {
            return "$ 50"
        } else if index == 5 {
            return "$ 62"
        } else if index == 6 {
            return "$ 75"
        } else if index == 7 {
            return "$ 87"
        } else if index == 8 {
            return "$ 100"
        }
        return ""
    }
    func lineChartView(_ lineChartView: DPLineChartView, xAxisLabelAtIndex index: Int) -> String? {
        lineChartData[index]
    }
}
extension UserDashboardViewController: DPLineChartViewDelegate {
    func lineChartView(_ lineChartView: DPLineChartView, didTouchAtIndex index: Int) {
        
    }
    
    func lineChartView(_ lineChartView: DPLineChartView, didReleaseTouchFromIndex index: Int) {
        print(index)
    }
}

extension UserDashboardViewController {
    func initFinancialSnapShotChart() {
        createBarChart(stacked: true, yAxisInverted: false)
    }
    func createBarChart(stacked: Bool, yAxisInverted: Bool) {
        
        financialShapshotChartView.datasource = self
        financialShapshotChartView.delegate = self
        financialShapshotChartView.barStacked = stacked
        financialShapshotChartView.axisColor = .lightGray
        financialShapshotChartView.markersLabelsTextColor = .lightGray
        financialShapshotChartView.markersLineColor = .lightGray
        financialShapshotChartView.xAxisTitle = "Expenses"
        financialShapshotChartView.barSpacing = 40.0
        financialShapshotChartView.yAxisInverted = yAxisInverted
        financialShapshotChartView.yAxisMarkersWidthRetained = true
        financialShapshotChartView.yAxisTitle = "Amount"
        financialShapshotChartView.topSpacing = 8
        financialShapshotChartView.translatesAutoresizingMaskIntoConstraints = false
        financialShapshotChartView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        financialShapshotChartView.reloadData()
    }
}
extension UserDashboardViewController: DPBarChartViewDataSource {
    func barChartView(_ barChartView: DPBarChartView, valueForDatasetAtIndex datasetIndex: Int, forItemAtIndex index: Int) -> CGFloat {
        return CGFloat(charAmountArray[index])
    }
    
    func numberOfDatasets(_ barChartView: DPBarChartView) -> Int {
        return 2
    }
    
    func numberOfItems(_ barChartView: DPBarChartView) -> Int {
        return 5
    }
    
    func barChartView(_ barChartView: DPBarChartView, xAxisLabelForItemAtIndex index: Int) -> String? {
        return chartXArray[index]
        
    }
    func barChartView(_ barChartView: DPBarChartView, yAxisLabelAtIndex index: Int, for value: CGFloat) -> String? {
        return "\(index * 100)"
    }
    func barChartView(_ barChartView: DPBarChartView, colorForDatasetAtIndex datasetIndex: Int) -> UIColor {
        UIColor.init(red: 94/255, green: 64/255, blue: 190/255, alpha: 1.0)
    }
}
extension UserDashboardViewController: DPBarChartViewDelegate {
    func barChartView(_ barChartView: DPBarChartView, didTouchAtItem index: Int) {
        
    }
    func barChartView(_ barChartView: DPBarChartView, didReleaseTouchFromItem index: Int) {
        
    }
    
}

