//
//  ViewController.swift
//  WeatherApp
//
//  Created by Thanh Vuong on 1/14/18.
//  Copyright © 2018 Thanh Vuong. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var labelText: UILabel!
    @IBAction func submit(_ sender: AnyObject) {
        
        
        //This part using string separator to take the description of the weather
     /*
      if let url = URL(string: "https://www.weather-forecast.com/locations/" + textField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest"){
        
        let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            var message = ""
            
            if let error = error{
                print(error)
            }else{
                if let unwrappedData = data{
                    let dataString = NSString(data: unwrappedData,encoding: String.Encoding.utf8.rawValue)
                    var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                    if let contentArray = dataString?.components(separatedBy: stringSeparator){
                        if contentArray.count > 1{
                            stringSeparator = "</span>"
                            let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                            if newContentArray.count > 1{
                                message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                
                                print(message)
                            }
                            
                        }
                    }
                }
            }
            if message == ""{
                message = "Could not found the location. Please try again."
            }
            DispatchQueue.main.sync(execute: {
                self.labelText.text = message
            })
        }
        task.resume()
    }else{
        labelText.text = "Could not found the location. Please try again."
        }*/
 
        
        //We are now using json file to take the desciption which is more convinient
        
        if let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=" + textField.text!.replacingOccurrences(of: " ", with: "%20") + "&appid=dfb6a5ee25c70b450cb5603b461a78cc"){
        let task = URLSession.shared.dataTask(with: url){
            data,response, error in
            
            if error != nil{
                print(error)
            }else{
                if let urlContent = data{
                    do{
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                        print(jsonResult)
                        print(jsonResult["name"])
                          if let description = ((jsonResult["weather"] as? NSArray)?[0] as? NSDictionary)?["description"] as? String{
                            DispatchQueue.main.sync(execute: {
                                self.labelText.text = description
                                print(description)
                            })

                        }
                        
                    }catch{
                        print("JSON process failed")
                    }
                }
            }

        }
        
        task.resume()
        }else{
            self.labelText.text = "Could'nt find location. Please try again!"
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

