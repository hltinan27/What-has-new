//
//  WeatherViewController.swift
//  ProjectForNeyasis
//
//  Created by inan on 20.07.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit
import MapKit

let api: String = "4fca2485d59a4602ab4ac76f292d6a72"
class WeatherViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
  @IBOutlet weak var tableView: UITableView!
  
  var weatherURL = "https://api.darksky.net/forecast/14b1d29c77ae31f6833d0bda47c7d9f5/"
  var locationManager = CLLocationManager()
  var weatherCurrentlyDay = WeatherDataModel()
  var weatherNextFirstDay = WeatherDataModel()
  var weatherNextSecondDay = WeatherDataModel()
  var weatherNextThirdDay = WeatherDataModel()
 

    override func viewDidLoad() {
        super.viewDidLoad()

      tableView.delegate = self
      tableView.dataSource = self
      
      // Kullanıcı Location belirleme
      
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestWhenInUseAuthorization()
      locationManager.startUpdatingLocation()
      
      
      
    }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
    let selectRow = indexPath.row
     let cellNext = tableView.dequeueReusableCell(withIdentifier: "NextDaysCell") as! NextDaysWeatherTableViewCell
    
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "currentlyCell") as! CurrentlyTableViewCell
      print(weatherCurrentlyDay)
      cell.IconImageView.image = UIImage(named: "\(weatherCurrentlyDay.weatherIconName)")
      cell.temLabel.text = "\(weatherCurrentlyDay.temperature)˚"
      return cell
    }else if selectRow == 1 {
      
      cellNext.iconImageView.image = UIImage(named: "\(weatherNextFirstDay.weatherIconName)")
      cellNext.nextDaysTemLabel.text = "\(weatherNextFirstDay.temperature)˚"
      cellNext.nextDaysLabel.text = getDayName(dayNumber: selectRow)
      
    }else if selectRow == 2 {
      cellNext.iconImageView.image = UIImage(named: "\(weatherNextSecondDay.weatherIconName)")
      cellNext.nextDaysTemLabel.text = "\(weatherNextSecondDay.temperature)˚"
      cellNext.nextDaysLabel.text = getDayName(dayNumber: selectRow)
      
    }else if selectRow == 3 {
      cellNext.iconImageView.image = UIImage(named: "\(weatherNextThirdDay.weatherIconName)")
      cellNext.nextDaysTemLabel.text = "\(weatherNextThirdDay.temperature)˚"
      cellNext.nextDaysLabel.text = getDayName(dayNumber: selectRow)
      
    }
    return cellNext
  }
  
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let userLocation: CLLocation = locations[0]
    let latitude = userLocation.coordinate.latitude
    let longitude = userLocation.coordinate.longitude
    
    if latitude != nil && longitude != nil{
      getTodayResult(url: "\(weatherURL)\(latitude),\(longitude)")
    }
    locationManager.stopUpdatingLocation()
    
  }
  
  
   //MARK: - Networking
  
  func getTodayResult(url: String){
    print(url)

    if let url = URL(string: url){
      let request = URLRequest(url: url)
      
      let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if error == nil {
          if let incomingData = data {
            
            do{
              let jsonResult = try JSONSerialization.jsonObject(with: incomingData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
              //print(jsonResult)
              self.updateWeatherData(jsonResult: jsonResult)
              
            }catch{
              
            }
          }
        }else{
          print(error?.localizedDescription)
        }
      }
      task.resume()
    }
    
    
  }
  
  
   func updateWeatherData(jsonResult : AnyObject){
    
    let weather = jsonResult["currently"] as! [String: AnyObject]
    let city = jsonResult["timezone"] as! String
    let daily = jsonResult["daily"] as AnyObject
    let weatherDaily = daily["data"] as! NSArray
    let NextFirst = weatherDaily.firstObject as! [String: AnyObject]
    let NextSecond = weatherDaily[1] as! [String: AnyObject]
    let NextThird = weatherDaily[2] as! [String: AnyObject]
    
    let dene = NextFirst["temperature"] as? Double
    print("Denee:\(dene)")
    
    weatherCurrentlyDay.city = city
    
    if let currentlyIcon = weather["icon"] as? String, let currentlyTem = weather["temperature"] as? Double{
     weatherCurrentlyDay.weatherIconName = currentlyIcon
      weatherCurrentlyDay.temperature = currentlyTem.doubleToStringC
    }
    
    
    if let NextFirstIcon = NextFirst["icon"] as? String, let NextFirstTem = NextFirst["temperatureMax"] as? Double {
      weatherNextFirstDay.weatherIconName = NextFirstIcon
      weatherNextFirstDay.temperature = NextFirstTem.doubleToStringC
      
    }
    
    if let NextSecondIcon = NextSecond["icon"] as? String, let NextSecondTem = NextSecond["temperatureMax"] as? Double {
      weatherNextSecondDay.weatherIconName = NextSecondIcon
      weatherNextSecondDay.temperature = NextSecondTem.doubleToStringC
    }
    
    if let NextThirdIcon = NextThird["icon"] as? String, let NextThirdTem = NextThird["temperatureMax"] as? Double {
      weatherNextThirdDay.weatherIconName = NextThirdIcon
      weatherNextThirdDay.temperature = NextThirdTem.doubleToStringC
      
    }
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
    

    
  }
  
  // Get day name
  func getDayName(dayNumber: Int) -> String{
    
    let datecurrent = Date()
    let calendar = Calendar.current
    let date = calendar.date(byAdding: .day, value: dayNumber, to: datecurrent)
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    let utcTimeZoneStr = formatter.string(from: date!)
    return utcTimeZoneStr
    
  }
  
  
  
  // MARK:didFailWithError method
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error.localizedDescription)
    
  }

  
  


}

extension Double {
  
  var doubleToStringC: String {
    
    return String(format: "%.0f", (self-32)/1.8)
  }
}

