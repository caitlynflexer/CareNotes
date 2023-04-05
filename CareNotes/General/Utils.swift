//
//  Utils.swift
//  CareNotes
//
//  Created by Caitlyn Flexer on 2/18/23.
//

import Foundation
import UIKit

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines);
    }
    
    // from https://stackoverflow.com/questions/36861732/convert-string-to-date-in-swift
    func toDate(withFormat format: String = "MM/dd/yyyy HH:mm:ss")-> Date? {

        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(identifier: "America/St_Johns")
//        dateFormatter.locale = Locale(identifier: "fa-IR")
//        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func isDouble() -> Bool {
        if let doubleValue = Double(self) {
            return true
        }
        return false
    }
}

public extension UIDevice {

    class var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    class var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}

// from https://gist.github.com/norsez/aa3f11c0e875526e5270e7791f3891fb

extension JSONSerialization {
    
    static func loadJSON(withFilename filename: String) throws -> Any? {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try Data(contentsOf: fileURL)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves])
            return jsonObject
        }
        return nil
    }
    
    static func save(jsonObject: Any, toFilename filename: String) throws -> Bool{
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            try data.write(to: fileURL, options: [.atomicWrite])
            return true
        }
        
        return false
    }
}


extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        // from https://stackoverflow.com/questions/31966885/resize-uiimage-to-200x200pt-px
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    func scale(amt: CGFloat) -> UIImage {
        return resize(targetSize: CGSize(width: amt * self.size.width, height: amt * self.size.height));
    }
    
    func scaleIPad(amt: CGFloat) -> UIImage {
        return UIDevice.isPad ? self.scale(amt: amt) : self;
    }
}

extension UINavigationItem {
    func scaleText() -> Void {
        if (UIDevice.isPad) {
            // title
            var font = UIFont.systemFont(ofSize: 27)
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                              NSAttributedString.Key.font: font]
            self.standardAppearance = appearance
            
            // left button
            font = UIFont.systemFont(ofSize: 24)
            self.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
                 NSAttributedString.Key.font: font], for: [])
            
            // right button, include disabled state
            self.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
                 NSAttributedString.Key.font: font], for: UIControl.State.normal)
            self.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemGray,
                 NSAttributedString.Key.font: font], for: UIControl.State.disabled)
        }
    }
}
