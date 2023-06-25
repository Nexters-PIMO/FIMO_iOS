//
//  FMWithdrawalRequest.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

struct FMWithdrawalRequest: Requestable {
    typealias Response = FMServerDescriptionDTO

    var path: String {
        return "/auth/withdrawal"
    }

    var method: HTTPMethod {
        return .delete
    }

    var parameters: Parameters = [:]

    var header: [HTTPFields: String] {
        return [
            HTTPFields.authorization: HTTPHeaderType.authorization.header
        ]
    }
}
