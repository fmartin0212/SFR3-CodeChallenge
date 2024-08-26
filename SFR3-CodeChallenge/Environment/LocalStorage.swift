//
//  LocalStorage.swift
//  SFR3-CodeChallenge
//
//  Created by Frank Martin on 8/26/24.
//

import CoreData

protocol LocalStorageType {
    var store: PersistenceController { get }
    var context: NSManagedObjectContext { get }
    func save()
    func getObject<T: NSManagedObject>(withType type: T.Type, identifier: Int64) -> T?
    func delete<T: NSManagedObject>(object: T)
}

extension LocalStorageType {
    func getObject<T: NSManagedObject>(withType type: T.Type, identifier: Int64) -> T? {
        let request = NSFetchRequest<T>(entityName: T.entityName)
        request.predicate = NSPredicate(format: "identifier == %lld", identifier as CVarArg)
        
        return try? store.container.viewContext.fetch(request).first
    }
    
    func delete<T: NSManagedObject>(object: T) {
        store.container.viewContext.delete(object)
        save()
    }
    
    func save() {
        try? store.container.viewContext.save()
    }
}

struct LocalStorage: LocalStorageType {
    let store: PersistenceController
    let context: NSManagedObjectContext
    
    init(store: PersistenceController) {
        self.store = store
        self.context = store.container.viewContext
    }
}

extension NSManagedObject {
    static var entityName: String {
        "FavoriteRecipe"
    }
}
