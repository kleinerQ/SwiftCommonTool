//
//  SwiftCommonTool.swift
//  20190726_TRA
//
//  Created by Yen on 2019/10/18.
//  Copyright © 2019 Yen. All rights reserved.
//

import UIKit
import MapKit
let RATE_DIFF = Double(1000)
let daySec = 86400
class SwiftCommonTool: NSObject {
    
    
    //MARK:UIButton
    ///在UITextField鍵盤上加入確定按鈕
    static func addKeyboardButtonWithTextField(textField:UITextField){
        let vc = self.viewControllerFromView(view: textField)
        guard let _ = vc else{
            return
        }
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: "Done"), style: .done, target: vc?.view, action: #selector(textField.endEditing(_:)))
        doneBarButton.tintColor = UIColor.init(hexString: "#74C1CD")
        keyboardToolbar.items = [flexBarButton,doneBarButton]
        textField.inputAccessoryView = keyboardToolbar
        
    }
    
    
    /// 在UITextField鍵盤上加入上下切換與確定鈕
    static func addKeyboardButtonWithTextField(textField:UITextField, upButton upAction:Selector?, downButton downAction:Selector?){
        let vc = self.viewControllerFromView(view: textField)
        guard let _ = vc else{
            return
        }
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let upBarButton = UIBarButtonItem(image: UIImage(named: "icon_arrow_up_timming_blue"), style: .done, target: vc, action: upAction)
        upBarButton.isEnabled = (upAction != nil) ? true : false;
        let downBarButton = UIBarButtonItem(image: UIImage(named: "icon_arrow_down_timming_blue"), style: .done, target: vc, action: downAction)
        downBarButton.isEnabled = (downAction != nil) ? true : false;
        
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: "Done"), style: .done, target: vc?.view, action: #selector(textField.endEditing(_:)))
        doneBarButton.tintColor = UIColor.init(hexString: "#74C1CD")
        upBarButton.tag = textField.tag
        downBarButton.tag = textField.tag
        keyboardToolbar.items = [upBarButton, downBarButton, flexBarButton, doneBarButton]
        textField.inputAccessoryView = keyboardToolbar
        
    }
    
    
    /// 切換UITextField欄位
    static func jumpToNextTextField(textField:UITextField, withTag tag:Int){
        //參考 http://mapostolakis.com/blog/2014/5/22/how-to-jump-to-next-uitextfield-from-the-keyboard
        let vc = self.viewControllerFromView(view: textField)
        guard let _ = vc else{
            return
        }
        
        let nextResponder = vc?.view.viewWithTag(tag)
        if nextResponder?.isKind(of: UITextField.self) ?? false{
            nextResponder?.becomeFirstResponder()
        }
    }
    
    /// 在UITextView鍵盤上加入確定按鈕
    static func addKeyboardButtonWithTextView(textView:UITextView){
        let vc = self.viewControllerFromView(view: textView)
        guard let _ = vc else{
            return
        }
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: "Done"), style: .done, target: vc?.view, action: #selector(textView.endEditing(_:)))
        doneBarButton.tintColor = UIColor.init(hexString: "#74C1CD")
        keyboardToolbar.items = [flexBarButton,doneBarButton]
        textView.inputAccessoryView = keyboardToolbar
        
    }
    
    
    
}


//MARK:Date
extension SwiftCommonTool{
    
    static func serverEarlyDate()->Date{
        let dateString = "2000/1/1 00:00"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d HH:mm"
        
        return formatter.date(from: dateString)!
    }
    
    static func getServerTimeWithDate(date:Date)->Int64{
        let time = date.timeIntervalSince1970 * RATE_DIFF
        return Int64(time)
    }
    
    static func getDateWithServerTime(serverTime:Int64)->Date{
        let time:TimeInterval = TimeInterval(serverTime / Int64(RATE_DIFF))
        let date = Date.init(timeIntervalSince1970: time)
        return date
    }
    
    static func getServerTimeWithFBTime(FBTime:String)->Int64{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZ"
        formatter.timeZone = NSTimeZone.system
        guard let wrappedDate = formatter.date(from: FBTime.replacingOccurrences(of: "T", with: " ")) else{
            print("getServerTimeWithFBTime error")
            fatalError()
        }
        return self.getServerTimeWithDate(date:wrappedDate)
    }
    
    // wierd, why 60, why not 3600
    static func getTimeWithTimeStr(timeStr:String)->Int64{
        let array = timeStr.components(separatedBy: ":")
        if array.indices.contains(0) && array.indices.contains(1){
            
            let h = array[0]
            let m = array[1]
            guard let hour = Int64(h), let min = Int64(m) else{
                print("getTimeWithTimeStr error")
                fatalError()
            }
            
            let time:Int64 = hour * 60 + min
            return time
            
        }else{
            print("getTimeWithTimeStr error")
            fatalError()
        }
        
        
    }
    
    
    /// weekDay
    ///
    /// - Returns: 1:Monday; 7:Sunday
    static func getNowWeek()->Int{
        let weekDay = Calendar.current.component(.weekday, from: Date())
        if weekDay == 1{
            return 7
        }else{
            return weekDay - 1
        }
    }

    
    ///取得 Date一個月前的伺服器時戳
    static func getServerTimeToMonthAgo(date:Date)->Int64{
        
        var comp = Calendar.current.dateComponents([.day,.month,.year,.hour,.minute,.second], from: date)
        guard let monthComp = comp.month else {
            print("getServerTimeToMonthAgo error")
            fatalError()
        }
        comp.setValue(monthComp - 1, for: .month)
        guard let finalDate = Calendar.current.date(from: comp) else{
            print("getServerTimeToMonthAgo error")
            fatalError()
        }
        let serverTime = self.getServerTimeWithDate(date: finalDate)
        return serverTime
    }
    
    ///判斷該 Date 是否是當天日期
    static func isToday(date:Date)->Bool{
        let cal = Calendar.current
        let todayComponents = cal.dateComponents([.era,.year,.month,.day], from: Date())
        let dateComponents  = cal.dateComponents([.era,.year,.month,.day], from: date)
        return todayComponents == dateComponents
        
    }
    ///判斷該 Date 是否是當月
    static func isThisMonth(date:Date)->Bool{
        let cal = Calendar.current
        let todayComponents = cal.dateComponents([.era,.year,.month], from: Date())
        let dateComponents  = cal.dateComponents([.era,.year,.month], from: date)
        return todayComponents == dateComponents
        
    }
    
    ///判斷該 Date 是否是當年
    static func isThisYear(date:Date)->Bool{
        let cal = Calendar.current
        let todayComponents = cal.dateComponents([.era,.year], from: Date())
        let dateComponents  = cal.dateComponents([.era,.year], from: date)
        return todayComponents == dateComponents
        
    }
    
    
    ///將 Date 轉換為 [Today HH:mm] 格式的 String
    static func getDateFormatter_TodayHHmm(date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = NSTimeZone.system
        return NSLocalizedString("今天", comment: "今天") + " " + formatter.string(from: date)
    }
    
    ///將 Date 轉換為 [HH:mm] 格式的 String
    static func getDateFormatter_HHmm(date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = NSTimeZone.system
        return formatter.string(from: date)
    }
    
    ///將 Date 轉換為 [MM/dd HH:mm] 格式的 String
    static func getDateFormatter_MMddHHmm(date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        formatter.timeZone = NSTimeZone.system
        return formatter.string(from: date)
    }
    
    ///將 Date 轉換為 [yyyy/MM/dd HH:mm] 格式的 String
    static func getDateFormatter_yyyyMMddHHmm(date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.timeZone = NSTimeZone.system
        return formatter.string(from: date)
    }
    
    ///將 FBTime 轉換為 [yyyy-MM-dd HH:mm:ssZZZZ] 格式的 String
    static func getFBTimeFormatter_yyyyMMddTHHmmssZZZZ(date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZ"
        formatter.timeZone = NSTimeZone.system
        return formatter.string(from: date)
    }
    
    
    ///將 Date 轉換為 [yyyy/MM/dd EEEE] 格式的 String
    static func getDateFormatter_yyyyMMddEEEE(date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd EEEE"
        formatter.timeZone = NSTimeZone.system
        return formatter.string(from: date)
    }
    
    ///將 Date 轉換為 [yyyy/MM/dd] 格式的 String
    static func getDateFormatter_yyyyMMdd(date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.timeZone = NSTimeZone.system
        return formatter.string(from: date)
    }
    
    ///將 Date 轉換為 [yyyyMMdd] 格式的 String
    static func getDateFormatter_yyyyMMdd_No_seperator(date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.timeZone = NSTimeZone.system
        return formatter.string(from: date)
    }
    
    ///取得星期格式
    static func getWeekForMatterWithIndex(index:Int)->String{
        let formatter = DateFormatter()
        guard let weeks = formatter.standaloneWeekdaySymbols else{
            print("getWeekForMatterWithIndex error")
            fatalError()
        }
        
        if index == 7{
            return weeks[0]
        }else{
            return weeks[index]
        }
    }
    
    ///取是否為24小時格式
    static func getOpenHourForMatterWithString(str:String)->String{
        let ary = str.components(separatedBy: "~")
        guard let _ = ary.first, let _ = ary.last else {
            
            return str
        }
        if ary.first! == ary.last! && ary.count > 1{
            return NSLocalizedString("24小時", comment: "24小時")
        }else{
            return str
        }
    }
    
    ///取得天數
    static func getCountDaysFromStartDate(startDate:Date, endDate:Date)->Int{
        let components = Calendar.current.dateComponents([.day], from: startDate, to: endDate)
        guard let _ = components.day else {
            print("getCountDaysFromStartDate error")
            fatalError()
        }
        return components.day!
    }
    
    ///取得特定小時的日期
    static func getSpecialHourTimeDate(date:Date, hourTime:String)->Date{
        let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = NSTimeZone.default
        
        
        guard let _ = component.year, let _ = component.month, let _ = component.day else{
            print("getSpecialHourTimeDate error")
            fatalError()
        }
        let year = String(component.year!)
        let month = String(component.month!)
        let day = String(component.day!)
        guard let _ = formatter.date(from: "\(year)-\(month)-\(day) \(hourTime):00:00") else{
            print("getSpecialHourTimeDate error")
            fatalError()
        }
        return formatter.date(from: "\(year)-\(month)-\(day) \(hourTime):00:00")!
    }
    
    ///增加天數
    static func addDayWithDate(date:Date,days:Int)->Date{
        guard let _ = Calendar.current.date(byAdding: .day, value: days, to: date) else{
            print("addDayWithDate error")
            fatalError()
        }
        return Calendar.current.date(byAdding: .day, value: days, to: date)!
    }
    ///依時間秒數換成文字字串(約x天x小時x分)
    static func stringFromTimeInterval(interval:TimeInterval)->String{
        var finalStr = ""
        let minutes = (Int(interval) / 60) % 60;
        let hours = (Int(interval) / 3600) % 24;
        let days = (Int(interval) / 86400);
        
        if days > 0{
            finalStr.append("\(days)" + NSLocalizedString("天", comment: "天"))
        }
        
        if hours > 0 {
            if finalStr != ""{
                finalStr.append(" ")
            }
            finalStr.append("\(hours)" + NSLocalizedString("小時", comment: "小時"))
        }
        
        if minutes > 0{
            if finalStr != ""{
                finalStr.append(" ")
            }
            finalStr.append("\(minutes)" + NSLocalizedString("分", comment: "分"))
        }
        
        return finalStr
    }
    //convert 108/10/31 to 2019/10/31
    func convertROCYearStrToWestYearStr(rocYearStr:String)->String{
        let dateYearArray = rocYearStr.split(separator: "/")
        if dateYearArray.count != 3{
            fatalError()
        }
        guard let intYear = Int(dateYearArray[0]) else{
            fatalError()
        }
        let westYearStr = String(intYear + 1911)
        
        return "\(westYearStr)/\(dateYearArray[1])/\(dateYearArray[2])"
    }
}

//MARK:open others
extension SwiftCommonTool{
    
    ///開啟map導航
    static func openMapWithCoordinate(coordinate:CLLocationCoordinate2D){
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!){
            let coordinateString = "comgooglemaps://?sddr=@\"\"&daddr=\(coordinate.latitude),\(coordinate.longitude)"
            UIApplication.shared.open(URL(string: coordinateString)!, options: [:], completionHandler: nil)
        }else{
            let coordinateString = "https://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)"
            UIApplication.shared.open(URL(string: coordinateString)!, options: [:], completionHandler: nil)
        }
    }
    
    static func openiOSSetting(){
        let url = URL(string: UIApplication.openSettingsURLString)!
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}


//MARK:ViewController
extension SwiftCommonTool{
    ///  由 view 取得 viewController
    static func viewControllerFromView(view:UIView)->UIViewController?{
        var parentResponder: UIResponder? = view
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    ///get top most viewController
    static func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
    
    
    /// present popView, Notice, besure to implement UIPopoverPresentationControllerDelegate in originalVC
    /// - Parameter originalVC: <#originalVC description#>
    /// - Parameter popedVC: <#popedVC description#>
    /// - Parameter sender: <#sender description#>
    static func popViewController(originalVC: UIViewController , popedVC:UIViewController, sender:UIView) {
        
        let vc = popedVC
        vc.modalPresentationStyle = .popover
        guard let popVC = vc.popoverPresentationController else {
            return
        }
        
        popVC.permittedArrowDirections = .up
        popVC.sourceView = sender
        let senderRect = sender.convert(sender.frame, from: sender.superview)
        let sourceRect = CGRect(x: senderRect.origin.x, y: senderRect.origin.y + (sender.frame.size.height / 2), width: senderRect.size.width, height: senderRect.size.height)
        popVC.sourceRect = sourceRect
        popVC.delegate = originalVC as? UIPopoverPresentationControllerDelegate
        originalVC.present(vc, animated: true, completion: nil)
    }
    /*
    // MARK: UIPopoverPresentationControllerDelegate
    extension ViewController: UIPopoverPresentationControllerDelegate {
        func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return .none
        }
        
        func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
            return true
        }
    }
    */
}


extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    @objc convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
        
    }
}


extension UIImage {
    class func circle(diameter: CGFloat, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)
        
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
    
    
    class func gradientCircle(diameter: CGFloat, colors: [UIColor]) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(UIColor.init(patternImage: UIImage.createGradientImage(squareSize: diameter, colors: colors, verticalFlag: true)).cgColor)
        ctx.fillEllipse(in: rect)
        
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
    
    /// if horizontal gradient, set the flag to false
    class func createGradientImage(squareSize: CGFloat, colors: [UIColor], verticalFlag :Bool = true)->UIImage{
        guard let startColor = colors.first else{
            return UIImage()
        }
        guard let endColor = colors.last else{
            return UIImage()
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: squareSize, height: squareSize), false, 0)
        let rect = CGRect(x: 0, y: 0, width: squareSize, height: squareSize)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let startColorComponents = startColor.cgColor.components else { fatalError() }
        guard let endColorComponents = endColor.cgColor.components else { fatalError() }
        let colorComponents: [CGFloat]
            = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
        let locations:[CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorSpace: colorSpace,colorComponents: colorComponents,locations: locations,count: 2) else { fatalError() }
        
        var startPoint = CGPoint(x: 0, y: 0)
        var endPoint = CGPoint(x: 0,y: 0)
        if verticalFlag{
            startPoint = CGPoint(x: 0, y: rect.height)
            endPoint = CGPoint(x: 0,y: 0)
        }else{
            startPoint = CGPoint(x: rect.width, y: 0)
            endPoint = CGPoint(x: 0,y: 0)
        }
        
        
        ctx.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    class func imageWithCircle(name: String?) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .white
        nameLabel.textColor = UIColor.init(hexString: "#727171")
        nameLabel.font = UIFont.boldSystemFont(ofSize: 40)
        nameLabel.text = name
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return self.round(image: nameImage!)
        }
        return nil
    }
    class func round(image: UIImage) -> UIImage {
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        let diameter = min(imageWidth, imageHeight)
        let isLandscape = imageWidth > imageHeight
        
        let xOffset = isLandscape ? (imageWidth - diameter) / 2 : 0
        let yOffset = isLandscape ? 0 : (imageHeight - diameter) / 2
        
        let imageSize = CGSize(width: diameter, height: diameter)
        
        return UIGraphicsImageRenderer(size: imageSize).image { _ in
            
            let ovalPath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: imageSize))
            ovalPath.addClip()
            image.draw(at: CGPoint(x: -xOffset, y: -yOffset))
            UIColor.init(hexString: "#28708B").setStroke()
            ovalPath.lineWidth = 5
            ovalPath.stroke()
        }
    }
    // assume asset size is 30*30
    func addTextBelowImage(text: NSString, fontSize:CGFloat = 12) -> UIImage{
        
        // Setup the font specific variables
        let textColor:UIColor = .black
        let textFont:UIFont = .systemFont(ofSize: fontSize)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
        ]
        
        // Create bitmap based graphics context
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 50, height: 50  + fontSize + 2), false, 0.0)

        
        //Put the image into a rectangle as large as the original image.
        self.draw(in: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        let textSize = text.size(withAttributes: [NSAttributedString.Key.font:textFont])
        let textRect = CGRect(x: 25 - textSize.width / 2.0, y: 50,
                              width: textSize.width, height: textSize.height)
        text.draw(in: textRect, withAttributes: textFontAttributes)
        
        // Get the image from the graphics context
        let newImag = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImag ?? UIImage()

    }
    //UIImage(named: "icon_comment")?.withRenderingMode(.alwaysTemplate)
    func filled(withColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else { return self }

        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let mask = cgImage else { return self }
        context.clip(to: rect, mask: mask)
        context.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}


extension UIView{
    func fadeIn(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: completion)
    }
    
    /// SwifterSwift: Fade out view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    func fadeOut(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: completion)
    }
}

extension UIImageView {
    // save to tmp once downloaded
    func setUrlAndDownloadImage(imgURLString: String?) {
        self.accessibilityIdentifier = imgURLString ?? "" // this vaule may be change for reused cell
        let requestIdentifier = imgURLString ?? "" // this is to identify who do the task, if the accessibilityIdentifier has change, then cancel the task
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        self.compareIdentifierAndSetImage(identifier: requestIdentifier, image: UIImage(named: "icon_fail") ?? UIImage())
        self.compareIdentifierAndAddRemoveLoading(isAdd: true,identifier: requestIdentifier)
        guard let imageURLString = imgURLString else {
            return
        }
        
        guard let url = URL(string: imageURLString) else{
            return
        }
        //check if in tmp before do task
        if self.checkInTmp(fileName: url.lastPathComponent).0{
            guard let imgInTmp = self.readImageInTmp(name: url.lastPathComponent) else{
                return
            }
            self.compareIdentifierAndSetImage(identifier: requestIdentifier, image: imgInTmp)
            self.compareIdentifierAndAddRemoveLoading(isAdd: false,identifier: requestIdentifier)
        }else{
            // this delay prevent keeping sending task, would wait and to check if really needed to do task
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {[weak self] in
                if self?.accessibilityIdentifier == requestIdentifier{
                    let task = URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                _ = self?.saveImageInTmp(image: UIImage(data: data)!, name: url.lastPathComponent)
                                self?.compareIdentifierAndSetImage(identifier: requestIdentifier, image: image)
                                self?.compareIdentifierAndAddRemoveLoading(isAdd: false,identifier: requestIdentifier)
                            }
                            
                        }else{
                            self?.compareIdentifierAndAddRemoveLoading(isAdd: false,identifier: requestIdentifier)
                        }
                    }
                    task.resume()
                }
            }
            
        }
            
    }

    private func compareIdentifierAndAddRemoveLoading(isAdd:Bool,identifier:String?){
        DispatchQueue.main.async {[weak self] in
            if self?.accessibilityIdentifier == identifier{
                if isAdd{
                    let activityView = UIActivityIndicatorView()
                    activityView.startAnimating()
                    activityView.frame.size.height = 30
                    activityView.frame.size.width = 30
                    activityView.center = self?.center ?? .zero
                    self?.addSubview(activityView)
                }else{
                    for sub in self?.subviews ?? [] {
                        if sub is UIActivityIndicatorView{
                            sub.removeFromSuperview()
                        }
                    }
                }
            }else{
                //id not match
                //            print("id not match",self.accessibilityIdentifier,identifier)
            }
        }

        
    }

    private func compareIdentifierAndSetImage(identifier:String?, image:UIImage){
        if self.accessibilityIdentifier == identifier{
            self.image = image
        }else{
            //id not match
//            print("id not match",self.accessibilityIdentifier,identifier)
        }
    }
    private func checkInTmp(fileName:String)->(Bool,String){
        let tmpDirectoryStr = NSTemporaryDirectory()
        let fileURL = URL(fileURLWithPath: tmpDirectoryStr).appendingPathComponent(fileName)
//        print(NSHomeDirectory())
        return (FileManager.default.fileExists(atPath: fileURL.path),fileURL.path)
    }
    
    private func readImageInTmp(name:String)->UIImage?{
        let tmpDirectoryStr = NSTemporaryDirectory()
        let fileURL = URL(fileURLWithPath: tmpDirectoryStr).appendingPathComponent(name)
        let image = UIImage(contentsOfFile: fileURL.path)
        return image
    }
    
    private func saveImageInTmp(image:UIImage, name:String)->Bool{
        do {
            let tmpDirectoryStr = NSTemporaryDirectory()
            let fileURL = URL(fileURLWithPath: tmpDirectoryStr).appendingPathComponent(name)
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                try imageData.write(to: fileURL)
                return true
            }
        } catch {
            print(error)
        }
        return false
    }
    
    func cutImageTo1_1(oringinalImage:UIImage)->UIImage{
        let maxSize = max(oringinalImage.size.width,oringinalImage.size.height)
        let squareSize = CGSize.init(width: maxSize, height: maxSize)

        let dx = (maxSize - oringinalImage.size.width) / 2.0
        let dy = (maxSize - oringinalImage.size.height) / 2.0
        UIGraphicsBeginImageContext(squareSize)
        var rect = CGRect.init(x: 0, y: 0, width: maxSize, height: maxSize)

        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(rect)

        rect = rect.insetBy(dx: dx, dy: dy)
        oringinalImage.draw(in: rect, blendMode: CGBlendMode.normal, alpha: 1.0)
        let squareImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return squareImage ?? UIImage()
    }
}





// extrac URL link in String
extension String {
    func extractURLs() -> [URL] {
        var urls : [URL] = []
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            detector.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.count), using: { (result, _, _) in
                if let match = result, let url = match.url {
                    urls.append(url)
                }
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return urls
    }
}

//regular expression
extension String {
    func capturedGroups(withRegex pattern: String) -> [String?] {
        var results = [String?]()
        
        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            return results
        }
        
        let matches = regex.matches(in: self, options: [], range: NSRange(location:0, length: self.count))
        
        for i in 0..<matches.count{
            results.append((self as NSString).substring(with: matches[i].range))
        }
        
        return results
    }
    
    func capturedLastMatchedInGroups(withRegex pattern: String) -> String? {
        
        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            return nil
        }
        
        let matches = regex.matches(in: self, options: [], range: NSRange(location:0, length: self.count))
        
        guard let lastMatched = matches.last else { return nil }
        
        return (self as NSString).substring(with: lastMatched.range)
    }
    
}


extension UIView {
    var globalFrame: CGRect? {
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        return self.superview?.convert(self.frame, to: rootView)
    }
}


extension String{
    
    func allStringsBetween(start: String, end: String) -> [Any] {
        var strings = [Any]()
        var startRange: NSRange = (self as NSString).range(of: start)
        
        while true {
            if startRange.location != NSNotFound {
                var targetRange = NSRange()
                targetRange.location = startRange.location + startRange.length
                targetRange.length = self.count - targetRange.location
                let endRange: NSRange = (self as NSString).range(of: end, options: [], range: targetRange)
                if endRange.location != NSNotFound {
                    targetRange.length = endRange.location - targetRange.location
                    strings.append((self as NSString).substring(with: targetRange))
                    var restOfString =  NSRange()
                    restOfString.location = endRange.location + endRange.length
                    restOfString.length = self.count - restOfString.location
                    startRange = (self as NSString).range(of: start, options: [], range: restOfString)
                }
                else {
                    break
                }
            }
            else {
                break
            }
            
        }
        return strings
    }
    
}


extension UIApplication {
    var isKeyboardPresented: Bool {
        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"), self.windows.contains(where: { $0.isKind(of: keyboardWindowClass) }) {
            return true
        } else {
            return false
        }
    }
}
