//
//  FMServerDescriptionDTO.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct FMServerDescriptionDTO: Decodable, Equatable {
    let code: String
    let message: String
    let status: Int
}
