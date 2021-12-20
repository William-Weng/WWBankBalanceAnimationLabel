//
//  WWBankBalanceAnimationLabel.swift
//  Example
//
//  Created by William.Weng on 2021/12/20.
//

import UIKit

// MARK: - 有存錢動畫的Label
open class WWBankBalanceAnimationLabel: UILabel {
    
    private var balanceValue: (from: Float, to: Float, format: String) = (0, 0, "$ %.1f")
    private var balanceTime: (progress: TimeInterval, lastUpdate: TimeInterval, total: TimeInterval) = (0, 0, 0)
    private var timer: CADisplayLink?
    private var currentValue: Float { return currentValueMaker() }
    
    private var progressClosure: ((Float) -> Void)?
    private var completionClosure: ((Bool) -> Void)?
    
    /// 設定Label上的數值
    /// - Parameter timer: Timer
    @objc private func updateValue(timer: Timer) {
        stopWatchRunning()
        textValue(currentValue)
    }
}

// MARK: 公開的function
extension WWBankBalanceAnimationLabel {
    
    /// [執行數字動畫](https://ios.devdon.com/archives/922)
    /// - Parameters:
    ///   - from: [Float](https://www.hangge.com/blog/cache/detail_2278.html)
    ///   - to: [Float](https://terms.naer.edu.tw/detail/3223581/)
    ///   - duration: [TimeInterval](https://www.jianshu.com/p/b6ffd736729c)
    ///   - format: [String](https://kantai235.github.io/SwiftStringFormatTutorial/)
    ///   - runloop: RunLoop
    ///   - mode: RunLoop.Mode
    ///   - progress: ((Float) -> Void)?
    ///   - completion: ((Bool) -> Void)?
    public func balance(from: Float? = nil, to: Float, duration: TimeInterval = 2.0, format: String = "$ %.1f", runloop: RunLoop = .main, forMode mode: RunLoop.Mode = .default, progress: ((Float) -> Void)? = nil, completion: ((Bool) -> Void)? = nil) {
        
        self.progressClosure = progress
        self.completionClosure = completion
        
        guard duration > 0.0 else { textValue(to); return }
        
        balanceValue = (from: from ?? currentValue, to: to, format: format)
        balanceTime = (progress: 0.0, lastUpdate: Date.timeIntervalSinceReferenceDate, total: duration)
        
        timerSetting()
        timer?.add(to: runloop, forMode: mode)
        timer?.add(to: runloop, forMode: .tracking)
    }
}

// MARK: 小工具
extension WWBankBalanceAnimationLabel {
    
    /// 計算變化數值 - 非線性 / 越來越快
    /// - Returns: Float
    private func currentValueMaker() -> Float {
        
        guard balanceTime.progress < balanceTime.total,
              let progressValue = Optional.some(Float(balanceTime.progress / balanceTime.total) * (balanceValue.to - balanceValue.from))
        else {
            return balanceValue.to
        }
        
        return balanceValue.from + progressValue
    }
    
    /// 設定Label數值 => MainQueue
    /// - Parameter value: Float
    private func textValue(_ value: Float) {
        
        progressClosure?(value)
        
        DispatchQueue.main.async { [unowned self] in
            self.text = String(format: balanceValue.format, value)
        }
        
        if value == balanceValue.to { completionClosure?(true) }
    }
    
    /// 設定Timer - CADisplayLink
    private func timerSetting() {
        resetTimer()
        timer = CADisplayLink(target: self, selector: #selector(self.updateValue(timer:)))
    }
    
    /// 定時器停止 / 歸零
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// 碼表計時 => 計算時間到了沒？
    private func stopWatchRunning() {
        
        let nowTime = Date.timeIntervalSinceReferenceDate
        
        balanceTime.progress += nowTime - balanceTime.lastUpdate
        balanceTime.lastUpdate = nowTime
        
        if balanceTime.progress >= balanceTime.total {
            resetTimer()
            balanceTime.progress = balanceTime.total
        }
    }
}
