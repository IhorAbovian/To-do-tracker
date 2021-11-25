//
//  TimeVC.swift
//  TestProjectApp
//
//  Created by Igor Abovyan on 14.11.2021.
//

import UIKit
import UserNotifications

class TimeVC: UIViewController {
    
    var task: Task!
    var label: UILabel!
    var timer = Timer.init()
    var seconds: Double = 1500
    var isTimeRunning = false
    var timerSeconds: Double = 0
    var isChooseTimer = false
    var isChoosePomadoro = true
    var isChoosePicker = false
    var shape: CAShapeLayer!
    var button: UIButton!
    var picker: UIPickerView!
    var pickerSeconds: Double = 0
    let shapeLayer = CAShapeLayer()
    var animation = CABasicAnimation()
    var stopwatchNumbers = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
    
}

//MARK: Life cycle
extension TimeVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
}

//MARK: Config
extension TimeVC {
    private func config() {
        self.createLabel()
        self.startButton()
        self.createCircle()
        self.backButton()
        self.createTimerMode()
        self.createPickerMode()
        self.createPomadoroMode()
        self.createPicker()
        self.circleAnimate()
        UNUserNotificationCenter.current().delegate = self
    }
    
    private func createTimerMode() {
        let timerButton = UIButton.init()
        timerButton.frame.size.width = 30
        timerButton.frame.size.height = 30
        timerButton.frame.origin.y = UIScreen.main.bounds.height * 0.92
        timerButton.frame.origin.x = UIScreen.main.bounds.width * 0.2
        timerButton.setImage("timer".getSymbol(size: 25, bold: .light), for: .normal)
        timerButton.tintColor = .black
        self.view.addSubview(timerButton)
        
        timerButton.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
    }
    
    @objc private func startTimer() {
        label.text = timeString(time: TimeInterval(timerSeconds))
        isChoosePomadoro = false
        isChooseTimer = true
        picker.removeFromSuperview()
        label.textColor = .black
    }
    
    private func createPickerMode() {
        let timerButton = UIButton.init()
        timerButton.frame.size.width = 30
        timerButton.frame.size.height = 30
        timerButton.frame.origin.y = UIScreen.main.bounds.height * 0.92
        timerButton.frame.origin.x = UIScreen.main.bounds.width * 0.45
        timerButton.setImage("stopwatch".getSymbol(size: 25, bold: .light), for: .normal)
        timerButton.tintColor = .black
        self.view.addSubview(timerButton)
        
        timerButton.addTarget(self, action: #selector(startPicker), for: .touchUpInside)
    }
    
    @objc private func startPicker() {
        isChooseTimer = false
        isChoosePomadoro = false
        isChoosePicker = true
        self.view.addSubview(picker)
        label.textColor = .clear
    }
    
    private func createPicker() {
        picker = UIPickerView.init()
        picker.dataSource = self
        picker.delegate = self
        picker.frame.size.width = self.view.frame.size.width * 0.3
        picker.frame.size.height = self.view.frame.size.width * 0.3
        picker.center.x = self.view.frame.size.width / 2
        picker.center.y = self.view.frame.size.height / 2
        
    }
    
    private func createPomadoroMode() {
        let timerButton = UIButton.init()
        timerButton.frame.size.width = 30
        timerButton.frame.size.height = 30
        timerButton.frame.origin.y = UIScreen.main.bounds.height * 0.92
        timerButton.frame.origin.x = UIScreen.main.bounds.width * 0.7
        timerButton.setImage("clock".getSymbol(size: 25, bold: .light), for: .normal)
        timerButton.tintColor = .black
        self.view.addSubview(timerButton)
        
        timerButton.addTarget(self, action: #selector(startPomadoroMod), for: .touchUpInside)
    }
    
    @objc private func startPomadoroMod() {
        isChooseTimer = false
        isChoosePomadoro = true
        picker.removeFromSuperview()
        label.text = timeString(time: TimeInterval(seconds))
        label.textColor = .black
    }

    
    private func backButton() {
        let button = UIButton.init()
        button.frame.size.width = self.view.frame.size.width * 0.1
        button.frame.size.height = button.frame.size.width
        button.frame.origin.y = button.frame.size.height * 2
        button.frame.origin.x = button.frame.size.width * 0.2
        button.setImage("multiply".getSymbol(size: 25, bold: .light), for: .normal)
        button.tintColor = .black
        self.view.addSubview(button)
        
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: false)
    }
    
    private func createLabel() {
        label = UILabel.init()
        label.frame.size.width = self.view.frame.size.width * 0.2
        label.frame.size.height = self.view.frame.size.width * 0.1
        label.center.x = self.view.frame.size.width / 2
        label.center.y = self.view.frame.size.height / 2
        label.text = timeString(time: TimeInterval(seconds))
        label.font = UIFont.systemFont(ofSize: 30, weight: .light)
        self.view.addSubview(label)
    }
    
    private func startButton() {
        button = UIButton.init()
        button.frame.size.width = self.view.frame.size.width * 0.4
        button.frame.size.height = button.frame.size.width / 4
        button.frame.origin.y = self.view.frame.size.height * 0.8
        button.center.x = self.view.frame.size.width / 2
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.8
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10
        self.view.addSubview(button)
        
        button.addTarget(self, action: #selector(createTimer), for: .touchUpInside)
    }
    
    @objc private func createTimer() {
        if isTimeRunning == true {
            button.setTitle("Start", for: .normal)
            isTimeRunning = false
            self.stopAnimation()
            timer.invalidate()
        }else {
            isTimeRunning = true
            self.callAnimation()
            button.setTitle("Stop", for: .normal)
            let userDefaults = UserDefaults.standard
            let amountTasks = userDefaults.integer(forKey: String.number)
            pickerSeconds = Double(amountTasks * 60)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func updateTimer() {
            
        if isChoosePicker == true {
            label.text = timeString(time: TimeInterval(pickerSeconds))
            label.textColor = .black
            picker.removeFromSuperview()
            pickerSeconds -= 1
        }
        
        if isChooseTimer == true {
            timerSeconds += 1
            label.text = timeString(time: TimeInterval(timerSeconds))
        }else {
            if isChoosePomadoro == true {
                seconds -= 1
                label.text = timeString(time: TimeInterval(seconds))
            }
        }
        
        if seconds == 0 {
            timer.invalidate()
            self.createNotification()
        }
    }
    
    private func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    private func createCircle() {
        let circle = UIBezierPath.init(arcCenter: view.center, radius: 170, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        
        shape = CAShapeLayer.init()
        shape.path = circle.cgPath
        shape.strokeColor = UIColor.gray.cgColor
        shape.fillColor = UIColor.clear.cgColor
        self.view.layer.addSublayer(shape)
    }
    
    private func circleAnimate() {
        
        let circlePath = UIBezierPath.init(arcCenter: view.center, radius: 170, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        shapeLayer.strokeColor = UIColor.black.cgColor
        view.layer.addSublayer(shapeLayer)
    }
    
    private func callAnimation() {
        animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = CFTimeInterval(75)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        
        shapeLayer.add(animation, forKey: "animation")
        
    }
    
    private func stopAnimation() {
        shapeLayer.removeAllAnimations()
    }
}

//MARK: Register/Create Notification
extension TimeVC {
    
    private func createNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
        }
        
        let content = UNMutableNotificationContent.init()
        content.title = "App name"
        content.body = "Time is over"
        content.sound = .default
        
        let date = Date().addingTimeInterval(1)
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request) { error in
            
        }
    }
}

//MARK: Notification Delegate
extension TimeVC: UNUserNotificationCenterDelegate {
    // уведомление с открытым приложением
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}

//MARK: Picker data source
extension TimeVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        stopwatchNumbers.count
    }
}

//MARK: Picker Delegate
extension TimeVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(stopwatchNumbers[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(stopwatchNumbers[row], forKey: String.number)
        userDefaults.synchronize()
        CoreDataManager.shered.saveContext()
    }
}
