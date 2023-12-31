//
//  ViewController.swift
//  Neobis_iOS_StopWatchn
//
//  Created by Interlink on 3/11/23.
//

import UIKit

class ViewController: UIViewController {
    
    //kj
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var timerPicker: UIPickerView!
    
    var timer: Timer?
    var isRunning = false
    var startTime: TimeInterval = 0
    
    private var elapsedTime: TimeInterval = 0
    var remainingTime: TimeInterval = 0
    
    private var timerElapsedTime: TimeInterval = 0 // Для таймера
    var timerRemainingTime: TimeInterval = 0 // Для таймера

    private var stopwatchElapsedTime: TimeInterval = 0 // Для секундомера
   
    let hoursData = Array(0...23)
    let minutesData = Array(0...59)
    let secondsData = Array(0...59)
    var selectedHours = 0
    var selectedMinutes = 0
    var selectedSeconds = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.font = UIFont.boldSystemFont(ofSize: 54)
        timerLabel.adjustsFontForContentSizeCategory = true
        timerPicker.isHidden = true
        updateImage()
        
        timerPicker.delegate = self
        timerPicker.dataSource = self
       updateTimerLabel()
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        updateImage()
     
        if sender.selectedSegmentIndex == 0 {
                timerPicker.isHidden = true
            }
            else   {
                timerPicker.isHidden = false
                elapsedTime = 0
            }
        
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if isRunning {
               return
           }
           isRunning = true
           startButton.isEnabled = false
           pauseButton.isEnabled = true
           stopButton.isEnabled = true
        timerPicker.isHidden = true

           if segmentedController.selectedSegmentIndex == 0 {
           
               let selectedTime = selectedHours * 3600 + selectedMinutes * 60 + selectedSeconds
               remainingTime = TimeInterval(selectedTime)
              // updateTime()
               startTimer()
           } else {
             
              
               if timer == nil {
                   timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
                   RunLoop.current.add(timer!, forMode: .common)
               } else {
                   timer?.fire()
               }
               startTime = Date().timeIntervalSinceReferenceDate - elapsedTime
               // Обнулить elapsedTime для секундомера
               elapsedTime = 0
           }
   
    }
    
    
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        startButton.isEnabled = true
           pauseButton.isEnabled = false
           stopButton.isEnabled = false
        timerPicker.isHidden = false // Показать UIPickerView
           if let timer = timer {
               timer.invalidate()
           }
           isRunning = false

           if segmentedController.selectedSegmentIndex == 0 {
             
               remainingTime = 0 // Обнулить remainingTime для таймера
           } else {
             
               // Обновить label и продолжить отсчет времени
              updateTime()
              
           }

           // timerPicker.isHidden = false // Показать UIPickerView
       
    }
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        if isRunning {
            startButton.isEnabled = true
            pauseButton.isEnabled = false
            stopButton.isEnabled = true
            if let timer = timer {
                timer.invalidate()
            }
            isRunning = false
        }
    }
    
    @objc private func updateTime() {
        if segmentedController.selectedSegmentIndex == 0 {
                // Таймер сегмент (index 0)
                if remainingTime <= 0 {
                    stopTimer()
                    return
                }
                remainingTime -= 1
                let hours = Int(remainingTime) / 3600
                let minutes = (Int(remainingTime) % 3600) / 60
                let seconds = Int(remainingTime) % 60
                timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            } else if segmentedController.selectedSegmentIndex == 1 {
                // Секундомер сегмент (index 1)
                elapsedTime = Date().timeIntervalSinceReferenceDate - startTime
                let hours = Int(elapsedTime) / 3600
                let minutes = (Int(elapsedTime) % 3600) / 60
                let seconds = Int(elapsedTime) % 60
                timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            }}
        
    


    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        if let timer = timer {
            timer.invalidate()
        }
        isRunning = false
        timerPicker.isHidden = false // Показать UIPickerView
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        stopButton.isEnabled = false
        timerLabel.text = "00:00:00" // Сбросить timerLabel
        updateTimerLabel()
    }
    
    func updateImage() {
        if segmentedController.selectedSegmentIndex == 0 {
            // Set the image for the first segment
            image.image = UIImage(named: "timer")
        } else {
            // Set the image for the second segment
            image.image = UIImage(named: "stopWatch")
        }
        
    }
    func updateTimerLabel() {
        if segmentedController.selectedSegmentIndex == 0 {
               
                let hours = Int(remainingTime) / 3600
                let minutes = (Int(remainingTime) % 3600) / 60
                let seconds = Int(remainingTime) % 60
                timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            } else {
              
                let hours = selectedHours
                let minutes = selectedMinutes
                let seconds = selectedSeconds
                timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            }
    }
}
    // MARK: UIPickerView DataSource and Delegate Methods
    
    extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 3 // Hours, Minutes, and Seconds
        }
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch component {
            case 0:
                return hoursData.count
            case 1:
                return minutesData.count
            case 2:
                return secondsData.count
            default:
                return 0
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            switch component {
            case 0:
                return String(hoursData[row])
            case 1:
                return String(minutesData[row])
            case 2:
                return String(secondsData[row])
            default:
                return ""
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedHours = hoursData[pickerView.selectedRow(inComponent: 0)]
            selectedMinutes = minutesData[pickerView.selectedRow(inComponent: 1)]
            selectedSeconds = secondsData[pickerView.selectedRow(inComponent: 2)]
            updateTimerLabel()
            if segmentedController.selectedSegmentIndex == 1 {
                
                let totalSeconds = selectedHours * 3600 + selectedMinutes * 60 + selectedSeconds
                elapsedTime = TimeInterval(totalSeconds - 1) // чтобы начать с 0
               updateTime()
            }
            }
        }
        
    
    
    
    
    
    
    


