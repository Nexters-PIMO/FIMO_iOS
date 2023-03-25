//
//  String+.swift
//  PIMO
//
//  Created by 김영인 on 2023/03/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

extension String {
    
    /*
     업로드 시간
     : 0초 전, 0분 전, 0시간 전, 0일 전, 0달 전, 0년 전
     */
    
    func toUploadTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddhhmmss"
        
        guard let date = dateFormatter.date(from: self) else {
            return "-"
        }
        
        let currentDate = Date()
        let calender = Calendar.current
        
        let second = calender.dateComponents([.second], from: date, to: currentDate).second ?? 0
        if second < 60 {
            return "\(second)초 전"
        }
        
        let minute = calender.dateComponents([.minute], from: date, to: currentDate).minute ?? 0
        if minute < 60 {
            return "\(minute)분 전"
        }
        
        let hour = calender.dateComponents([.hour], from: date, to: currentDate).hour ?? 0
        if hour < 24 {
            return "\(hour)시간 전"
        }
        
        let day = calender.dateComponents([.day], from: date, to: currentDate).day ?? 0
        if day < 30 {
            return "\(day)일 전"
        }

        let month = calender.dateComponents([.month], from: date, to: currentDate).month ?? 0
        if month < 12 {
            return "\(month)달 전"
        }
        
        let year = calender.dateComponents([.year], from: date, to: currentDate).year ?? 0
        return "\(year)년 전"
    }
}
