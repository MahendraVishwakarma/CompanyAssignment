

import UIKit
import FMDB

class DBManager: NSObject
{
    
    // table name
    
    let User_Db_Table = "letsFuck"
    
    // fields for message table
    
    let field_message_id = "message_id"
    let field_message = "message"
    let field_sChatId = "sChatId"
    let field_rChatId = "rChatId"
    let field_msgType = "msgType"
    let field_imgUrl = "imgUrl"
    let field_postId = "postId"
    let field_timestamp = "timestamp"
    let field_pUserId = "pUserId"
    let field_reference = "reference"
    let field_sName = "sName"
    let field_sProfile_url = "sProfile_url"
    let field_rName = "rName"
    let field_rProfile_url = "rProfile_url"
    let field_status = "status"
    let field_hostID = "hostID"
    let field_clientID = "clientID"
    
    
    static let shared: DBManager = DBManager()
    
    let databaseFileName = "badleeChat.db"
    
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    
    
    
    func createDatabase() -> Bool {
        var created = false
         print(pathToDatabase)
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
           
            
            if database != nil {
                
                if database.open()
                {
                    
                    let createBadleeTableQuery = "create table chatting (\(field_message_id) text not null, \(field_message) text not null, \(field_sChatId) text not null, \(field_rChatId) text not null, \(field_msgType) text not null, \(field_imgUrl) text not null, \(field_postId) integer not null, \(field_timestamp) integer not null, \(field_pUserId) text not null, \(field_reference) text not null, \(field_rName) text not null, \(field_rProfile_url) text not null, \(field_sName) text not null, \(field_sProfile_url) text not null, \(field_status) text not null, \(field_hostID) text not null, \(field_clientID) text not null)"
                    
                    print(createBadleeTableQuery)
                    
                    do {
                        try database.executeUpdate(createBadleeTableQuery, values: nil)
                        created = true
                        print("created Msg Table")
                    }
                    catch {
                        print("Could not create Msg table.")
                        print(error.localizedDescription)
                    }
                    
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return created
    }
    
    
    func openDatabase() -> Bool
    {
        if database == nil
        {
            if FileManager.default.fileExists(atPath: pathToDatabase)
            {
                database = FMDatabase(path: pathToDatabase)
                print(pathToDatabase)
            }
        
        }
        
        print(pathToDatabase)
        
        if database != nil
        {
            if database.open()
            {
                return true
            }
        }
        
        return false
    }
    
    

    func insertData(_message_id : String, _message : String, _rChatId : String,_rName : String ,_rProfile_url : String, _timestamp : Int64, _image_url : String, _status : String, _message_type : String,_sName:String,_sChatId:String, _sProfile_url : String,_postId:String,_pUserId:String,_reference:String)
    {
      
        
        if openDatabase()
        {
            
            do {
                
                let messageId = _message_id
                let message = _message
                let rChatId = _rChatId
                let rName = _rName
                let rProfile_url = _rProfile_url
                let sChatId = _sChatId
                let sName = _sName
                let sProfile_url = _sProfile_url
                let timestamp = _timestamp
                let image_url = _image_url
                let status = _status
                let msg_type = _message_type
                let post_id = _postId
                let pUserId = _pUserId
                let reference = _reference
                let hostID = appDel.loginUserInfo.user_id!
                
                var clientID = ""
                
                if(hostID == rChatId)
                {
                    clientID = sChatId
                }
                else
                {
                    clientID = rChatId
                }
            
                
                let query = "insert into chatting (\(field_message_id), \(field_message), \(field_sChatId), \(field_rChatId), \(field_msgType), \(field_imgUrl), \(field_postId), \(field_timestamp), \(field_pUserId),\(field_reference) ,\(field_rName),\(field_rProfile_url),\(field_sName),\(field_sProfile_url),\(field_status),\(field_hostID),\(field_clientID)) values ('\(messageId)', '\(message)', '\(sChatId)', '\(rChatId)', '\(msg_type)', '\(image_url)', '\(post_id)', '\(timestamp)', '\(pUserId)', '\(reference)','\(rName)', '\(rProfile_url)','\(sName)','\(sProfile_url)','\(status)','\(hostID)','\(clientID)');"
                
                if !database.executeStatements(query) {
                    
                    print(database.lastError(), database.lastErrorMessage())
                }
                else
                {
                    print("chat data inserted successfully")
                }
                
                
            }
//            catch {
//                print(error.localizedDescription)
//            }
            
            
            database.close()
        }
        
        
    }
    
    func isMessageAlreadyPresent(messageID:String) -> Bool{
       
         var isFound = false
        if openDatabase()
        {
            let query = "select message_id from chatting  WHERE \(field_message_id) = '\(messageID)'"
            
            do
            {
                
                print(database)
                let results = try database.executeQuery(query, values: nil)
                
                print(results.columnCount)
                
                while results.next()
                {
                   isFound = true
                    break
                }
               
                
            }
            catch {
                
                isFound = false
            }
            
            database.close()
        }
        
        return isFound
    }
    func AllChat_read(loginID : String, userID:String) -> NSArray {
        let chat = NSMutableArray()
        
        if openDatabase()
        {
            let status = "1"
        let query = "select * from chatting  WHERE \(field_status) = '\(status)' AND \(field_hostID) = '\(loginID)' AND \(field_clientID) = '\(userID)' order by \(field_postId) desc"
            
            do
            {
                
                print(database)
                let results = try database.executeQuery(query, values: nil)
                
                print(results.columnCount)
                print(results)
            
                print(results.accessibilityElementCount())
                
                while results.next()
                {
                    
                    let dicChate = NSMutableDictionary()
                    
            
                    dicChate.setValue(results.int(forColumn: field_message_id), forKey: "message_id")
                    
                    dicChate.setValue(results.string(forColumn: field_message), forKey: "message")
                    dicChate.setValue(results.string(forColumn: field_sChatId), forKey: "sChatId")
                    dicChate.setValue(results.string(forColumn: field_rChatId), forKey: "rChatId")
                    dicChate.setValue(results.string(forColumn: field_msgType), forKey: "msgType")
                    
                    dicChate.setValue(results.string(forColumn: field_imgUrl), forKey: "imgUrl")
                    dicChate.setValue(results.longLongInt(forColumn: field_timestamp), forKey: "timestamp")
                    dicChate.setValue(results.string(forColumn: field_postId), forKey: "postId")
                    dicChate.setValue(results.string(forColumn: field_pUserId), forKey: "pUserId")
                    
                    dicChate.setValue(results.string(forColumn: field_reference), forKey: "reference")
                    dicChate.setValue(results.string(forColumn: field_sName), forKey: "sName")
                    
                    dicChate.setValue(results.string(forColumn: field_sProfile_url), forKey: "sProfile_url")
                    dicChate.setValue(results.string(forColumn: field_rName), forKey: "rName")
                    dicChate.setValue(results.string(forColumn: field_rProfile_url), forKey: "rProfile_url")
                    dicChate.setValue(results.string(forColumn: field_status), forKey: "status")
                    
                    let day = comman.dayDifference(from:TimeInterval(results.longLongInt(forColumn: field_timestamp)) )
                    
                    dicChate.setValue(day, forKey: "day")
                    
                    chat.add(dicChate)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return chat
    }
    
    
    func AllChat_unread(loginID : String, userID:String) -> NSArray {
        let chat = NSMutableArray()
        
        if openDatabase()
        {
            let status = "0"
            let query = "select * from chatting  WHERE \(field_status) = '\(status)' AND \(field_hostID) = '\(loginID)' AND \(field_clientID) = '\(userID)' order by \(field_postId) desc"
            
            do {
                print(database)
                let results = try database.executeQuery(query, values: nil)
                
                print(results.columnCount)
                print(results)
                
                print(results.accessibilityElementCount())
                
                while results.next()
                {
                    
                    let dicChate = NSMutableDictionary()
                    
                    
                    dicChate.setValue(results.int(forColumn: field_message_id), forKey: "message_id")
                    
                    dicChate.setValue(results.string(forColumn: field_message), forKey: "message")
                    dicChate.setValue(results.string(forColumn: field_sChatId), forKey: "sChatId")
                    dicChate.setValue(results.string(forColumn: field_rChatId), forKey: "rChatId")
                    dicChate.setValue(results.string(forColumn: field_msgType), forKey: "msgType")
                    
                    dicChate.setValue(results.string(forColumn: field_imgUrl), forKey: "imgUrl")
                    dicChate.setValue(results.longLongInt(forColumn: field_timestamp), forKey: "timestamp")
                    dicChate.setValue(results.string(forColumn: field_postId), forKey: "postId")
                    dicChate.setValue(results.string(forColumn: field_pUserId), forKey: "pUserId")
                    
                    dicChate.setValue(results.string(forColumn: field_reference), forKey: "reference")
                    dicChate.setValue(results.string(forColumn: field_sName), forKey: "sName")
                    
                    dicChate.setValue(results.string(forColumn: field_sProfile_url), forKey: "sProfile_url")
                    dicChate.setValue(results.string(forColumn: field_rName), forKey: "rName")
                    dicChate.setValue(results.string(forColumn: field_rProfile_url), forKey: "rProfile_url")
                    dicChate.setValue(results.string(forColumn: field_status), forKey: "status")
                    
                    
                    chat.add(dicChate)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return chat
    }
    
    
    
 
    func update_message_status(userID: String , loginID: String) {
        if openDatabase() {
            let status = "0"
            let query = "update chatting set \(field_status) = ? WHERE \(field_status) = '\(status)' AND \(field_clientID) = '\(userID)' AND \(field_hostID) = '\(loginID)'"
            
            do {
                try database.executeUpdate(query, values: ["1"])
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
    }
    
    
    func getTotalUnreadMessage(loginID: String) -> NSArray
    {
        let chat = NSMutableArray()
        
        if openDatabase()
        {
            let status = "0"
            
            let query = "select * from chatting  WHERE \(field_status) = '\(status)' AND \(field_hostID) = '\(loginID)'"
            
            do {
                print(database)
                let results = try database.executeQuery(query, values: nil)
                
                print(results.columnCount)
                print(results)
                
                print(results.accessibilityElementCount())
                
                while results.next()
                {
                    
                    let dicChate = NSMutableDictionary()
                    dicChate.setValue(results.int(forColumn: field_message_id), forKey: "message_id")
                    
                    dicChate.setValue(results.string(forColumn: field_message), forKey: "message")
                    dicChate.setValue(results.string(forColumn: field_sChatId), forKey: "sChatId")
                    dicChate.setValue(results.string(forColumn: field_rChatId), forKey: "rChatId")
                    dicChate.setValue(results.string(forColumn: field_msgType), forKey: "msgType")
                    
                    dicChate.setValue(results.string(forColumn: field_imgUrl), forKey: "imgUrl")
                    dicChate.setValue(results.longLongInt(forColumn: field_timestamp), forKey: "timestamp")
                    dicChate.setValue(results.string(forColumn: field_postId), forKey: "postId")
                    dicChate.setValue(results.string(forColumn: field_pUserId), forKey: "pUserId")
                    
                    dicChate.setValue(results.string(forColumn: field_reference), forKey: "reference")
                    dicChate.setValue(results.string(forColumn: field_sName), forKey: "sName")
                    
                    dicChate.setValue(results.string(forColumn: field_sProfile_url), forKey: "sProfile_url")
                    dicChate.setValue(results.string(forColumn: field_rName), forKey: "rName")
                    dicChate.setValue(results.string(forColumn: field_rProfile_url), forKey: "rProfile_url")
                    dicChate.setValue(results.string(forColumn: field_status), forKey: "status")
                    
                    
                   
                    chat.add(dicChate)
                    
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return chat

        
    }
   
    
    func updateTbl(withID ID: Int, name: String, std: String)
    {
        if openDatabase() {
            let query = "update chatting set name=?, std=? where my_id=?"
            
            do {
                try database.executeUpdate(query, values: [name, std, ID])
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
    }
    
    func getUserList(loginID:String) -> NSArray
    {
        let chat = NSMutableArray()
        
        if openDatabase()
        {
            let status1 = "0"
            let status2 = "1"
            let query = "select * from chatting  WHERE \(field_status) = '\(status2)' OR \(field_status) = '\(status1)' AND \(field_hostID) = '\(loginID)' group by \(field_clientID)"
            
            do {
                print(database)
                let results = try database.executeQuery(query, values: nil)
                
                print(results.columnCount)
                print(results)
                
                print(results.accessibilityElementCount())
                
                while results.next()
                {
                    
                    let dicChate = NSMutableDictionary()
                   
                    
                    dicChate.setValue(results.int(forColumn: field_message_id), forKey: "message_id")
                    
                    dicChate.setValue(results.string(forColumn: field_message), forKey: "message")
                    dicChate.setValue(results.string(forColumn: field_sChatId), forKey: "sChatId")
                    dicChate.setValue(results.string(forColumn: field_rChatId), forKey: "rChatId")
                    dicChate.setValue(results.string(forColumn: field_msgType), forKey: "msgType")
                    dicChate.setValue(results.longLongInt(forColumn: field_timestamp), forKey: "timestamp")
                    chat.add(dicChate)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return chat
        
    }
    
    func getDataFromServer(data:NSDictionary)
    {
        
    }
    
    //to clear chat
    func clearChat(userID:String){
        
//        if openDatabase()
//        {
//
//             let query = "delete from chatting  WHERE \(field_clientID) = '\(userID)' AND \(field_hostID) = '\(appDel.loginUserInfo.user_id!)'"
//
//
//                do {
//                    try database.executeUpdate(query, values: nil)
//                }
//                catch {
//                    print(error.localizedDescription)
//                }
//
//            database.close()
//        }
        
        if openDatabase() {
            let status = "1"
            let query = "update chatting set \(field_status) = ? WHERE \(field_status) = '\(status)' AND \(field_clientID) = '\(userID)' AND \(field_hostID) = '\(appDel.loginUserInfo.user_id!)'"
            
            do {
                try database.executeUpdate(query, values: ["2"])
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
    }
    

}
