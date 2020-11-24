//
//  Constants.swift
//  FirebaseLogin
//
//  Created by Tee Becker on 11/23/20.
//

import Foundation
import Firebase

struct messagesBody {
    
    static let msgMetrics = "Metrics"
    static let metricsDetail = "Stuff about Metrics. "
    
    static let msgDashboard = "Dashboard"
    static let dashboardDetail = "Stuff about Dashboard. "
    
    static let msgNotification = "Get Notified"
    static let notificationDetail = "Stuff about getting Notified"
    
    static let successNotification = "Success!"
    static let successnotificationDetail = "We have sent an email to the email address provided, please follow instructions to retrive your password. "
    
}

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("Users")

