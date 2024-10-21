//
//  CoreDataStack.swift
//  Image Creator AI
//
//  Created by user246613 on 7/13/24.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {
        print("CoreDataStack initialized")
    }

    // Contexto principal para operaciones en el hilo principal
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    // Contexto de fondo para operaciones en segundo plano
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    // Contenedor persistente configurado con el nombre de tu modelo de datos
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ImageCacheModel") // Reemplaza "ImageCacheModel" con el nombre de tu modelo de datos
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                // Manejo de errores más seguro
                print("Unresolved error \(error), \(error.userInfo)")
                // Aquí podrías añadir más manejo de errores, como reportarlo a un sistema de monitoreo
            } else {
                print("Persistent store loaded: \(storeDescription)")
            }
        }
        return container
    }()
    
    // Método para guardar el contexto con manejo de errores mejorado
    func saveContext(context: NSManagedObjectContext) {
        context.perform {
            if context.hasChanges {
                do {
                    try context.save()
                    print("Context saved successfully")
                } catch {
                    let nserror = error as NSError
                    // Manejo de errores sin detener la aplicación en producción
                    print("Unresolved error \(nserror), \(nserror.userInfo)")
                    // Aquí podrías añadir más manejo de errores, como reportarlo a un sistema de monitoreo
                }
            } else {
                print("No changes in context to save")
            }
        }
    }

    // Método para obtener un nuevo contexto de fondo si es necesario
    func newBackgroundContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
}
