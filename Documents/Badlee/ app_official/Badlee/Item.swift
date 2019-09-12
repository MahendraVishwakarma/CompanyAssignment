// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let item = try? newJSONDecoder().decode(Item.self, from: jsonData)

import Foundation

// MARK: - ItemElement
struct ItemElement: Codable {
    let id: Int?
    let user, media, title, itemDescription: String?
    let timestamp, location, category, purpose: String?
    let orientation: String?
    let reactionStatus: ReactionStatus?
    let shoutType: String?
    let userInfo: Userinfo?
    let likes: [Has]?
    let have: [Has]?
    let commentsCount: Int?
    let comments: [Comment]?
    let wish: [Has]?
    
    enum CodingKeys: String, CodingKey {
        case id, user, media, title
        case itemDescription = "description"
        case timestamp, location, category, purpose, orientation
        case reactionStatus = "reaction_status"
        case shoutType = "shout_type"
        case userInfo = "user_info"
        case likes, have
        case commentsCount = "comments_count"
        case comments, wish
    }
}

// MARK: - Comment
struct Comment: Codable {
    let commentID: Int?
    let userID, username, content, avatar: String?
    let fname, timestamp: String?
    let menuserlist: [Menuserlist]?
    
    enum CodingKeys: String, CodingKey {
        case commentID = "comment_id"
        case userID = "user_id"
        case username, content, avatar, fname, timestamp, menuserlist
    }
}

// MARK: - Menuserlist
struct Menuserlist: Codable {
    let uname, uid: String?
}

// MARK: - Has
struct Has: Codable {
    let userID, avatar, name, username: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case avatar, name, username
    }
}

// MARK: - ReactionStatus
struct ReactionStatus: Codable {
    let like, wish, have: String?
}

// MARK: - UserInfo
struct Userinfo: Codable {
    let avatar, userID, username, firstName: String?
    let lastName: String?
    
    enum CodingKeys: String, CodingKey {
        case avatar
        case userID = "user_id"
        case username
        case firstName = "First_name"
        case lastName = "Last_name"
    }
}

typealias Item = [ItemElement]


