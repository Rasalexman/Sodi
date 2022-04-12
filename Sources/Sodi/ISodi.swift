//
//  File.swift
//  
//
//  Created by Alexander on 12.04.2022.
//

#if SWIFT_PACKAGE
import Foundation
#endif

protocol ISodi {
        
}

extension ISodi {
    
    func bindSingle<T>(to: Any? = nil, creater: @escaping LambdaWithReturn<T>) {
        let tagWrapper = createTagWrapper(toTag: to, name: "\(T.self)")
        let holder = SodiSingle(tagWrapper: tagWrapper, creator: creater)
        Sodi.insertHolder(tagWrapper: tagWrapper, sodiHolder: holder)
    }

    func bindProvider<T>(to: Any? = nil, creater: @escaping LambdaWithReturn<T>) {
        let tagWrapper = createTagWrapper(toTag: to, name: "\(T.self)")
        let holder = SodiProvider(tagWrapper: tagWrapper, creator: creater)
        Sodi.insertHolder(tagWrapper: tagWrapper, sodiHolder: holder)
    }

    func unbind<T: Any>(from: Any? = nil) -> T? {
        let tagWrapper = createTagWrapper(toTag: from, name: "\(T.self)")
        var holder = Sodi.deleteHolder(tagWrapper: tagWrapper)
        return holder.getInstance() as? T ?? nil
    }

    func hasInstance(from: Any) -> Bool {
        let tagWrapper = createTagWrapper(toTag: from, name: "\(from.self)")
        return Sodi.hasInstance(tagWrapper: tagWrapper)
    }

    func instance<T: Any>(from: Any? = nil) -> T {
        let tagWrapper = createTagWrapper(toTag: from, name: "\(T.self)")
        var holder = Sodi.selectHolder(tagWrapper: tagWrapper)
        return try! holder.getHolderValue()
    }

    private func createTagWrapper(toTag: Any? = nil, name: String) -> SodiTagWrapper {
        var tagName: String = name
        if let obj = toTag {
            tagName = "\(obj.self)"
        }
        return SodiTagWrapper(tagName: tagName)
    }
}
