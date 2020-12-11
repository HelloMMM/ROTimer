//
//  TimerVC.swift
//  ROTimer
//
//  Created by Miles on 2020/12/2.
//

import UIKit

class TimerVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let timerVM = TimerVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timerVM.initData()
        
        timerVM.person.addObserver { [weak self] (bool) in
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(showAlert), name: Notification.Name("ShowAlert"), object: nil)
    }
    
    @objc func showAlert() {
        
        let alert = UIAlertController(title: "注意", message: "請開啟您的通知權限,\n否則無法向您提醒!", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let set = UIAlertAction(title: "設定", style: .default) { (alert) in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        }

        alert.addAction(cancel)
        alert.addAction(set)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension TimerVC: UITableViewDelegate, UITableViewDataSource, TimerCellDelegate {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "MVP"
        } else {
            return "Mini"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return timerVM.mvpModel.count
        } else {
            return timerVM.miniModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "idTimerCell", for: indexPath) as! TimerCell
        
        cell.indexPath = indexPath
        
        let nowTime = Date().timeIntervalSince1970
        let maturityTime: TimeInterval!
        
        if indexPath.section == 0 {
            cell.monsterName.text = "\(timerVM.mvpModel[indexPath.row].monsterName)"
            cell.monsterImageView.image = UIImage(named: "mvp\(indexPath.row)")
            maturityTime = timerVM.mvpModel[indexPath.row].timer
        } else {
            cell.monsterName.text = "\(timerVM.miniModel[indexPath.row].monsterName)"
            cell.monsterImageView.image = UIImage(named: "mini\(indexPath.row)")
            maturityTime = timerVM.miniModel[indexPath.row].timer
        }
        
        if maturityTime != 0 {
            let limitDescriptionTime = (Int(round(maturityTime - nowTime)))
            if limitDescriptionTime <= 300 {
                cell.timerLab.textColor = .systemRed
            } else {
                cell.timerLab.textColor = .none
            }
            if limitDescriptionTime > 0 {
                cell.timerLab.text = transToHourMinSec(time: limitDescriptionTime)
                cell.second = limitDescriptionTime
                cell.initTimer()
            } else {
                cell.second = 0
                cell.timerLab.text = "--:--:--"
                cell.timerLab.textColor = .none
                if cell.timer != nil {
                    cell.timer.invalidate()
                    cell.timer =  nil
                }
            }
            
        } else {
            cell.second = 0
            cell.timerLab.text = "--:--:--"
            cell.timerLab.textColor = .none
            if cell.timer != nil {
                cell.timer.invalidate()
                cell.timer =  nil
            }
        }
        
        cell.delegate = self
        
        return cell
    }
    
    func transToHourMinSec(time: Int) -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]

        let formattedDuration = formatter.string(from: TimeInterval(time)) ?? ""
        
        return formattedDuration
    }
    
    func startTimer(indexPath: IndexPath, time: TimeInterval) {
        
        timerVM.setUserNotifications(indexPath: indexPath, time: time)
        if indexPath.section == 0 {
            timerVM.mvpModel[indexPath.row].timer = time
        } else {
            timerVM.miniModel[indexPath.row].timer = time
        }
        
        timerVM.saveData()
    }
    
    func stopTimer(indexPath: IndexPath) {
        
        timerVM.removeUserNotifications(indexPath: indexPath)
        
        if indexPath.section == 0 {
            timerVM.mvpModel[indexPath.row].timer = 0
        } else {
            timerVM.miniModel[indexPath.row].timer = 0
        }
        
        timerVM.saveData()
    }
}
