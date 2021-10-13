//
//  ViewController.swift
//  Timer
//
//  Created by WONJI HA on 2021/07/06.

/*
 Reference
 https://kwangsics.tistory.com/entry/Swift-%ED%95%A8%EC%88%98-%EC%A0%95%EC%9D%98%EC%99%80-%ED%98%B8%EC%B6%9C?category=606525 함수 정의 및 호출
 https://bite-sized-learning.tistory.com/175 타이머1
 https://youtu.be/3TbdoVhgQmE 타이머2
 */

import UIKit


class ViewController: UIViewController {
    
//    let timeSel : Selector = #selector(ViewController.start2)
    
    var timer = Timer()
    var timercount : Bool = false
    var count : Int = 0
    
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var StartStopButton: UIButton!
    @IBOutlet weak var ResetButton: UIButton!
    
    @IBOutlet weak var hourUpButton: UIButton!
    @IBOutlet weak var hourDownButton: UIButton!
        
    @IBOutlet weak var minUpButton: UIButton!
    @IBOutlet weak var minDownButton: UIButton!
    
    @IBOutlet weak var secUpButton: UIButton!
    @IBOutlet weak var secDownButton: UIButton!
    
    @IBOutlet weak var millisecUpButton: UIButton!
    @IBOutlet weak var millisecDownButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.topItem?.title="AD" //뷰 제목
    

    }
 
    
    @IBAction func start_stop(_ sender: Any)
    {
        if(timercount)
        {
            timercount = false
            timer.invalidate()
            StartStopButton.setTitle("Start", for: .normal)
            
        }
        else
        {
            timercount = true
            StartStopButton.setTitle("Pause", for: .normal)
            print("일시정지")
            timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
        
    }
    
    func Reset() /* 초기화 함수 선언 */
    {
        self.count = 0
        self.timer.invalidate()
        self.TimerLabel.text = self.TimeString(hours: 0, minutes: 0, seconds: 0, milliseconds: 0)
        self.StartStopButton.setTitle("Start", for: .normal)
        
    }
    
    @IBAction func ResetButton(_ sender: Any)
    {
       Reset() //초기화 함수 호출
        print("초기화 되었습니다.")
    }
    
    func timeLabel()
    {
//        let time = secondsToHoursMinutesSeconds(seconds: count)
//        let timeText = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
//        TimerLabel.text = timeText

        let time = millisecondsToHours(ms: count)
        let timeText = TimeString(hours: time.0, minutes: time.1, seconds: time.2, milliseconds: time.3)
        TimerLabel.text = timeText
        
    }
    
    @objc func timerCounter() -> Void
    {
        if(count > 0)
        {
            count = count-8 //해결필요  어느정도 맞춤.
            print(count , "시간입니다")
            timeLabel()
            if(count < 0)
            {
                Reset()
                print("0초가 되었습니다 및 초기화")
            }
        }
    }
    
    func millisecondsToHours(ms: Int) -> (Int, Int, Int, Int)
    {
        return ((ms / 3600000), ((ms % 3600000) / 60000), ((ms % 60000) / 1000), (ms % 3600000) % 1000)
    }
    
    func TimeString(hours: Int, minutes: Int, seconds : Int, milliseconds : Int) -> String
    {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += ":"
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        timeString += "."
        timeString += String(format: "%03d", milliseconds)
        return timeString
    }
    
//    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int)
//    {
//        return ((seconds / 3600), ((seconds % 3600) / 60),((seconds % 3600) % 60))
//    }
//
//    func makeTimeString(hours: Int, minutes: Int, seconds : Int) -> String
//    {
//        var timeString = ""
//        timeString += String(format: "%02d", hours)
//        timeString += ":"
//        timeString += String(format: "%02d", minutes)
//        timeString += ":"
//        timeString += String(format: "%02d", seconds)
//        return timeString
//    }
    
    @IBAction func millisecUp(_ sender : Any)
    {
        count += 1
        print(count,"m시간을 증가 하였습니다")
        timeLabel()
    }
    
    @IBAction func millisecDown(_ sender : Any)
    {
        if(count > 0)
        {
            count -= 1
            print(count,"m시간을 감소 하였습니다")
            timeLabel()
        }
    }
    
    @IBAction func secUp(_ sender:Any)
    {
        count += 1000
        print(count,"s시간을 증가 하였습니다")
        timeLabel()
//        TimerLabel.text = timeString
    }
    
    @IBAction func secDown( _ sender : Any)
    {
        if(count > 999)
        {
            if(count > 0)
            {
                count -= 1000
                print(count, "s시간을 감소 하였습니다")
                timeLabel()
            }
        }
        else
        {
            print("초가 충분히 남아 있지 않아 시간을 감소할 수 없습니다.")
            print(count, "시간이 저장되어있다.")
        }

       
    }
    
    @IBAction func minUp(_ sender : Any)
    {
        count += 60000
        print(count, "분시간이 증가 하였습니다")
        timeLabel()
    }
    
    @IBAction func minDown(_ sender : Any)
    {
        if(count > 59999)
        {
            if(count > 0)
            {
              count -= 60000
                print(count, "분시간이 감소 하였습니다")
                    timeLabel()
            }
        }
        else
        {
            print("분 시간이 충분히 남아 있지 않아 시간을 감소할 수 없습니다.")
            print(count, "시간이 저장되어있다.")

        }
       
    }
    
    @IBAction func hourUp(_ sender : Any)
    {
        if(count < 82800000)
        {
            count += 3600000
            print(count, "h시간이 증가 하였습니다")
            timeLabel()
        }

    }
    
    @IBAction func hourDown(_ sender : Any)
    {
        if(count > 3599999)
        {
            if(count > 0)
            {
                count -= 3600000
                print(count, "h시간이 감소 하였습니다")
                timeLabel()
            }
        }
        else
        {
            print("h 시간이 충분히 남아 있지 않아 시간을 감소할 수 없습니다.")
            print(count, "시간이 저장되어있다.")
        }
       
    }
    
}

