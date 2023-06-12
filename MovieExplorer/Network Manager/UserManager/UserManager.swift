//
//  UserManager.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 12/06/2023.
//

import Foundation

class UserManager {
    func setSkippedContent(_ totalExericeDurationTime: [Int]) {
        let encodedData = try? JSONEncoder().encode(totalExericeDurationTime)
        UserDefaults.standard.set(encodedData, forKey: "addFavoiteMovie")
        
    }


    func readSkippedContent() ->  [Int] {
        guard let savedData = UserDefaults.standard.object(forKey:  "addFavoiteMovie") as? Data, let skipped = try? [Int].decode(data: savedData) else { return []}
        
        return skipped
    }
}
