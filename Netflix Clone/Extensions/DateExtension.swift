//
//  DataExtension.swift
//  Netflix Clone
//
//  Created by Всеволод Буртик on 02.01.2025.
//

import Foundation

extension Date{
    func convertToForm(_ dateString: String) -> String{
        let dateFotmatter = DateFormatter()
        dateFotmatter.dateFormat = "yyyy-MM-dd"
        dateFotmatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFotmatter.date(from: dateString) {
            let displayFromatter = DateFormatter()
            displayFromatter.dateStyle = .long
            return displayFromatter.string(from: date)
        } else {
            return dateFotmatter.string(from: Date(timeIntervalSince1970: TimeInterval()))
        }
    }
    
    
}
