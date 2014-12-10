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
    var eventsByDate: NSMutableDictionary!
    var dateFormatter = NSDateFormatter()

    @IBOutlet weak var contentView: JTCalendarContentView!
    @IBOutlet weak var menuView: JTCalendarMenuView!

    func calendarHaveEvent(calendar: JTCalendar!, date: NSDate!) -> Bool {
        var key = dateFormatter.stringFromDate(date)
        var events = eventsByDate[key] as NSArray?
        if events != nil && events?.count > 0 {
            return true
        }
        return false
    }

    func calendarDidDateSelected(calendar: JTCalendar!, date: NSDate!) {
        var key = dateFormatter.stringFromDate(date)
        var events = eventsByDate[key] as NSArray?
    }

    func randomizeEvents() {
        eventsByDate = NSMutableDictionary()
        for i in 1...30 {
            var randomDate = NSDate(timeInterval: NSTimeInterval(rand() % (3600 * 24 * 60)), sinceDate: NSDate())
            var key = dateFormatter.stringFromDate(randomDate)

            if eventsByDate[key] == nil {
                eventsByDate[key] = NSMutableArray()
            }

            eventsByDate[key]?.addObject(randomDate)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        calendar.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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

        randomizeEvents()

        // Do any additional setup after loading the view.
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
