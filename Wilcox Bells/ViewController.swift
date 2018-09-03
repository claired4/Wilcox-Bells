//  ViewController.swift
//  Wilcox Bells
//
//  Created by Claire Dong on 7/17/18.
//  Copyright © 2018 Wilcox High School. All rights reserved.

import UIKit
import UserNotifications

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewForTable: UIView!
    var tableview: UITableView!
    
    @IBAction func switchDay(_ sender: UISegmentedControl) {
        p = sender.selectedSegmentIndex
        tableview.reloadData()
    }
    
    var sched = [["1st 7:30-8:20", "2nd 8:25-9:15"], ["1st 7:30-8:20", "2nd 8:25-9:15"], ["2nd 9:05-10:35", "4th 10:45-12:20"], ["1st 7:30-9:00", "3rd 9:05-10:35"], ["1st 7:30-8:20", "2nd 8:25-9:15"]]
    var p: Int!
    
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var minLeft: UILabel!
    @IBOutlet weak var secLeft: UILabel!
    
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var secLabel: UILabel!
    
    @IBOutlet weak var outOfHours: UILabel!
    @IBOutlet weak var morning: UILabel!
    @IBOutlet weak var weekend: UILabel!
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return sched[p].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell
        let str = sched[p][indexPath.row].components(separatedBy: " ")
        cell.customInit(period: str[0], time: str[1])
        return cell
    }
    
    override func viewDidLoad() {
        print(viewForTable)
        tableview = UITableView(frame: viewForTable.frame)
        viewForTable.addSubview(tableview)
        
        //print(tableView)
        //tableView = UITableView()
        tableview.dataSource = self
        tableview.delegate = self
    
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: {didAllow, error in})
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CustomCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "CustomCell")
        
        p = 0
        
        message.isHidden = true;
        minLeft.isHidden = true;
        secLeft.isHidden = true;
        minLabel.isHidden = true;
        outOfHours.isHidden = true;
        morning.isHidden = true;
        weekend.isHidden = true;
        
        if (Calendar.current.component(.weekday, from: Date()) == 2 ||
            Calendar.current.component(.weekday, from: Date()) == 3 ||
            Calendar.current.component(.weekday, from: Date()) == 6) {
            let content = UNMutableNotificationContent()
            content.title = "Lunch ends in 2 minutes"
            content.body = "5th period starts at 12:20"
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            let calendar = Calendar.current
            let components = DateComponents(hour: 12, minute: 18)
            let date = calendar.date(from: components)
            let comp2 = calendar.dateComponents([.hour,.minute], from: date!)
            let trigger = UNCalendarNotificationTrigger(dateMatching: comp2, repeats: true)
            
            let request = UNNotificationRequest(
                identifier: "identifier",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                if error != nil {
                    //handle error
                } else {
                    //notification set up successfully
                }
            })
        } else if (Calendar.current.component(.weekday, from: Date()) == 4 ||
            Calendar.current.component(.weekday, from: Date()) == 5) {
            let content = UNMutableNotificationContent()
            content.title = "Lunch ends in 2 minutes"
            if (Calendar.current.component(.weekday, from: Date()) == 4) {
                content.body = "6th period starts at 12:55"
            } else {
                content.body = "5th period starts at 12:55"
            }
            
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            let calendar = Calendar.current
            let components = DateComponents(hour: 12, minute: 53)
            let date = calendar.date(from: components)
            let comp2 = calendar.dateComponents([.hour,.minute], from: date!)
            let trigger = UNCalendarNotificationTrigger(dateMatching: comp2, repeats: true)
            
            let request = UNNotificationRequest(
                identifier: "identifier",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                if error != nil {
                    //handle error
                } else {
                    //notification set up successfully
                }
            })
        } else if (Calendar.current.component(.weekday, from: Date()) == 7 ||
            Calendar.current.component(.weekday, from: Date()) == 1) {
            
        }
        
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector((ViewController.updateTime)), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func updateTime() {
        
        //label.text = DateFormatter.localizedString(from: Date(), dateStyle:DateFormatter.Style.none, timeStyle:DateFormatter.Style.medium)
        
        
        //-----------------------REGULAR DAYS------------------------------
        if (Calendar.current.component(.weekday, from: Date()) == 2 ||
            Calendar.current.component(.weekday, from: Date()) == 3 ||
            Calendar.current.component(.weekday, from: Date()) == 6) {
            
            weekend.isHidden = true;
            
            //BEFORE 7:00
            if (Calendar.current.component(.hour, from: Date()) < 7) {
                hideTimer();
                outOfHours.isHidden = true;
                morning.isHidden = false;
                
                //7-7:30
            } else if (Calendar.current.component(.hour, from: Date()) == 7 && Calendar.current.component(.minute, from: Date()) < 30) {
                displayTime(mins: 29)
                message.text = "1st period starts at 7:30 in"
                
                //1st period (7:30-8:00)
            } else if ((Calendar.current.component(.hour, from: Date()) == 7 && Calendar.current.component(.minute, from: Date()) >= 30)) {
                displayTime(mins: 79)
                message.text = "1st period ends at 8:20 in"
                
                //1st period (8:00-8:20)
            } else if ((Calendar.current.component(.hour, from: Date()) == 8 && Calendar.current.component(.minute, from: Date()) < 20)) {
                displayTime(mins: 19)
                message.text = "1st period ends at 8:20 in"
                
                //Passing period (8:20-8:25)
            } else if (Calendar.current.component(.hour, from: Date()) == 8 && Calendar.current.component(.minute, from: Date()) >= 20  && Calendar.current.component(.minute, from: Date()) < 25) {
                displayTime(mins: 24)
                message.text = "2nd period starts at 8:25 in"
                
                //2nd period (8:25-9:00)
            } else if (Calendar.current.component(.hour, from: Date()) == 8 && Calendar.current.component(.minute, from: Date()) >= 25) {
                displayTime(mins: 74)
                message.text = "2nd period ends at 9:15 in"
                
                //2nd period (9:00-9:15)
            } else if (Calendar.current.component(.hour, from: Date()) == 9 && Calendar.current.component(.minute, from: Date()) < 15) {
                displayTime(mins: 14)
                message.text = "2nd period ends at 9:15 in"
                
                //Passing period (9:15-9:25)
            } else if (Calendar.current.component(.hour, from: Date()) == 9 && Calendar.current.component(.minute, from: Date()) >= 15 && Calendar.current.component(.minute, from: Date()) < 25) {
                displayTime(mins: 24)
                message.text = "3rd period starts at 9:25 in"
                
                //3rd period (9:25-10:00)
            } else if (Calendar.current.component(.hour, from: Date()) == 9 && Calendar.current.component(.minute, from: Date()) >= 25) {
                displayTime(mins: 74)
                message.text = "3rd period ends at 10:15 in"
                
                //3rd period (10:00-10:15)
            } else if (Calendar.current.component(.hour, from: Date()) == 10 && Calendar.current.component(.minute, from: Date()) < 15) {
                displayTime(mins: 14)
                message.text = "3rd period ends at 10:15 in"
                
                //Passing period (10:15-10:20)
            } else if (Calendar.current.component(.hour, from: Date()) == 10 && Calendar.current.component(.minute, from: Date()) >= 15 && Calendar.current.component(.minute, from: Date()) < 20) {
                displayTime(mins: 19)
                message.text = "SSR starts at 10:20 in"
                
                //SSR (10:20-10:50)
            } else if (Calendar.current.component(.hour, from: Date()) == 10 && Calendar.current.component(.minute, from: Date()) >= 20 && Calendar.current.component(.minute, from: Date()) < 50) {
                displayTime(mins: 49)
                message.text = "SSR ends at 10:50 in"
                
                //Passing period (10:50-10:55)
            } else if (Calendar.current.component(.hour, from: Date()) == 10 && Calendar.current.component(.minute, from: Date()) >= 50 && Calendar.current.component(.minute, from: Date()) < 55) {
                displayTime(mins: 54)
                message.text = "4th period starts at 10:55 in"
                
                //4th period (10:55-11:00)
            } else if (Calendar.current.component(.hour, from: Date()) == 10 && Calendar.current.component(.minute, from: Date()) >= 55) {
                displayTime(mins: 104)
                message.text = "4th period ends at 11:45 in"
                
                //4th period (11:00-11:45)
            } else if (Calendar.current.component(.hour, from: Date()) == 11 && Calendar.current.component(.minute, from: Date()) < 45) {
                displayTime(mins: 44)
                message.text = "4th period ends at 11:45 in"
                
                //Lunch (11:45-12:00)
            } else if (Calendar.current.component(.hour, from: Date()) == 11 && Calendar.current.component(.minute, from: Date()) >= 45) {
                displayTime(mins: 74)
                message.text = "Lunch ends at 12:20 in"
                
                //Lunch (12:00-12:20)
            } else if (Calendar.current.component(.hour, from: Date()) == 12 && Calendar.current.component(.minute, from: Date()) < 20) {
                displayTime(mins: 19)
                message.text = "Lunch ends at 12:20 in"
                
                //INSERT NOTIFICATION AT 12:18 SAYING 2 MIN LEFT
                
                //5th period (12:20-1:00)
            } else if (Calendar.current.component(.hour, from: Date()) == 12 && Calendar.current.component(.minute, from: Date()) >= 20) {
                displayTime(mins: 69)
                message.text = "5th period ends at 1:10 in"
                
                //5th period (1:00-1:10)
            } else if (Calendar.current.component(.hour, from: Date()) == 13 && Calendar.current.component(.minute, from: Date()) < 10) {
                displayTime(mins: 9)
                message.text = "5th period ends at 1:10 in"
                
                //Passing period (1:10-1:15)
            } else if (Calendar.current.component(.hour, from: Date()) == 13 && Calendar.current.component(.minute, from: Date()) >= 10 && Calendar.current.component(.minute, from: Date()) < 15) {
                displayTime(mins: 14)
                message.text = "6th period starts at 1:10 in"
                
                //6th period (1:15-2:00)
            } else if (Calendar.current.component(.hour, from: Date()) == 13 && Calendar.current.component(.minute, from: Date()) >= 15) {
                displayTime(mins: 64)
                message.text = "6th period ends at 2:05 in"
                
                //6th period (2:00-2:05)
            } else if (Calendar.current.component(.hour, from: Date()) == 14 && Calendar.current.component(.minute, from: Date()) < 5) {
                displayTime(mins: 4)
                message.text = "6th period ends at 2:05 in"
                
                //Passing period (2:05-2:10)
            } else if (Calendar.current.component(.hour, from: Date()) == 14 && Calendar.current.component(.minute, from: Date()) >= 5 && Calendar.current.component(.minute, from: Date()) < 10) {
                displayTime(mins: 9)
                message.text = "7th period starts at 2:10 in"
                
                //7th period (2:10-3:00)
            } else if (Calendar.current.component(.hour, from: Date()) == 14 && Calendar.current.component(.minute, from: Date()) >= 10) {
                displayTime(mins: 59)
                message.text = "7th period ends at 3:00 in"
                
                //after school
            } else if (Calendar.current.component(.hour, from: Date()) >= 15) {
                afterSchool()
            }
            
            //------------------------WEDNESDAY--------------------------------
        } else if (Calendar.current.component(.weekday, from: Date()) == 4) {
            //BEFORE 8:30
            if (Calendar.current.component(.hour, from: Date()) < 8 || (Calendar.current.component(.hour, from: Date()) == 8 &&
                Calendar.current.component(.minute, from: Date()) < 30)) {
                hideTimer();
                morning.isHidden = false;
                
                //8:30-9:05
            } else if (Calendar.current.component(.hour, from: Date()) == 8 && Calendar.current.component(.minute, from: Date()) >= 30) {
                displayTime(mins: 64)
                message.text = "2nd period starts at 9:05 in"
                
                //9:00-9:05
            } else if (Calendar.current.component(.hour, from: Date()) == 9 && Calendar.current.component(.minute, from: Date()) < 5) {
                displayTime(mins: 4)
                message.text = "2nd period starts at 9:05 in"
                
                //2nd period (9:05-10:00)
            } else if (Calendar.current.component(.hour, from: Date()) == 9 && Calendar.current.component(.minute, from: Date()) >= 5) {
                displayTime(mins: 94)
                message.text = "2nd period ends at 10:35 in"
                
                //2nd period (10:00-10:35)
            } else if (Calendar.current.component(.hour, from: Date()) == 10 && Calendar.current.component(.minute, from: Date()) < 35) {
                displayTime(mins: 34)
                message.text = "2nd period ends at 10:35 in"
                
                //Passing period (10:35-10:45)
            } else if (Calendar.current.component(.hour, from: Date()) == 10 && Calendar.current.component(.minute, from: Date()) >= 35 && Calendar.current.component(.minute, from: Date()) < 45) {
                displayTime(mins: 44)
                message.text = "4th period starts at 10:45 in"
                
                //4th period (10:45-11:00)
            } else if (Calendar.current.component(.hour, from: Date()) == 10 && Calendar.current.component(.minute, from: Date()) >= 45) {
                displayTime(mins: 139)
                message.text = "4th period ends at 12:20 in"
                
                //4th period (11:00-12:00)
            } else if (Calendar.current.component(.hour, from: Date()) == 11) {
                displayTime(mins: 79)
                message.text = "4th period ends at 12:20 in"
                
                //4th period (12:00-12:20)
            } else if (Calendar.current.component(.hour, from: Date()) == 12 && Calendar.current.component(.minute, from: Date()) < 20) {
                displayTime(mins: 19)
                message.text = "4th period ends at 12:20 in"
                
                //Lunch (12:20-12:55)
            } else if (Calendar.current.component(.hour, from: Date()) == 12 && Calendar.current.component(.minute, from: Date()) >= 20 && Calendar.current.component(.minute, from: Date()) < 55) {
                displayTime(mins: 54)
                message.text = "Lunch ends at 12:55 in"
                
                //INSERT NOTIFICATION AT 12:53 SAYING 2 MIN LEFT
                
                //6th period (12:55-1:00)
            } else if (Calendar.current.component(.hour, from: Date()) == 12 && Calendar.current.component(.minute, from: Date()) >= 55) {
                displayTime(mins: 144)
                message.text = "6th period ends at 2:25 in"
                
                //6th period (1:00-2:00)
            } else if (Calendar.current.component(.hour, from: Date()) == 13) {
                displayTime(mins: 84)
                message.text = "6th period ends at 2:25 in"
                
                //6th period (2:00-2:25)
            } else if (Calendar.current.component(.hour, from: Date()) == 14 && Calendar.current.component(.minute, from: Date()) < 25) {
                displayTime(mins: 24)
                message.text = "6th period ends at 2:25 in"
                
                //after school (2:25-3:00)
            } else if (Calendar.current.component(.hour, from: Date()) == 14 && Calendar.current.component(.minute, from: Date()) >= 25) {
                afterSchool()
                
                //after school (3:00+)
            } else if (Calendar.current.component(.hour, from: Date()) >= 15) {
                afterSchool()
            }
            
            //------------------------THURSDAY--------------------------------
        } else if (Calendar.current.component(.weekday, from: Date()) == 5) {
            
            //BEFORE 7:00
            if (Calendar.current.component(.hour, from: Date()) < 7) {
                hideTimer();
                morning.isHidden = false;
                
                //7-7:30
            } else if (Calendar.current.component(.hour, from: Date()) == 7 && Calendar.current.component(.minute, from: Date()) < 30) {
                displayTime(mins: 29)
                message.text = "1st period starts at 7:30 in"
                
                //1st period (7:30-8:00)
            } else if ((Calendar.current.component(.hour, from: Date()) == 7 && Calendar.current.component(.minute, from: Date()) >= 30)) {
                displayTime(mins: 119)
                message.text = "1st period ends at 9:00 in"
                
                //1st period (8:00-9:00)
            } else if (Calendar.current.component(.hour, from: Date()) == 8) {
                displayTime(mins: 59)
                message.text = "1st period ends at 9:00 in"
                
                //Passing period (9:00-9:05)
            } else if (Calendar.current.component(.hour, from: Date()) == 9 && Calendar.current.component(.minute, from: Date()) < 5) {
                displayTime(mins: 4)
                message.text = "3rd period starts at 9:05 in"
                
                //3rd period (9:05-10:00)
            } else if (Calendar.current.component(.hour, from: Date()) == 9 && Calendar.current.component(.minute, from: Date()) >= 5) {
                displayTime(mins: 94)
                message.text = "3rd period ends at 10:35 in"
                
                //3rd period (10:00-10:35)
            } else if (Calendar.current.component(.hour, from: Date()) == 10 && Calendar.current.component(.minute, from: Date()) < 35) {
                displayTime(mins: 34)
                message.text = "3rd period ends at 10:35 in"
                
                //Passing period (10:35-10:45)
            } else if (Calendar.current.component(.hour, from: Date()) == 10 && Calendar.current.component(.minute, from: Date()) >= 35 && Calendar.current.component(.minute, from: Date()) < 45) {
                displayTime(mins: 44)
                message.text = "5th period starts at 10:45 in"
                
                //5th period (10:45-11:00)
            } else if (Calendar.current.component(.hour, from: Date()) == 10 && Calendar.current.component(.minute, from: Date()) >= 45) {
                displayTime(mins: 139)
                message.text = "5th period ends at 12:20 in"
                
                //5th period (11:00-12:00)
            } else if (Calendar.current.component(.hour, from: Date()) == 11) {
                displayTime(mins: 79)
                message.text = "5th period ends at 12:20 in"
                
                //5th period (12:00-12:20)
            } else if (Calendar.current.component(.hour, from: Date()) == 12 && Calendar.current.component(.minute, from: Date()) < 20) {
                displayTime(mins: 19)
                message.text = "5th period ends at 12:20 in"
                
                //Lunch (12:20-12:55)
            } else if (Calendar.current.component(.hour, from: Date()) == 12 && Calendar.current.component(.minute, from: Date()) >= 20 && Calendar.current.component(.minute, from: Date()) < 50) {
                displayTime(mins: 54)
                message.text = "Lunch ends at 12:55 in"
                
                //INSERT NOTIFICATION AT 12:53 SAYING 2 MIN LEFT
                
                //7th period (12:55-1:00)
            } else if (Calendar.current.component(.hour, from: Date()) == 12 && Calendar.current.component(.minute, from: Date()) >= 55) {
                displayTime(mins: 144)
                message.text = "7th period ends at 2:25 in"
                
                //7th period (1:00-2:00)
            } else if (Calendar.current.component(.hour, from: Date()) == 13) {
                displayTime(mins: 84)
                message.text = "7th period ends at 2:25 in"
                
                //7th period (2:00-2:25)
            } else if (Calendar.current.component(.hour, from: Date()) == 14 && Calendar.current.component(.minute, from: Date()) < 25) {
                displayTime(mins: 24)
                message.text = "7th period ends at 2:25 in"
                
                //after school (2:25-3:00)
            } else if (Calendar.current.component(.hour, from: Date()) == 14 && Calendar.current.component(.minute, from: Date()) >= 25) {
                afterSchool()
                
                //after school (3:00+)
            } else if (Calendar.current.component(.hour, from: Date()) >= 15) {
                afterSchool()
            }
            
            //----------------------------WEEKENDS-------------------------------
        } else if (Calendar.current.component(.weekday, from: Date()) == 7 || Calendar.current.component(.weekday, from: Date()) == 1) {
            hideTimer();
            weekend.isHidden = false;
        }
        
    }
    
    func showTimer() {
        morning.isHidden = true;
        outOfHours.isHidden = true;
        weekend.isHidden = true;
        
        message.isHidden = false;
        
        minLeft.isHidden = false;
        secLeft.isHidden = false;
        
        minLabel.isHidden = false;
        secLabel.isHidden = false;
    }
    
    func hideTimer() {
        /*if (message != nil) {
            message.isHidden = true;
        }
        if (minLeft != nil) {
            minLeft.isHidden = true;
        }
        if (secLeft != nil) {
            secLeft.isHidden = true;
        }
        if (minLabel != nil) {
            minLabel.isHidden = true;
        }
        if (secLabel != nil) {
            secLabel.isHidden = true;
        }*/
        message.isHidden = true;
        minLeft.isHidden = true;
        secLeft.isHidden = true;
        minLabel.isHidden = true;
        secLabel.isHidden = true;
    }
    
    func displayTime(mins: Int) {
        showTimer();
        minLeft.text = String(mins-Calendar.current.component(.minute, from: Date()))
        secLeft.text = String(59-Calendar.current.component(.second, from: Date()))
    }
    
    func afterSchool() {
        hideTimer();
        /*if (outOfHours != nil) {
            outOfHours.isHidden = false;
        }*/
        outOfHours.isHidden = false;
    }
}

