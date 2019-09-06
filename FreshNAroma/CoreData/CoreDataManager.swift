//
//  CoreDataManager.swift
//  PersonData
//
//  Created by Kavitha Jagannathan on 26/10/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    static let sharedManager = CoreDataManager()
    private init() {}
    lazy var presistentContainer: NSPersistentContainer = {
        let continer = NSPersistentContainer(name: CoreDataManager.strBasketEntity)
        continer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as Error? {
                fatalError("Unresolved error \(error), \(String(describing: error._userInfo))")
            }
        })
        return continer
    }()
    
    func saveContext () {
      
        let context = CoreDataManager.sharedManager.presistentContainer.viewContext
    if context.hasChanges {
    do {
    try context.save()
    } catch {
    // Replace this implementation with code to handle the error appropriately.
    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    let nserror = error as NSError
    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
    }
}
    func insertItem(title: String, id : Int16,itemdescription : String,price: Float,qty: Int16) -> BasketItem? {
        
        let managedContext = CoreDataManager.sharedManager.presistentContainer.viewContext
       let entity = NSEntityDescription.entity(forEntityName: CoreDataManager.strBasketEntity, in: managedContext)!
        let item = NSManagedObject(entity: entity, insertInto: managedContext)
        item.setValue(title, forKey: "title")
        item.setValue(id, forKey: "id")
        item.setValue(price, forKey: "price")
        item.setValue(qty, forKey: "qty")
        item.setValue(itemdescription, forKey: "itemdescription")
        
        do {
            try managedContext.save()
            
            return item as? BasketItem
            
        } catch let error  {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func update(name:String, ssn : Int16, person : BasketItem) {
        
        let managedContext = CoreDataManager.sharedManager.presistentContainer.viewContext
        
        person.setValue(name, forKey: "name")
        person.setValue(ssn, forKey: "ssn")
        do {
            try managedContext.save()
            
        }catch let error{
            print("Could not save \(error), \(String(describing: error._userInfo))")
        }
        
    }
    
    func delete(person : BasketItem){
        
        let context = CoreDataManager.sharedManager.presistentContainer.viewContext
        
        context.delete(person)
        do {
            try context.save()
        }catch _ {
            
        }
    }
    
    func fetchAllPersons() -> [BasketItem]?{
        
        let context = CoreDataManager.sharedManager.presistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataManager.strBasketEntity)
        do{
         let people = try context.fetch(fetchRequest)
            return people as? [BasketItem]
        }catch let error{
            print("\(error.localizedDescription)")
            return nil
        }
    }
    
    func delete(ssn: String) -> [BasketItem]? {
        /*get reference to appdelegate file*/
        
        
        /*get reference of managed object context*/
        let managedContext = CoreDataManager.sharedManager.presistentContainer.viewContext
        
        /*init fetch request*/
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataManager.strBasketEntity )
        
        /*pass your condition with NSPredicate. We only want to delete those records which match our condition*/
        fetchRequest.predicate = NSPredicate(format: "ssn == %@" ,ssn)
        do {
            
            /*managedContext.fetch(fetchRequest) will return array of person objects [personObjects]*/
            let item = try managedContext.fetch(fetchRequest)
            var arrRemovedPeople = [BasketItem]()
            for i in item {
                
                /*call delete method(aManagedObjectInstance)*/
                /*here i is managed object instance*/
                managedContext.delete(i)
                
                /*finally save the contexts*/
                try managedContext.save()
                
                /*update your array also*/
                arrRemovedPeople.append(i as! BasketItem)
            }
            return arrRemovedPeople
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        
    }
}

extension CoreDataManager {
    static let strBasketEntity = "BasketItem"
}
