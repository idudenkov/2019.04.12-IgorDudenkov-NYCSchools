//
//  NYCSchoolsSatStorageService.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 17/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import Foundation
import CoreData

protocol NYCSchoolsSatStorageServiceProtocol {
    func save(sat: SatDto, completion: @escaping () -> Void)
    func getSat(forSchool identifer: String) -> SatDto?
}

final class NYCSchoolsSatStorageService {

    private static let shared: NSPersistentContainer = {
        let model = NSManagedObjectModel(contentsOf: DBSat.url)!
        let container = NSPersistentContainer(name: DBSat.entityName, managedObjectModel: model)

        container.loadPersistentStores() { _, _ in}
        return container
    }()

    private static let writeContext = shared.newBackgroundContext()

    private static func defaultFetchRequest(identifer: String) -> NSFetchRequest<DBSat> {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(DBSat.identifer), identifer)
        let fetchRequest = NSFetchRequest<DBSat>(entityName: DBSat.entityName)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = []
        return fetchRequest
    }

}

extension NYCSchoolsSatStorageService: NYCSchoolsSatStorageServiceProtocol {

    func save(sat: SatDto, completion: @escaping () -> Void) {
        let writeContext = NYCSchoolsSatStorageService.writeContext
        let mainQueueCompletion = { DispatchQueue.main.async(execute: completion) }

        writeContext.perform {
            do {
                let objects = try writeContext.fetch(NYCSchoolsSatStorageService.defaultFetchRequest(identifer: sat.identifer))
                let dbModel = objects.first ?? NSEntityDescription.insertNewObject(forEntityName: DBSat.entityName, into: writeContext)
                (dbModel as! DBSat).update(dto: sat)

                try writeContext.save()
                mainQueueCompletion()
            } catch {
                writeContext.rollback()
                mainQueueCompletion()
            }
        }
    }

    func getSat(forSchool identifer: String) -> SatDto? {
        let viewContext = NYCSchoolsSatStorageService.shared.viewContext
        let fetchRequest = NYCSchoolsSatStorageService.defaultFetchRequest(identifer: identifer)
        return (try? viewContext.fetch(fetchRequest).first?.toDto())
    }
}
