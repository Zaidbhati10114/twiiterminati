//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassifier = TweetSentimentalAnalysis()
    
    let swifter = Swifter(consumerKey: "eXdDO5OLc4nMc8nbjjC6Nqoav", consumerSecret:"p0vnUTFksyHadj62QGb27p4AjCcDx5XQf3akmMUDI6M0WHGmDf")

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func predictPressed(_ sender: Any) {
        
    
        if let searchText = textField.text {
                  
                  
                  swifter.searchTweet(using: searchText,lang: "en",count: 100,tweetMode:.extended , success: { (results, metadata) in
                      
                      //PASS THE JSON RESULTS
                      
                      var tweets = [TweetSentimentalAnalysisInput]()
                      
                      for i in 0..<100 {
                          
                          if let tweet = results[i]["full_text"].string {
                              
                              let tweetForClassification = TweetSentimentalAnalysisInput(text:tweet)
                              
                              tweets.append(tweetForClassification)
                              
                          }
                          
                      }
                      
                      do {
                          
                        let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
                          
                          var sentimentScore = 0
                         
                          for prediction in predictions {
                              let sentiment = prediction.label
                              
                              if sentiment == "Pos" {
                                  sentimentScore += 1
                              } else if  sentiment == "Neg" {
                                  sentimentScore -= 1
                              }
                          }
                          
                        if sentimentScore > 20 {
                            self.sentimentLabel.text = "😍"
                        } else if sentimentScore > 10 {
                        self.sentimentLabel.text = "😀"
                        } else if sentimentScore > 0 {
                        self.sentimentLabel.text = "🙂"
                        } else if sentimentScore == 0 {
                        self.sentimentLabel.text = "😐"
                        } else if sentimentScore > -10 {
                        self.sentimentLabel.text = "😕"
                        } else if sentimentScore > -20 {
                        self.sentimentLabel.text = "😡"
                        } else {
                        self.sentimentLabel.text = "🤮"
                        }
                          
                      } catch {
                          
                          print("There was an error in Making prediction,\(error)")
                          
                      }
                      
                     
                  }) { (error) in
                      print("there was an error im twiiter api Request,\(error)")
                  }
                  
              }
    
    
    }
    
}

