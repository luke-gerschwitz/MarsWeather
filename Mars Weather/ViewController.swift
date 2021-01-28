//
//  ViewController.swift
//  Mars Weather
//
//  Created by Luke Gerschwitz on 19/6/20.
//  Copyright © 2020 Luke Gerschwitz. All rights reserved.
//

import UIKit
import DeviceKit

class ViewController: UIViewController {

    
    @IBOutlet weak var sol: UILabel!
    @IBOutlet weak var averageTemp: UILabel!
    @IBOutlet weak var min: UILabel!
    @IBOutlet weak var max: UILabel!
    
    // Headings for weather data on main page
    // Accompanying logos
    @IBOutlet weak var atmosphericTempHeading: UILabel!
    @IBOutlet weak var atmosphericPressureHeading: UILabel!
    @IBOutlet weak var windSpeedHeading: UILabel!
    
    @IBOutlet weak var thermometerLogo: UIImageView!
    @IBOutlet weak var pressureLogo: UIImageView!
    @IBOutlet weak var windLogo: UIImageView!
    
    // Labels for weather data
    @IBOutlet weak var apAverage: UILabel!
    @IBOutlet weak var apMax: UILabel!
    @IBOutlet weak var apMin: UILabel!
    @IBOutlet weak var wsAverage: UILabel!
    @IBOutlet weak var wsMax: UILabel!
    @IBOutlet weak var wsMin: UILabel!
    
    @IBOutlet weak var mainBackground: UIImageView!
    
    // Testing out side menu
    // May not need four below
    @IBOutlet weak var scrollLeading: NSLayoutConstraint!
    @IBOutlet weak var scrollTrailing: NSLayoutConstraint!
    @IBOutlet weak var backgroundLeading: NSLayoutConstraint!
    @IBOutlet weak var backgroundTrailing: NSLayoutConstraint!

    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var sideMenuLeading: NSLayoutConstraint!
    @IBOutlet weak var sideMenuTrailing: NSLayoutConstraint!
    
    
    @IBOutlet weak var forecastBtn: UIButton!
    @IBOutlet weak var aboutBtn: UIButton!
    
    
    @IBOutlet weak var sidebar: UIView!
    
    
    
    
    // To check if user has selected the side menu
    var menuOut = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Setting correct background depending on user device
        // Sets secondary background as main background for all "small" iphones.
        let device = Device.current
        if device != .iPhoneX || device != .iPhoneXR || device != .iPhoneXSMax || device != .iPhoneXS || device != .iPhone11 || device != .iPhone11Pro || device != .iPhone11ProMax{
            
            mainBackground.image = UIImage(named:"SecondaryBackground")
        }
        
        
        // Setting heading width and image positioning to work with different screen widths
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
       //let screenHeight = screenSize.height
        
        // Remove sidebar if using an ipad.
        // Temporary fix until proper sidebar implementation
        if UIDevice.current.userInterfaceIdiom == .pad {
            // Available Idioms - .pad, .phone, .tv, .carPlay, .unspecified
            navigationController?.setNavigationBarHidden(true, animated: false)
            sidebar.isHidden = true
            
            // Also increase width of headings for ipads
            self.atmosphericTempHeading.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.95, height: 32)
            self.atmosphericPressureHeading.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.95, height: 32)
            self.windSpeedHeading.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.95, height: 32)
        }
        else {
            self.atmosphericTempHeading.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.90, height: 32)
            self.atmosphericPressureHeading.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.90, height: 32)
            self.windSpeedHeading.frame = CGRect(x: 0, y: 0, width: screenWidth * 0.90, height: 32)
        }
        

        
        // Add bottom border to headings
        addTopAndBottomBorders()
        
        // Establish connection with the NASA Insight API.    
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
                    var sols : [Int] = []
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
                    var av:Double = 0
                    var minimum:Double = 0
                    var maximum:Double = 0
                    
                    var apAvData:Double = 0
                    var apMinData:Double = 0
                    var apMaxData:Double = 0
                    
                    var wsAvData:Double = 0
                    var wsMinData:Double = 0
                    var wsMaxData:Double = 0
                    
                    var didLoad:Bool = true
                    
                    // Loops through each day
                    // atm its only looping through the integers in ascending order (i.e 539 -> 540 -> 541)
                    sols.forEach{day in

                        // Searches the original dictionary for the data contained within the key "day" (i.e.
                        // the integer sols and storing the dictionary data within nestedDictionary)
                        if let nestedDictionary = dictionary["\(day)"] as? [String: Any] {
                            // Get air temperature values for each sol
                            //self.sol.text = "Sol \(day)"
                            dayOfWeather = day
                                                        
                            // Searches the nestedDictionary (containing data for a single sol) for
                            // the nested AT data (average temperature) and stores it in nestedNested
                            // as another dictionary

                            guard let nestedNested = nestedDictionary["AT"] as? [String: Any] else {
                                didLoad = false
                                return
                            }
                            
                            // Get average temperature
                            av = nestedNested["av"] as! Double

                            // Get the maximum and minimum temperatures
                            minimum = nestedNested["mn"] as! Double
                            maximum = nestedNested["mx"] as! Double
                            
                            
                            // Searches the nestedDictionary (containing data for a single sol) for
                            // the nested PRE data (air pressure) and stores it in nestedNested
                            // as another dictionary
                            guard let airPressure = nestedDictionary["PRE"] as? [String: Any] else {
                                return
                            }

                            // Get air pressure values
                            apAvData = airPressure["av"] as! Double
                            // Get the maximum and minimum temperatures
                            apMinData = airPressure["mn"] as! Double
                            apMaxData = airPressure["mx"] as! Double
                        


                            
                            // Searches the nestedDictionary (containing data for a single sol) for
                            // the nested HWS data (wind speed) and stores it in nestedNested
                            // as another dictionary
                            guard let windSpeed = nestedDictionary["HWS"] as? [String: Any] else {
                                return
                            }

                            // Get wind speed values
                            wsAvData = windSpeed["av"] as! Double
                            // Get the maximum and minimum temperatures
                            wsMinData = windSpeed["mn"] as! Double
                            wsMaxData = windSpeed["mx"] as! Double     
                        }
                    }
                    DispatchQueue.main.async {
                        
                        // Print all the data to text fields
                        self.sol.text = "Sol \(dayOfWeather)"
                        self.averageTemp.text = "\(self.roundDec(num: av, decimal: 1)) °C"
                        self.min.text = "\(self.roundDec(num: minimum, decimal: 1)) °C"
                        self.max.text = "\(self.roundDec(num: maximum, decimal: 1)) °C"
                        
                        self.apAverage.text = "\(self.roundDec(num: apAvData, decimal: 1)) Pa"
                        self.apMax.text = "\(self.roundDec(num: apMaxData, decimal: 1)) Pa"
                        self.apMin.text = "\(self.roundDec(num: apMinData, decimal: 1)) Pa"
                        
                        self.wsAverage.text = "\(self.roundDec(num: wsAvData, decimal: 2)) m/s"
                        self.wsMax.text = "\(self.roundDec(num: wsMaxData, decimal: 2)) m/s"
                        self.wsMin.text = "\(self.roundDec(num: wsMinData, decimal: 2)) m/s"
                        
                        // If data has failed to load, present error message to the user
                        if didLoad == false {
                            self.createAlert(title: "Oops, data failed to load!", message: "NASA has temporarily suspended daily weather measurements for the InSight rover. Check back soon!")
                            
                            // Update data fields
                            self.averageTemp.text = "N/A °C"
                            self.min.text = "N/A °C"
                            self.max.text = "N/A °C"
                            
                            self.apAverage.text = "N/A Pa"
                            self.apMax.text = "N/A Pa"
                            self.apMin.text = "N/A Pa"
                            
                            self.wsAverage.text = "N/A m/s"
                            self.wsMax.text = "N/A m/s"
                            self.wsMin.text = "N/A m/s"
                        }
                    }
                }
        }
        task.resume()
    }
    
    // When user taps menu button at top left, animate screen
    // to display sidebar menu
    @IBAction func menuTapped(_ sender: Any) {
        
        if menuOut == false {
            forecastBtn.isHidden = false
            aboutBtn.isHidden = false
            sideMenuTrailing.constant = 240
            menuOut = true
        } else {
            forecastBtn.isHidden = true
            aboutBtn.isHidden = true
            sideMenuTrailing.constant = 422
            menuOut = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    
    // Function to add border to top and bottom of a label
    func addTopAndBottomBorders() {
       let thickness: CGFloat = 2.0
       let bottomBorder = CALayer()
       bottomBorder.frame = CGRect(x:0, y: self.atmosphericTempHeading.frame.size.height - thickness, width: self.atmosphericTempHeading.frame.size.width, height:thickness)
        bottomBorder.backgroundColor = UIColor.white.cgColor
       atmosphericTempHeading.layer.addSublayer(bottomBorder)
        
        // Creating bottom border for atmospheric pressure
        let bBorderAP = CALayer()
        bBorderAP.frame = CGRect(x:0, y: self.atmosphericPressureHeading.frame.size.height - thickness, width: self.atmosphericPressureHeading.frame.size.width, height:thickness)
         bBorderAP.backgroundColor = UIColor.white.cgColor
        atmosphericPressureHeading.layer.addSublayer(bBorderAP)
        
        // Creating bottom border for wind speed
        let bBorderWS = CALayer()
        bBorderWS.frame = CGRect(x:0, y: self.windSpeedHeading.frame.size.height - thickness, width: self.windSpeedHeading.frame.size.width, height:thickness)
         bBorderWS.backgroundColor = UIColor.white.cgColor
        windSpeedHeading.layer.addSublayer(bBorderWS)
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
}
