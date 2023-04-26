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
    let latestMessage: LatestMessage
}

struct LatestMessage{
    let date: String
    let text: String
    let isRead: Bool
}
