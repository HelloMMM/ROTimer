//
//  TimerCell.swift
//  ROTimer
//
//  Created by Miles on 2020/12/2.
//

import UIKit

protocol TimerCellDelegate {
    func startTimer(indexPath: IndexPath, time: TimeInterval)
    func stopTimer(indexPath: IndexPath)
}

class TimerCell: UITableViewCell {

    @IBOutlet weak var monsterImageView: UIImageView!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var monsterName: UILabel!
    @IBOutlet weak var timerLab: UILabel!
    var second = 0
    var timer: Timer!
    var indexPath: IndexPath!
    var delegate: TimerCellDelegate?
    
    override func layoutSubviews() {
        startBtn.layer.cornerRadius = 5
        stopBtn.layer.cornerRadius = 5
    }
    
    @IBAction func killUpdate(_ sender: Any) {
        
        if second != 0 {
            
            let alert = UIAlertController(title: "注意", message: "重生時間還未到達, 你確定要重新計時嗎?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "確定", style: .default) { (alert) in
                self.startTimer()
            }
            
            let no = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(no)
            
            parentViewController?.present(alert, animated: true, completion: nil)
        } else {
            
            startTimer()
        }
    }
    
    func startTimer() {
        
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        if indexPath.section == 0 {
            second = 305
        } else {
            second = 7200
        }
        
        let nowTime = Date()
        let time = nowTime.timeIntervalSince1970 + Double(second)
        delegate?.startTimer(indexPath: indexPath, time: time)
        timerLab.text = transToHourMinSec(time: second)
        initTimer()
    }
    
    @IBAction func stopClick(_ sender: Any) {
        
        stopTimer()
    }
    
    func initTimer() {
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func stopTimer() {
        
        second = 0
        timerLab.text = "--:--:--"
        timerLab.textColor = .none
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        delegate?.stopTimer(indexPath: indexPath)
    }
    
    @objc func updateTimer() {
        
        if second <= 0 {
                
            stopTimer()
            return
        }
        
        second -= 1
        
        if second <= 300 {
            timerLab.textColor = .systemRed
        } else {
            timerLab.textColor = .none
        }
        timerLab.text = transToHourMinSec(time: second)
    }
    
    func transToHourMinSec(time: Int) -> String {
        
        let duration: TimeInterval = TimeInterval(second)
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]

        let formattedDuration = formatter.string(from: duration) ?? ""
        
        return formattedDuration
    }
}
