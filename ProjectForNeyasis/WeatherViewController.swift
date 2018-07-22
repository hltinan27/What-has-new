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
  var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
  
  var currentDay: CurrentlyWeather!
  var nextDays = [NextDaysArray]()
  var weatherURL = "https://api.darksky.net/forecast/14b1d29c77ae31f6833d0bda47c7d9f5/"
  var locationManager = CLLocationManager()
  var imagesToShare = [AnyObject]()
 

    override func viewDidLoad() {
        super.viewDidLoad()

      tableView.delegate = self
      tableView.dataSource = self
      
      tableView.separatorStyle = .none
      
      // Kullanıcı Location belirleme
      
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestWhenInUseAuthorization()
      locationManager.startUpdatingLocation()
      
      activityIndicator.center = self.view.center
      activityIndicator.hidesWhenStopped = true
      activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
      view.addSubview(activityIndicator)
      
      activityIndicator.startAnimating()
      
    }
  
  @IBAction func shareAction(_ sender: UIBarButtonItem) {
    
    //ScreenShoot
    UIGraphicsBeginImageContext(view.frame.size)
    view.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    imagesToShare.append(image!)
    
    let activityViewController = UIActivityViewController(activityItems: imagesToShare , applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = self.view
    present(activityViewController, animated: true, completion: nil)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return nextDays.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
    let selectRow = indexPath.row
     let cellNext = tableView.dequeueReusableCell(withIdentifier: "NextDaysCell") as! NextDaysWeatherTableViewCell
    
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "currentlyCell") as! CurrentlyTableViewCell
      if let iconName = currentDay.currently?.icon{
        cell.IconImageView.image = UIImage(named: iconName)
      }
      cell.temLabel.text = "\(currentDay.currently?.temperature.doubleToStringC ?? "")˚"
    
      return cell
    }
    else if selectRow == 1 {

      cellNext.iconImageView.image = UIImage(named: "\(nextDays[indexPath.row].icon)")
      cellNext.nextDaysTemLabel.text = "\(nextDays[indexPath.row].temperatureHigh.doubleToStringC)˚"
      cellNext.nextDaysLabel.text = getDayName(dayNumber: selectRow)

    }else if selectRow == 2 {
      cellNext.iconImageView.image = UIImage(named: "\(nextDays[indexPath.row].icon)")
      cellNext.nextDaysTemLabel.text = "\(nextDays[indexPath.row].temperatureHigh.doubleToStringC)˚"
      cellNext.nextDaysLabel.text = getDayName(dayNumber: selectRow)

    }else if selectRow == 3 {
      cellNext.iconImageView.image = UIImage(named: "\(nextDays[indexPath.row].icon)")
      cellNext.nextDaysTemLabel.text = "\(nextDays[indexPath.row].temperatureHigh.doubleToStringC)˚"
      cellNext.nextDaysLabel.text = getDayName(dayNumber: selectRow)

    }
    return cellNext
  
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    activityIndicator.stopAnimating()
  }


  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let userLocation: CLLocation = locations[0]
    let latitude = userLocation.coordinate.latitude
    let longitude = userLocation.coordinate.longitude
    
    if latitude != nil && longitude != nil{
      connectURL(url: "\(weatherURL)\(latitude),\(longitude)")
      
    }
    locationManager.stopUpdatingLocation()
    
  }
  
  // MARK: Networking and JsonDecode
  func connectURL(url: String){
    print(url)
    guard let url = URL(string: url) else {
      print("url error")
      return
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard let data = data else {
        return
      }
      
      do{
        let weather = try JSONDecoder().decode(CurrentlyWeather.self, from: data)
        let nextWeather = try JSONDecoder().decode(NextDayWeather.self, from: data)
        self.currentDay = weather
        self.nextDays = Array(nextWeather.daily.data[0...3])
        

        DispatchQueue.main.sync {
          self.tableView.reloadData()
          self.tableView.separatorStyle = .singleLine
        }
      }catch{
        print(error.localizedDescription)
        print("errrrrrrrr")
      }
      
      }.resume()
    
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

