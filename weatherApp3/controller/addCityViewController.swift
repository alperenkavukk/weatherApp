//
//  addCityViewController.swift
//  weatherApp3
//
//  Created by Alperen Kavuk on 28.03.2023.
//

import UIKit

class addCityViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var lonLbl: UILabel!
    @IBOutlet weak var latLbl: UILabel!
    
    @IBOutlet weak var addCityTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var backButton: DisignableButton!
    @IBOutlet weak var startButton: DisignableButton!
    @IBOutlet weak var cityLbl: UILabel!
   
    var firstVC: ViewController!
    
    var cityFaind3 = AddCity.Results.Geometry.Location.init(lat: 0, lng: 0)
    var cityName = AddCity.Results.AddressComponent.init(long_name: "No")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCityTextField.delegate = self

    }
    
    func loadData(nameOfCityFrom: String, competed: @escaping () -> ()) {
        
        let nameOfCity = nameOfCityFrom.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let newUrl = "https://maps.googleapis.com/maps/api/geocode/json?address=\(nameOfCity!)&key=AIzaSyApLMMOjIb-R6XGw4CuAJxtQhqVdF79F98"
        
        guard let url = URL(string: newUrl) else { fatalError() }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { fatalError() }
            guard error == nil else { fatalError() }
            
            do {
                let loadFromGoogle = try JSONDecoder().decode(AddCity.self, from: data)
                self.cityFaind3.lat = loadFromGoogle.results[0].geometry.location.lat
                self.cityFaind3.lng = loadFromGoogle.results[0].geometry.location.lng
                self.cityName.long_name = loadFromGoogle.results[0].address_components[0].long_name
                
                DispatchQueue.main.async {
                    competed()
                }
                
            } catch let error {
                print(error)
            }
            }.resume()
    }
    
    @IBAction func startSearchCity(_ sender: Any) {
        
        view.endEditing(true)
        
        if addCityTextField.text != "" {
            
            let nameOfCityFromTextField = addCityTextField.text!
            
            loadData(nameOfCityFrom: nameOfCityFromTextField) {
                print(self.cityName.long_name!)
                print("\(self.cityFaind3.lat!) + \(self.cityFaind3.lng!)")
                
                self.cityLbl.text = String(self.cityName.long_name!)
                self.latLbl.text = String(self.cityFaind3.lat!)
                self.lonLbl.text = String(self.cityFaind3.lng!)
                
                UIView.animate(withDuration: 1, delay: 0.2, animations: {
                    self.cityLbl.alpha = 1
                }, completion: { (true) in
                    UIView.animate(withDuration: 1, delay: 0.2, animations: {
                        self.latLbl.alpha = 1
                    }, completion: { (true) in
                        UIView.animate(withDuration: 1, delay: 0.2, animations: {
                            self.lonLbl.alpha = 1
                        }, completion: { (true) in
                            UIView.animate(withDuration: 1, delay: 0.2, animations: {
                                //self.startButton.alpha = 1
                            }, completion: nil)
                        })
                    })
                })
            }
        } else {
            let alert = UIAlertController(title: "Error", message: " şehir giriniz", preferredStyle: .actionSheet)
            let ok = UIAlertAction(title: "oK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true)
        }
    }
    
    

    @IBAction func startButton(_ sender: Any) {
        
        let coordinate: (city: String, lat: Double, lon: Double) = (self.cityName.long_name!, Double(self.cityFaind3.lat!), Double(self.cityFaind3.lng!))
        
        firstVC.coordinateArray.insert(coordinate, at: 0)
        firstVC.cityCount.cityChoise = 0
        
        firstVC.reloadView()
        
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func exitButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
