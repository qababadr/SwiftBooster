//
//  MainState.swift
//  SwiftBooster
//
//  Created by BADR  QABA on 2026-06-15.
//
import Foundation
import SwiftBooster

@Data
@Validateable
public struct MainState {
    
    public var isLoading: Bool = false
    public var notificationCount: Int = 0
    public var shouldValidate: Bool = false
    
    @Validate(.required)
    public var firstName: String = ""
    
    @Validate(.email)
    public var email: String = ""
    
    @Validate(.required)
    @Validate(.pattern("^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$"))
    public var password: String = ""
    
    @Validate(.required)
    @Validate(.equalsTo("password"))
    public var confirmPassword: String = ""
    
    @Validate(.length(3, 20))
    var username: String = ""
    
    @Validate(.notBlank)
    var title: String = ""
}
