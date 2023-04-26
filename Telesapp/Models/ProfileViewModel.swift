//
//  ProfileViewModel.swift
//  Telesapp
//
//  Created by Trung on 26/04/2023.
//


enum ProfileViewModelType{
    case info, email, logout
}
struct ProfileViewModel {
    let viewModelType:ProfileViewModelType
    let title:String
    let handler: (() -> Void)?
}
