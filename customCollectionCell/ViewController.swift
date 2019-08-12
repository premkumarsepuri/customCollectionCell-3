//
//  ViewController.swift
//  customCollectionCell
//
//  Created by apple on 7/31/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    var mainArray = NSMutableArray()
    
    @IBOutlet weak var secondCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        self.requestData()
          secondCollectionView.delegate = self
          secondCollectionView.dataSource = self
         secondCollectionView.register(UINib.init(nibName: "CollectionCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
    }
    
    
    
    
    
    func requestData()
    {
        
        // calling service by using alamofire
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20
        manager.request("https://newsapi.org/v2/top-headlines?country=us&apiKey=b768a78cdd5e4777af7eae8dc886170e", method:.get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    if let JSON = response.result.value as? [String: Any] {
                        print(JSON)
                        
                        var   articlesArray = (JSON as AnyObject).object(forKey: "articles") as! NSArray
                        //  print(articlesArray)
                        
                        self.mainArray.removeAllObjects()
                        for dic in articlesArray
                        {
                            var storageDic = NSMutableDictionary()
                            var urlImageValue:String?
                            
                            if let  urlToImage = (dic as AnyObject).object(forKey: "urlToImage") as? String
                            {
                                urlImageValue = urlToImage
                                print(urlImageValue)
                                
                            }else
                            {
                                urlImageValue = "https://a3.espncdn.com/combiner/i?img=%2Fphoto%2F2019%2F0731%2Fr577333_1296x729_16%2D9.jpg"
                                
                            }
                            storageDic.setValue(urlImageValue, forKey: "urlKey")
                            
                            self.mainArray.add(storageDic)
                            
                        }
                        
                        print(self.mainArray)
                        
                        DispatchQueue.main.async {
                            self.secondCollectionView.reloadData()
                        }
                        
                        
                        
                        
                    }
                case .failure(let error): break
                // error handling
                print("error")
                }
                
        }
        
    }
    
    
    
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return mainArray.count
        }
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            var cell =  secondCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionCellCollectionViewCell
    
    
            var counter =  mainArray[indexPath.row]
            var imagStr = (counter as AnyObject).object(forKey:"urlKey")
    
            URLSession.shared.dataTask(with: NSURL(string: imagStr as! String)! as URL, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    print(error ?? "No Error")
                      cell.secondImageView.image = UIImage.init(named:"picture")
                    return
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    let image = UIImage(data: data!)
                    //activityIndicator.removeFromSuperview()
                    cell.secondImageView.image = image
                })
                
            }).resume()
            
           
            
            
            
            
         
            return cell
            
            }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //var cell =  secondCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionCellCollectionViewCell
            
        
      
    }

    
    
    
    
    
    
    



    
    
    
    
    
    
    
}//  end of the class

