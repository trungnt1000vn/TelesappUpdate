//
//  ConversationsModel.swift
//  Telesapp
//
//  Created by Trung on 26/04/2023.
//

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    var latestMessage: LatestMessage
}

struct LatestMessage{
    var date: String
    var time: String
    var text: String
    var isRead: Bool
}
