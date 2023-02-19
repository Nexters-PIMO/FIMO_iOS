//
//  String+regex.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/16.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

extension String {
    func match(for regex: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: regex) else {
            return false
        }

        return regex.matches(in: self, range: NSRange(self.startIndex..., in: self)).count > 0
    }
}
