//
//  ViewController.swift
//  MyMovieAppWeber
//
//  Created by JUSTIN WEBER on 1/17/25.
//

struct Movie: Codable{
    var Title: String
    //var Actors: String
   // var Country: String
    //var Director: String
    //var Metascore: String
    //var Ratings: [Rating]
}

struct Rating: Codable{
    var Source: String
    var Value: String
}

import UIKit
import SwiftUI

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var count = 0
    var movies = [String]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesOutlet.dequeueReusableCell(withIdentifier: "myMovie")
        
        cell?.textLabel?.text = movies[indexPath.row]
        
        return cell!
    }
    
    
    @IBOutlet weak var enterMovieOutlet: UITextField!

    @IBOutlet weak var moviesOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        moviesOutlet.delegate = self
        moviesOutlet.dataSource = self
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        getMovies()
    }
    
    func getMovies(){
        let session = URLSession.shared
        
        let movieURL = URL(string: "http://www.omdbapi.com/?s=\(enterMovieOutlet.text!)&apikey=c6f69ff1")!
        
        let dataTask = session.dataTask(with: movieURL) { data, response, error in
            if let e = error{
                let alert = UIAlertController(title: "Error!", message: "\(e)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async{
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else{
                if let d = data{
                    if let jsonObj = try? JSONSerialization.jsonObject(with: d, options: .fragmentsAllowed) as? NSDictionary{
//                        print(jsonObj)
                        
                        if let theSearch = jsonObj.value(forKey: "Search") as? [NSDictionary]{
                            print(theSearch)
                            
                            self.count = theSearch.count
                            
                            self.movies = []
                            
                            for i in 0..<theSearch.count{
                                let theTitle = theSearch[i]["Title"]!
                                print(theTitle)
                                self.movies.append(theTitle as! String)
                            }
                            
//                            self.movies = []
//                            
//                            for i in 0...theSearch.count{
//                                movies.append(theSearch[0]["Title"]!)
//                            }
//                            if let movieObj = try? JSONDecoder().decode(Movie.self, from: d){
//                        print(movieObj.Title)
////                        for r in movieObj.Ratings{
////                            print("Rating \(r.Source): \(r.Value)")
////                        }
//                    }
//                    else{
//                        print("Error decoding")
//                    }
                            
                            
                            DispatchQueue.main.async{
                                self.moviesOutlet.reloadData()
                            }
                        }
                    }
                    else{
                        print("Cannot convert to json")
                    }
                }
                else{
                    print("Could not get data")
                }
            }
        }
        dataTask.resume()
    }
    
    
    
    


}

