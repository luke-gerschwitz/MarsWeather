//
//  ForecastViewController.swift
//  Mars Weather
//
//  Created by Luke Gerschwitz on 14/7/20.
//  Copyright © 2020 Luke Gerschwitz. All rights reserved.
//

import UIKit
import Charts

class ForecastViewController: UIViewController {

    // Sol Labels
    @IBOutlet weak var sol1: UILabel!
    @IBOutlet weak var sol2: UILabel!
    @IBOutlet weak var sol3: UILabel!
    @IBOutlet weak var sol4: UILabel!
    @IBOutlet weak var sol5: UILabel!
    @IBOutlet weak var sol6: UILabel!
    @IBOutlet weak var sol7: UILabel!
    
    // Max/Min Labels
    @IBOutlet weak var sol1Max: UILabel!
    @IBOutlet weak var sol1Min: UILabel!
    @IBOutlet weak var sol2Max: UILabel!
    @IBOutlet weak var sol2Min: UILabel!
    @IBOutlet weak var sol3Max: UILabel!
    @IBOutlet weak var sol3Min: UILabel!
    @IBOutlet weak var sol4Max: UILabel!
    @IBOutlet weak var sol4Min: UILabel!
    @IBOutlet weak var sol5Max: UILabel!
    @IBOutlet weak var sol5Min: UILabel!
    @IBOutlet weak var sol6Max: UILabel!
    @IBOutlet weak var sol6Min: UILabel!
    @IBOutlet weak var sol7Max: UILabel!
    @IBOutlet weak var sol7Min: UILabel!

    // Graph View
    @IBOutlet weak var tempGraphView: LineChartView!
    
    var didLoad:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let solLabels = [sol1, sol2, sol3, sol4, sol5, sol6, sol7]
        let forecastLabels = [sol1Max, sol1Min, sol2Max, sol2Min, sol3Max, sol3Min, sol4Max, sol4Min, sol5Max, sol5Min, sol6Max, sol6Min, sol7Max, sol7Min,]
        var forecastData = [Double]()
        var sols : [Int] = []
        
        for sol in 1...solLabels.count - 1 {
            solLabels[sol]?.isHidden = true
        }

        for forecast in 1...forecastLabels.count - 1 {
            forecastLabels[forecast]?.isHidden = true
        }
        
        
        // Establish connection with API
        let url = URL(string: "https://api.nasa.gov/insight_weather/?api_key=dA1ThJa94RSlH0K81wHbQQhM7QHgT3Bd6PefkbGN&feedtype=json&ver=1.0")!
                        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                            return
            }
                           
            // Parse the JSON data into a variable of type dictionary.
            let json = try? JSONSerialization.jsonObject(with: data, options: [])

                           
            if let dictionary = json as? [String: Any] {

                // Loop through each key in the main data dictionary, appending all the integers
                // to array. This will only append the sols.
                for (key, value) in dictionary {
                    // Add all sols json data to array
                    if (Int(key) != nil) {
                        sols.append(Int(key)!)
                    }
                }
                // Sort the array into ascending order.
                sols.sort { $0 < $1 }
                
                // Create variables to hold the data for each sol
                var dayOfWeather:Int = 0
//                var av:Double = 0
//                var minimum:Double = 0
//                var maximum:Double = 0
                            
//                var apAvData:Double = 0
//                var apMinData:Double = 0
//                var apMaxData:Double = 0
//
//                var wsAvData:Double = 0
//                var wsMinData:Double = 0
//                var wsMaxData:Double = 0
                            
                // Loops through each day
                // atm its only looping through the integers in ascending order (i.e 539 -> 540 -> 541)
                sols.forEach{day in

                    
                    // Searches the original dictionary for the data contained within the key "day" (i.e.
                    // the integer sols and storing the dictionary data within nestedDictionary
                    if let nestedDictionary = dictionary["\(day)"] as? [String: Any] {
                        // Get air temperature values for each sol
                        //self.sol.text = "Sol \(day)"
                        dayOfWeather = day
                        // Searches the nestedDictionary (containing data for a single sol) for
                        // the nested AT data (average temperature) and stores it in nestedNested
                        // as another dictionary
                        guard let nestedNested = nestedDictionary["AT"] as? [String: Any] else {
                            self.didLoad = false
                            return
                        }
                                       
                                                                        
                        // Get the maximum and minimum temperatures
                        forecastData.append(nestedNested["mx"] as! Double)
                        forecastData.append(nestedNested["mn"] as! Double)
                        
                                    
    
//                        // Searches the nestedDictionary (containing data for a single sol) for
//                        // the nested PRE data (air pressure) and stores it in nestedNested
//                        // as another dictionary
//                        guard let airPressure = nestedDictionary["PRE"] as? [String: Any] else {
//                            return
//                        }
//
//                        apAvData = airPressure["av"] as! Double
//                        // Get the maximum and minimum temperatures
//                        apMinData = airPressure["mn"] as! Double
//                        apMaxData = airPressure["mx"] as! Double
//
//
//
//                        // Searches the nestedDictionary (containing data for a single sol) for
//                        // the nested HWS data (wind speed) and stores it in nestedNested
//                        // as another dictionary
//                        guard let windSpeed = nestedDictionary["HWS"] as? [String: Any] else {
//                            return
//                        }
//
//                        wsAvData = windSpeed["av"] as! Double
//                        // Get the maximum and minimum temperatures
//                        wsMinData = windSpeed["mn"] as! Double
//                        wsMaxData = windSpeed["mx"] as! Double
                    }
                }
                DispatchQueue.main.async {
//                    var count = 0
//
//                    for sol in 1...sols.count {
//                        solLabels[count]?.isHidden = false
//                        solLabels[count]?.text = "Sol \(sols[count])"
//                        count += 1
//                    }
//
//                    count = 0
//                    for temp in 1...forecastData.count {
//                        forecastLabels[count]?.isHidden = false
//                        forecastLabels[count]?.text = "\(self.roundDec(num: forecastData[count], decimal: 1))"
//                        count += 1
//                    }
                    
                    if (self.didLoad == true) {
                        var count = 0
                        
                        for sol in 1...sols.count {
                            solLabels[count]?.isHidden = false
                            solLabels[count]?.text = "Sol \(sols[count])"
                            count += 1
                        }

                        count = 0
                        for temp in 1...forecastData.count {
                            forecastLabels[count]?.isHidden = false
                            forecastLabels[count]?.text = "\(self.roundDec(num: forecastData[count], decimal: 1))"
                            count += 1
                        }
                        self.displayTempGraph(avTemps: forecastData, sols: sols)
                    }
                    else {
                        self.createAlert(title: "Oops, data failed to load!", message: "NASA has temporarily suspended daily weather measurements for the InSight rover. Check back soon!")
                        forecastLabels[0]?.text = "N/A"
                    }
                    //self.displayTempGraph(avTemps: forecastData, sols: sols)
                }
            }
        }
        task.resume()
    }
    
    func displayTempGraph (avTemps: [Double], sols: [Int]) {
                
        // Create the line chart
        var lineChart = [ChartDataEntry]()
        var i = 0
        var count = 0

        // Add the values to the line chart
        while i < avTemps.count {
            let value = ChartDataEntry(x: Double(sols[count]), y: Double(avTemps[i]))

            lineChart.append(value)
            count += 1
            i += 2
        }

        // Create label and alter line colour
        let line1 = LineChartDataSet(entries: lineChart, label: "Maximum Temperature (°C) Per Sol")
        line1.colors = [NSUIColor.blue]

        // Add the line chart to the view
        let data = LineChartData()
        data.addDataSet(line1)
        tempGraphView.data = data

        // Formatting x-axis to remove decimals
        let numberFormatter = NumberFormatter()
        numberFormatter.generatesDecimalNumbers = false
        tempGraphView.xAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: numberFormatter)
    }
    
    
    // Method to convert a double to one or two decimal place
    func roundDec (num:Double, decimal:Int) -> Double {
        if decimal == 1 {
            return Double(round(10*num)/10)
        }
        return Double(round(100*num)/100)
    }
    
    // Alert user that NASA data has not loaded
    func createAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
