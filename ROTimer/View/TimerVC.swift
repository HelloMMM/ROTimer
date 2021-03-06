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
    }
}

extension TimerVC: UITableViewDelegate, UITableViewDataSource, TimerCellDelegate {
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let myLabel = UILabel()
//        myLabel.frame = CGRect(x: 20, y: 8, width: 320, height: 20)
//        myLabel.font = UIFont.boldSystemFont(ofSize: 18)
//        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
//        
//        let headerView = UIView()
//        headerView.addSubview(myLabel)
//        
//        return headerView
//    }
    
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
            cell.timerLab.text = transToHourMinSec(time: limitDescriptionTime)
            cell.second = limitDescriptionTime
            cell.initTimer()
        } else {
            cell.second = 0
            cell.timerLab.text = "--:--:--"
            if cell.timer != nil {
                cell.timer.invalidate()
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
        
        if indexPath.section == 0 {
            timerVM.mvpModel[indexPath.row].timer = time
        } else {
            timerVM.miniModel[indexPath.row].timer = time
        }
        
        timerVM.saveData()
    }
    
    func stopTimer(indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            timerVM.mvpModel[indexPath.row].timer = 0
        } else {
            timerVM.miniModel[indexPath.row].timer = 0
        }
        
        timerVM.saveData()
    }
}
