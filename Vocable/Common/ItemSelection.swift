//
//  ItemSelection.swift
//  Vocable AAC
//
//  Created by Patrick Gatewood on 2/25/20.
//  Copyright © 2020 WillowTree. All rights reserved.
//

import Foundation
import Combine
import CoreData

class ItemSelection {
    
    static let categoryValueSubject = CurrentValueSubject<CategoryViewModel, Never>(initialSelectedCategory)
    private static var initialSelectedCategory: CategoryViewModel =
        Category.fetchAll(in: NSPersistentContainer.shared.viewContext,
                          sortDescriptors: [NSSortDescriptor(keyPath: \Category.identifier, ascending: true)])
        .compactMap { CategoryViewModel($0) }.first!
    
    static let phraseValueSubject = CurrentValueSubject<PhraseViewModel?, Never>(nil)
    
//    static let presetsPageIndicatorPublisher = PassthroughSubject<String, Never>()
    
    @PublishedValue
    static var presetsPageIndicatorProgress: CarouselGridPagingProgress = (pageIndex: 0, pageCount: 0)
}

@propertyWrapper struct PublishedValue<T> {

    private let subject: CurrentValueSubject<T, Never>

    var wrappedValue: T {
        didSet {
            subject.send(wrappedValue)
        }
    }

    var projectedValue: AnyPublisher<T, Never> {
        mutating get {
            return subject.eraseToAnyPublisher()
        }
    }

    /// Creates a new `PublishedDefault` for the given `UserDefaults` key and default value
    /// - Parameters:
    ///   - key: The key with which the value should be stored in `UserDefaults`
    ///   - defaultValue: The value that should be provided when no value is stored in `UserDefaults`
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        self.subject = CurrentValueSubject<T, Never>(self.wrappedValue)
    }
}
