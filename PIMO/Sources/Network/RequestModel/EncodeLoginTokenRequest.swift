//
//  EncodeLoginTokenRequest.swift
//  PIMO
//
//  Created by 양호준 on 2023/03/17.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

struct EncodeLoginTokenRequest: Requestable {
    typealias Response = EncodeLogin

    var path: String {
        return "/login/encode"
    }

    var method: Alamofire.HTTPMethod {
        return .get
    }

    var parameters: Parameters
}
