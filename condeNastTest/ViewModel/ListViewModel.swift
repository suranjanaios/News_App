//
//  ListViewModel.swift
//  condeNastTest
//
//  Created by suranjana on 31/07/20.
//  Copyright © 2020 suranjana. All rights reserved.
//

import UIKit
import Reachability

@objc class ListViewModel : NSObject {
   @objc dynamic var NewsViewModels : [NewsViewModel]? = [NewsViewModel]()
    private var token :NSKeyValueObservation?
    var bindToNewsList :(() -> ()) = {  }
    var showErrorAlert :((Error) -> ()) = { _ in  }
    
    override init(){
        super.init()
        token = self.observe(\.NewsViewModels) { _,_ in
            
            self.bindToNewsList()
        }
        
      
      
            
        self.getNewsList()
        
        
       
    }
    func getNewsList() {
        
        webServiceManager.shared.makeRequestNewsList(urlStr: GlobalConstant.getDynamicUrl()){ news,error in
           if let err = error {
             self.showErrorAlert(err)
                
           } else{
               self.NewsViewModels = news?.compactMap(NewsViewModel.init)
            }
            
       }
        
            
        
        
    }
}
class NewsViewModel : NSObject {
    
    var id : String
    var name :String?
    var author : String?
    var title : String?
    var desc : String?
    var url : String?
    var urlToImage : String?
    var publishedAt : String?
    var content : String?
    
    init(id :String, name: String, author: String, title:String, description:String,   urlString : String,urlToImage:String,publishedAt:String,content:String ) {
        self.id = id
        self.name = name
        self.author = author
        
        self.title = title
        self.desc = description
        self.url = urlString
        
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
    
    init(news :News) {
        
        self.id = news.id
        self.name = news.name
        self.author = news.author
        
        self.title = news.title
        self.desc = news.description
        self.url = news.url
        
        self.urlToImage = news.urlToImage
        self.publishedAt = news.publishedAt
        self.content = news.content
    }
}
