//
//  TimerVM.swift
//  ROTimer
//
//  Created by Miles on 2020/12/3.
//

import Foundation
import UserNotifications

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
    
    func setUserNotifications(indexPath: IndexPath, time: TimeInterval) {
        
        var monsterName = ""
        if indexPath.section == 0 {
            monsterName = mvpList[indexPath.row]
        } else {
            monsterName = miniList[indexPath.row]
        }
        
        let content = UNMutableNotificationContent()
        content.title = "\(monsterName) - 即將重生"
        content.sound = UNNotificationSound.default
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        let minuteFormatter = DateFormatter()
        minuteFormatter.dateFormat = "mm"
        let secondFormatter = DateFormatter()
        secondFormatter.dateFormat = "ss"
        
        let originDate = time - Date().timeIntervalSince1970
        let date = Date(timeIntervalSinceNow: originDate-300)
        var components = DateComponents()
        components.year = Int(yearFormatter.string(from: date))
        components.month = Int(monthFormatter.string(from: date))
        components.day = Int(dayFormatter.string(from: date))
        components.hour = Int(hourFormatter.string(from: date))
        components.minute = Int(minuteFormatter.string(from: date))
        components.second = Int(secondFormatter.string(from: date))
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let identifier = "\(indexPath.section)-\(indexPath.row)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            print("成功建立通知: \(request.identifier)")
        })
    }
    
    func removeUserNotifications(indexPath: IndexPath) {
        
        let identifier = "\(indexPath.section)-\(indexPath.row)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
