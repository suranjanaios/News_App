//
//  GlobalConstant.swift
//  condeNastTest
//
//  Created by suranjana on 31/07/20.
//  Copyright © 2020 suranjana. All rights reserved.
//
import UIKit
import Foundation
struct GlobalConstant {
    static  func getDynamicUrl()->(String){
        let today = Date()
        let thirtyDaysBeforeToday = Calendar.current.date(byAdding: .day, value: -1, to: today)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let someDateTime = formatter.string(from: thirtyDaysBeforeToday!)
        let Fetch_News_List = "http://newsapi.org/v2/everything?q=bitcoin&from=\(someDateTime)&sortBy=publishedAt&apiKey=[API_KEY]"
        return Fetch_News_List
    }
    static let likeUrl = "https://cn-news-info-api.herokuapp.com/likes/"
    static let commentUrl = "https://cn-news-info-api.herokuapp.com/comments/"
}
