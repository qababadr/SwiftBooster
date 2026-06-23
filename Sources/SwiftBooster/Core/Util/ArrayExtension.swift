//
//  ArrayExtension.swift
//  CoreApp
//
//  Created by BADR  QABA on 2026-02-15.
//

public extension Array {
    func distinctBy<Key: Hashable>(_ keySelector: (Element) -> Key) -> [Element] {
        var seen = Set<Key>()

        return filter { element in
            let key = keySelector(element)

            if seen.contains(key) {
                return false
            } else {
                seen.insert(key)
                return true
            }
        }
    }
}
