//
//  CalendarViewController.swift
//  socialCalendar
//
//  Created by Miles Crabill on 12/9/14.
//  Copyright (c) 2014 AIT. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, JTCalendarDataSource {

    var calendar = JTCalendar()
    var eventsByDate = NSMutableDictionary()
    var dateFormatter = NSDateFormatter()

    @IBOutlet weak var contentView: JTCalendarContentView!
    @IBOutlet weak var menuView: JTCalendarMenuView!

    @IBOutlet weak var centerView: UIView!

    @IBOutlet weak var detailsForEvent: UILabel!
    
    func calendarHaveEvent(calendar: JTCalendar!, date: NSDate!) -> Bool {
        var key = dateFormatter.stringFromDate(date)

        if let specificDate = eventsByDate[key] as? NSMutableArray {
            if specificDate.count > 0 {
                return true
            }
        }
        return false
    }

    func calendarDidDateSelected(calendar: JTCalendar!, date: NSDate!) {
        var key = dateFormatter.stringFromDate(date)
        if let events = eventsByDate[key] as? NSMutableArray {
            var message = ""
            for event in events {
                if key == dateFormatter.stringFromDate(event["date"] as NSDate) {
                    var output = event["name"] as String

                    message += output
                }
            }
            
            detailsForEvent.text = message

//            var popTipView = CMPopTipView(message: "\(message)")
//            popTipView.dismissTapAnywhere = true
//            popTipView.animation = CMPopTipAnimationSlide;
//            popTipView.has3DStyle = true;
//            popTipView.presentPointingAtView(centerView, inView: self.view, animated: true)
        }

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        calendar.reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        refreshEvents()
    }

    func refreshEvents() {
        var addAllEvents = PFQuery(className: "Event")
        addAllEvents.whereKey("user", equalTo: PFUser.currentUser())
        addAllEvents.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]!, error: NSError!) -> Void in

            self.eventsByDate.removeAllObjects()

            for object in objects {
                let event = object["user"] as PFUser
                if event.objectId as String == PFUser.currentUser().objectId as String {
                    var key = self.dateFormatter.stringFromDate(object["date"] as NSDate)
                    self.eventsByDate[key] = NSMutableArray()
                    self.eventsByDate[key]?.addObject(object as PFObject)
                }
            }
            
        })
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshEvents()

        self.calendar.calendarAppearance.calendar().firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9 / 10;
        self.calendar.calendarAppearance.ratioContentMenu = 2;

        self.calendar.calendarAppearance.monthBlock = {
            date, cal in
            var calendar = cal.calendarAppearance.calendar()
            var comps = calendar.components(NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth, fromDate: date)
            var currentMonth = comps.month

            while currentMonth <= 0 {
                currentMonth += 12
            }

            var monthText = self.dateFormatter.standaloneMonthSymbols[currentMonth - 1].capitalizedString

            return "\(comps.year)\n\(monthText)"
        }

        calendar.menuMonthsView = menuView
        calendar.contentView = contentView
        calendar.dataSource = self

        dateFormatter.dateFormat = "dd-MM-yyyy"

        // Do any additional setup after loading the view.
        calendar.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
