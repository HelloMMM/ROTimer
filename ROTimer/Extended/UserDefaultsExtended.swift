//
//  UserDefaultsExtended.swift
//  ROTimer
//
//  Created by Miles on 2020/12/3.
//

import Foundation
import UIKit

extension UserDefaults {
    
    func setCodableObject<T: Codable>(data: T?, forKey: String) {
        
        let encoded = try? JSONEncoder().encode(data)
        set(encoded, forKey: forKey)
    }
    
    func codableObject<T: Codable>(dataType: T.Type, key: String) -> T? {
        
        guard let userDefaultData = data(forKey: key) else {
            return nil
        }
        
        return try? JSONDecoder().decode(T.self, from: userDefaultData)
    }
}
