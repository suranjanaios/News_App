//
//  webServiceManager.swift
//  condeNastTest
//
//  Created by suranjana on 31/07/20.
//  Copyright © 2020 suranjana. All rights reserved.
//

import UIKit

class webServiceManager{
    static let shared = webServiceManager()
    var session:URLSession = URLSession.shared
    
    private init(){}
    
    func makeServiceCall(jsonData:Data,completion:@escaping((_ news:[News]?) -> ())){
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let newsDict  = try? decoder.decode(NewsList.self, from: jsonData)
        guard let updatedArticles = newsDict?.articles else {
            completion(nil)
            return
            
        }
        let newsArr = updatedArticles
        completion(newsArr )
        
        
    }
    
    func  makeRequestNewsList(urlStr:String,completion :@escaping (_ news:[News]?,_ error :Error?) -> ()){
        
        let urlString = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let finalUrlString = urlString  else
        {   print("return")
            return
            
        }
        let url = URL(string: finalUrlString)
        guard let finalUrl = url else { return }
        let urlRequest = URLRequest(url: finalUrl)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil,error)
                return
            }
            self.makeServiceCall(jsonData:data){ (news) in
               
                DispatchQueue.main.async {
                    completion(news,nil)
                }
            }
            
            
        }
        dataTask.resume()
        
    }
    /////////////////////////////////////////////////// Like ////////////////////////////////////////////////////////////
    func parseLike(jsonData:Data,completion:@escaping((Like) -> ())){
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let likeDict  = try? decoder.decode(Like.self, from: jsonData) else { return  }
        completion(likeDict)
        
        
    }
    
    func  makeRequestLike(urlStr:String,completion :@escaping (_ like:Like?,_ error:Error?) -> ()){
        
        let urlString = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let finalUrlString = urlString  else {return }
        let url = URL(string: finalUrlString)
        guard let finalUrl = url else { return }
        let urlRequest = URLRequest(url: finalUrl)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completion(nil,error)
                return
            }
            
            self.parseLike(jsonData:data){ likes in
                
                DispatchQueue.main.async {
                    completion(likes, nil)
                }
            }
            
            
        }
        dataTask.resume()
        
    }
    //////////////////////////////////////////Comment///////////////
    
    func parseComment(jsonData:Data,completion:@escaping((Comment) -> ())){
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let commentDict  = try? decoder.decode(Comment.self, from: jsonData) else { return  }
        completion(commentDict)
        
        
        
    }
    
    func  makeRequestComment(urlStr:String,completion :@escaping (_ comment:Comment?,_ error:Error?)  -> ()){
        
        let urlString = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
       // print("urlStr=====================",urlStr)
        guard let finalUrlString = urlString  else {return }
        let url = URL(string: finalUrlString)
        guard let finalUrl = url else { return }
        let urlRequest = URLRequest(url: finalUrl)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil,error)
                return
            }
            self.parseComment(jsonData:data){ comments in
                
                DispatchQueue.main.async {
                    completion(comments,nil)
                }
            }
            
            
        }
        dataTask.resume()
        
    }
    
}






