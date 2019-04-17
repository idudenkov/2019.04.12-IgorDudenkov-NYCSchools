//
//  NYCSchoolsStorageService.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 16/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import Foundation
import CoreData

protocol NYCSchoolsStorageServiceProtocol {
    func save(schools: [SchoolDto], completion: @escaping () -> Void)
    func getSchools() -> [SchoolDto]
}

final class NYCSchoolsStorageService {

    private static let shared: NSPersistentContainer = {
        let model = NSManagedObjectModel(contentsOf: DBSchool.url)!
        let container = NSPersistentContainer(name: DBSchool.entityName, managedObjectModel: model)

        container.loadPersistentStores() { _, _ in}
        return container
    }()

    private static let writeContext = shared.newBackgroundContext()

    private static func defaultFetchRequest() -> NSFetchRequest<DBSchool> {
        let fetchRequest = NSFetchRequest<DBSchool>(entityName: DBSchool.entityName)
        fetchRequest.sortDescriptors = []
        return fetchRequest
    }


}

extension NYCSchoolsStorageService: NYCSchoolsStorageServiceProtocol {

    func save(schools: [SchoolDto], completion: @escaping () -> Void) {
        let writeContext = NYCSchoolsStorageService.writeContext
        let mainQueueCompletion = { DispatchQueue.main.async(execute: completion) }

        writeContext.perform {
            do {
                let fetchRequest = NYCSchoolsStorageService.defaultFetchRequest()
                let objects = try writeContext.fetch(fetchRequest)

                // We always remove stored objects.
                // Next step to improve the algorithm
                // - compare existence objects by id and update them or insert the new ones
                objects.forEach { writeContext.delete($0) }
                schools.forEach { school in
                    let dbModel = NSEntityDescription.insertNewObject(forEntityName: DBSchool.entityName, into: writeContext) as! DBSchool
                    dbModel.update(dto: school)
                }

                try writeContext.save()
                mainQueueCompletion()
            } catch {
                writeContext.rollback()
                mainQueueCompletion()
            }
        }
    }

    func getSchools() -> [SchoolDto] {
        let viewContext = NYCSchoolsStorageService.shared.viewContext
        let fetchRequest = NYCSchoolsStorageService.defaultFetchRequest()
        return (try? viewContext.fetch(fetchRequest).map { $0.toDto() }) ?? []
    }
}
