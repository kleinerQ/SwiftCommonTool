//
//  _0191018_swiftCommonToolTests.swift
//  20191018_swiftCommonToolTests
//
//  Created by Yen on 2019/10/21.
//  Copyright © 2019 com.pacify.mplatform. All rights reserved.
//

import XCTest

class _0191018_swiftCommonToolTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testServerEarlyDate() {
        let p = SwiftCommonTool.serverEarlyDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let someDateTime = formatter.date(from: "2000/01/01 00:00")
        XCTAssert(p == someDateTime)
    }
    
    func testGetServerTimeWithDate() {
        let date = Date()
        let stamp = Int(date.timeIntervalSince1970 * RATE_DIFF)
        let p = SwiftCommonTool.getServerTimeWithDate(date: date)

        XCTAssert(p == stamp)
    }
    
    func testGetDateWithServerTime(){
        let date = Date.init(timeIntervalSince1970: 123456789)
        let p = SwiftCommonTool.getDateWithServerTime(serverTime: 123456789000)
        
        XCTAssert(p == date)
    }
    
    func testGetServerTimeWithFBTime(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let someDateTime = formatter.date(from: "2000/01/01 00:00")!
        
        let p = SwiftCommonTool.getServerTimeWithFBTime(FBTime: "2000-01-01T00:00:00+0800")
        XCTAssert(p == SwiftCommonTool.getServerTimeWithDate(date: someDateTime))
    }
    
    
    func testGetTimeWithTimeStr(){
        let p = SwiftCommonTool.getTimeWithTimeStr(timeStr: "01:00")
        XCTAssert(p == Int(TimeInterval(60)))
    }
    
    func testGetNowWeek(){
        let p = SwiftCommonTool.getNowWeek()
        XCTAssert(p == 1)
    }

    func testGetServerTimeToMonthAgo(){
        let date = Date()
        let p = SwiftCommonTool.getServerTimeToMonthAgo(date: date)
        let q = Int(date.addingTimeInterval(-86400 * 30).timeIntervalSince1970 * (RATE_DIFF))
        XCTAssert(p == q)
    }
    
    func testIsToday(){
        let date = Date()
        var p = SwiftCommonTool.isToday(date: date)
        XCTAssert(p == true)
        
        p = SwiftCommonTool.isToday(date: date.addingTimeInterval(-86400))
        XCTAssert(p == false)
    }
    
    func testIsThisMonth(){
        let date = Date()
        var p = SwiftCommonTool.isThisMonth(date: date)
        XCTAssert(p == true)
        
        p = SwiftCommonTool.isThisMonth(date: date.addingTimeInterval(-86400 * 30))
        XCTAssert(p == false)
        
        p = SwiftCommonTool.isThisMonth(date: date.addingTimeInterval(86400 * 30))
        XCTAssert(p == false)
    }
    
    func testIsThisYear(){
        let date = Date()
        var p = SwiftCommonTool.isThisYear(date: date)
        XCTAssert(p == true)
        
        p = SwiftCommonTool.isThisYear(date: date.addingTimeInterval(-86400 * 365))
        XCTAssert(p == false)
        
        p = SwiftCommonTool.isThisYear(date: date.addingTimeInterval(86400 * 365))
        XCTAssert(p == false)
    }
    
    func testGetDateFormatter_TodayHHmm(){
        let date = Date()
        let p = SwiftCommonTool.getDateFormatter_TodayHHmm(date: date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let someDateStr = formatter.string(from: date)
        XCTAssert(p == "今天 \(someDateStr)")
        
    }
    
    func testGetDateFormatter_HHmm(){
        let date = Date()
        let p = SwiftCommonTool.getDateFormatter_HHmm(date: date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let someDateStr = formatter.string(from: date)
        XCTAssert(p == "\(someDateStr)")
        
    }
    
    func testGetDateFormatter_MMddHHmm(){
        let date = Date()
        let p = SwiftCommonTool.getDateFormatter_MMddHHmm(date: date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        let someDateStr = formatter.string(from: date)
        XCTAssert(p == "\(someDateStr)")
        
    }
    
    func testGetDateFormatter_yyyyMMddHHmm(){
        let date = Date()
        let p = SwiftCommonTool.getDateFormatter_yyyyMMddHHmm(date: date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let someDateStr = formatter.string(from: date)
        XCTAssert(p == "\(someDateStr)")
        
    }
    
    func testGetFBTimeFormatter_yyyyMMddTHHmmssZZZZ(){
        let date = Date()
        let p = SwiftCommonTool.getFBTimeFormatter_yyyyMMddTHHmmssZZZZ(date: date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZ"
        let someDateStr = formatter.string(from: date)
        XCTAssert(p == "\(someDateStr)")
        
    }
    
    func testGetDateFormatter_yyyyMMddEEEE(){
        let date = Date()
        let p = SwiftCommonTool.getDateFormatter_yyyyMMddEEEE(date: date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd EEEE"
        let someDateStr = formatter.string(from: date)
        XCTAssert(p == "\(someDateStr)")
        
    }
    
    func testGetDateFormatter_yyyyMMdd(){
        let date = Date()
        let p = SwiftCommonTool.getDateFormatter_yyyyMMdd(date: date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let someDateStr = formatter.string(from: date)
        XCTAssert(p == "\(someDateStr)")
        
    }
    
    func testGetWeekForMatterWithIndex(){

        let p = SwiftCommonTool.getWeekForMatterWithIndex(index: 1)
        XCTAssert(p == "Monday")
        
    }
    
    func testGetOpenHourForMatterWithString(){
        
        var p = SwiftCommonTool.getOpenHourForMatterWithString(str: "00~00")
        XCTAssert(p == "24小時")
        p = SwiftCommonTool.getOpenHourForMatterWithString(str: "00~01")
        XCTAssert(p == "00~01")

    }
    
    func testGetCountDaysFromStartDate(){
        let date = Date()
        var p = SwiftCommonTool.getCountDaysFromStartDate(startDate: date.addingTimeInterval(-86400 * 2), endDate: date)
        XCTAssert(p == 2)
        p = SwiftCommonTool.getCountDaysFromStartDate(startDate: date.addingTimeInterval(-86400 * 1), endDate: date)
        XCTAssert(p == 1)
        p = SwiftCommonTool.getCountDaysFromStartDate(startDate: date.addingTimeInterval(86400 * 2), endDate: date)
        XCTAssert(p == -2)
        p = SwiftCommonTool.getCountDaysFromStartDate(startDate: date.addingTimeInterval(86400 * 1), endDate: date)
        XCTAssert(p == -1)
        p = SwiftCommonTool.getCountDaysFromStartDate(startDate: date.addingTimeInterval(86400 * 0), endDate: date)
        XCTAssert(p == 0)
    }
    
    func testGetSpecialHourTimeDate(){
        let date = Date()
        let todaySpecilHourDate = Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: date) ?? Date()
        let p = SwiftCommonTool.getSpecialHourTimeDate(date: date, hourTime: "14")
        XCTAssert(p == todaySpecilHourDate)
        
    }
    
    func testAddDayWithDate(){
        let date = Date()
        var addedDate = Calendar.current.date(byAdding: .day, value: 2, to: date)
        var p = SwiftCommonTool.addDayWithDate(date: date, days: 2)
        XCTAssert(p == addedDate)
        
        addedDate = Calendar.current.date(byAdding: .day, value: -2, to: date)
        p = SwiftCommonTool.addDayWithDate(date: date, days: -2)
        XCTAssert(p == addedDate)
        addedDate = Calendar.current.date(byAdding: .day, value: 0, to: date)
        p = SwiftCommonTool.addDayWithDate(date: date, days: 0)
        XCTAssert(p == addedDate)
    }
    
    func testStringFromTimeInterval(){

        var p = SwiftCommonTool.stringFromTimeInterval(interval: TimeInterval(90060))
        XCTAssert(p == "1天 1小時 1分")
        
        p = SwiftCommonTool.stringFromTimeInterval(interval: TimeInterval(90000))
        XCTAssert(p == "1天 1小時")
        
        p = SwiftCommonTool.stringFromTimeInterval(interval: TimeInterval(86460))
        XCTAssert(p == "1天 1分")
        
        p = SwiftCommonTool.stringFromTimeInterval(interval: TimeInterval(86400))
        XCTAssert(p == "1天")
        
        p = SwiftCommonTool.stringFromTimeInterval(interval: TimeInterval(3660))
        XCTAssert(p == "1小時 1分")
        
        p = SwiftCommonTool.stringFromTimeInterval(interval: TimeInterval(3600))
        XCTAssert(p == "1小時")
        
        p = SwiftCommonTool.stringFromTimeInterval(interval: TimeInterval(60))
        XCTAssert(p == "1分")
    }
    
    
}
