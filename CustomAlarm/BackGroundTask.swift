//
//  BackGroundTask.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/07/12.
//

import BackgroundTasks
import CoreData
import UIKit

private let alarmStartIdentifier: String = "com.CustomAlarm.start"

func getAllData() -> [AlarmData]{
        let persistenceController = PersistenceController.shared
        let context = persistenceController.container.viewContext
        
        let request = NSFetchRequest<AlarmData>(entityName: "AlarmData")
        
        do {
            let items = try context.fetch(request)
            return items
        }
        catch {
            fatalError()
        }
    }

class openURL_Operation: Operation {
    let url = URL(string: "https://youtu.be/ZbbGAq1oB5w?t=131")
    let nowTime = Date()
    let items = getAllData()
    
    
    
//    func saveData(item: AlarmData) {
//        let context = NSManagedObjectContext(concurrencyType:.privateQueueConcurrencyType)
//        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
//        
//        if( UIApplication.shared.canOpenURL(url!) ) {
//          UIApplication.shared.open(url!)
//        }
//    }
}

