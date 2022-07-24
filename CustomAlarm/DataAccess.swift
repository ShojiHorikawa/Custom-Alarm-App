//
//  DataAccess.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/06/27.
//
// dayOfWeekとtagColor用の列挙体

import Foundation
import SwiftUI

struct DataAccess {
    
    
    // 繰り返しの曜日
    enum DayOfWeek: String,CaseIterable{
        case sunday = "毎週日曜日"
        case monday = "毎週月曜日"
        case tuesday = "毎週火曜日"
        case wednesday = "毎週水曜日"
        case thursday = "毎週木曜日"
        case friday = "毎週金曜日"
        case saturday = "毎週土曜日"
    }
    
    // 識別タグ
    enum TagColor: String,Hashable,CaseIterable{
        case white = "白色"
        case red = "赤色"
        case blue = "青色"
        case yellow = "黄色"
        case clear = "クリア"
    }
}

// ForEach用の列挙体を全て格納した配列
let weekArray: [DataAccess.DayOfWeek] = DataAccess.DayOfWeek.allCases

// ForEach用の列挙体を全て格納した配列
let colorArray: [DataAccess.TagColor] = DataAccess.TagColor.allCases

