//
//  WeatherDataModel.swift
//  ProjectForNeyasis
//
//  Created by inan on 20.07.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit

struct CurrentlyWeather: Codable {
  let currently: Today?
}

struct Today: Codable {
  let icon: String?
  let temperature: Double?
}

struct NextDayWeather: Codable {
  let daily: DayData
}

struct DayData: Codable {
  let data: [NextDaysArray]
}

struct NextDaysArray: Codable {
  let icon: String
  let temperatureHigh: Double
}

