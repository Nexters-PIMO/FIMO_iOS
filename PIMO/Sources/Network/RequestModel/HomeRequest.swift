//
//  HomeRequest.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/18.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

struct HomeRequest: Requestable {
    typealias Response = [Feed]
    
    var path: String {
        return ""
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters
}
