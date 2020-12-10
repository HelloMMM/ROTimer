//
//  TimerVM.swift
//  ROTimer
//
//  Created by Miles on 2020/12/3.
//

import Foundation

class TimerVM {
    
    var person: Observable<Bool> = Observable(true)
    private let mvpList = ["皮里恩", "蜂后", "虎王", "魔鬼大烏賊", "蟻后", "獸人英雄", "法老王", "獸人酋長"]
    private let miniList = ["藍瘋兔", "龍蠅", "波利之王", "幽靈波利", "大腳龍蝦", "蛙王", "天使波利", "惡魔波利"]
    var mvpModel: [TimerModel]!
    var miniModel: [TimerModel]!
    
    func initData() {
        
        if let mvpModels = UserDefaults.standard.codableObject(dataType: [TimerModel].self, key: "mvpDatas") {
            
            mvpModel = mvpModels
        } else {
            mvpModel = mvpList.map({ TimerModel(monsterName: $0 , timer: 0) })
        }
         
        if let miniModels = UserDefaults.standard.codableObject(dataType: [TimerModel].self, key: "miniDatas") {
            
            miniModel = miniModels
        } else {
            miniModel = miniList.map({ TimerModel(monsterName: $0 , timer: 0) })
        }
        
        person.value = true
    }
    
    func saveData() {
        
        UserDefaults.standard.setCodableObject(data: mvpModel, forKey: "mvpDatas")
        UserDefaults.standard.setCodableObject(data: miniModel, forKey: "miniDatas")
        person.value = true
    }
}
