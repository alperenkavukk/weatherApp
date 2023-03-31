//
//  ViewController.swift
//  weatherApp3
//
//  Created by Alperen Kavuk on 28.03.2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var dailyWeatherTableView: UITableView!
    @IBOutlet weak var preCityButton: UIButton!
    @IBOutlet weak var currentIcon: UIImageView!
    @IBOutlet weak var currentSummaryLbl: UILabel!
    @IBOutlet weak var weeklySummaryLbl: UILabel!
    
    @IBOutlet weak var nextCityButton: UIButton!
    @IBOutlet weak var currentTemeraturLbl: UILabel!
    @IBOutlet weak var cityNameLbl: UILabel!
    
    
    var weather = [Weather]()
    

    var coordinateArray = [(city: String, lat: Double, lon: Double)]()
    
    var city: [CityCoordinate]? = nil
    var cityCount = (cityCount: 1, cityChoise: 0)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cityCount = (cityCount: coordinateArray.count, cityChoise: 0)
        
        reloadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //Load City from CoreData
        loadCityFromCoreData()

        dailyWeatherTableView.dataSource = self
        dailyWeatherTableView.delegate = self
        dailyWeatherTableView.rowHeight = 96
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(leftSwipe)
    }
    
    
    func loadData(urlWeather: String, competed: @escaping () -> ()) {
        
        guard let url = URL(string: urlWeather) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                let weatherLoad = try JSONDecoder().decode(Weather.self, from: data)
                
                self.weather.append(weatherLoad)
                
                DispatchQueue.main.async {
                    competed()
                }
                
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    func reloadView() {
        
        if cityCount.cityChoise != coordinateArray.count - 1 {
            preCityButton.alpha = 1
        } else {
            preCityButton.alpha = 0
        }
        if cityCount.cityChoise != 0 {
            nextCityButton.alpha = 1
        } else {
            nextCityButton.alpha = 0
        }
        
        // DarkSkyAPI
        let urlWeather = "https://api.darksky.net/forecast/a372fa32aad2af35aadfff8564fa80b8/\(coordinateArray[cityCount.cityChoise].lat),\(coordinateArray[cityCount.cityChoise].lon)/?units=si&lang=tr"
        
        loadData(urlWeather: urlWeather) {
            
            self.cityNameLbl.text = self.coordinateArray[self.cityCount.cityChoise].city
            self.weeklySummaryLbl.text = self.weather[self.cityCount.cityChoise].daily.summary
            self.currentSummaryLbl.text = self.weather[self.cityCount.cityChoise].currently.summary
            self.currentTemeraturLbl.text = String(Int(self.weather[self.cityCount.cityChoise].currently.temperature)) + "\u{00B0}"
            self.currentIcon.image = UIImage(named: self.weather[self.cityCount.cityChoise].currently.icon )
            self.dailyWeatherTableView.reloadData()
            
        }
    }
    
    func loadCityFromCoreData() {
        
        city = CoreData.fetchObject()
        for i in city! {
            coordinateArray.append((city: i.name!, lat: i.lat, lon: i.lon))
        }
        
        if coordinateArray.isEmpty {
    
            if CoreData.saveCityCoordinate(name: "Ankara", lon: 32.866287, lat: 39.925533) {
                
                city = CoreData.fetchObject()
                for i in city! {
                    coordinateArray.append((city: i.name!, lat: i.lat, lon: i.lon))
                }
            }
        }
    }
    
    
    
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .right:
                if cityCount.cityChoise != coordinateArray.count - 1 {
                    cityCount.cityChoise += 1
                    reloadView()
                } else {
                    break
                }
            case .left:
                if cityCount.cityChoise > 0 {
                    cityCount.cityChoise -= 1
                    reloadView()
                } else {
                    break
                }
            default:
                break
            }
        }
    }
    
    @IBAction func preCityButtonGo(_ sender: Any) {
    }
    @IBAction func nextCityBottonGo(_ sender: Any) {
        
        
    }
    
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! weatherTableViewCell
        
        if weather.isEmpty {
            
            cell.dataLbl.text = "--"
            cell.temperaturLbl.text = "-- - --"
            cell.summaryLbl.text = "No Internet Connection"
            cell.iconLbl.image = UIImage(named: "na")
            
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM"
            let dat = dateFormatter.string(from: Date(timeIntervalSince1970: weather[cityCount.cityChoise].daily.data[indexPath.row].time))
            
            cell.dataLbl.text = dat
            cell.temperaturLbl.text = weather[cityCount.cityChoise].daily.data[indexPath.row].tempLowHigh
            cell.summaryLbl.text = weather[cityCount.cityChoise].daily.data[indexPath.row].summary
            cell.iconLbl.image = UIImage(named: weather[cityCount.cityChoise].daily.data[indexPath.row].icon)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let degree: Double = 90
        let rotationAngle = CGFloat(degree * Double.pi / 180)
        let rotationTransform = CATransform3DMakeRotation(rotationAngle, 0, 1, 0)
        cell.layer.transform = rotationTransform

        UIView.animate(withDuration: 1, delay: 0.2, options: .curveEaseOut, animations: {
            cell.layer.transform = CATransform3DIdentity
        })
    }
    
    
    
    
    
    @IBAction func addCityButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddCityVC") as! addCityViewController
        vc.firstVC = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}

