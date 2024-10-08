//
//  UserStatus.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.12.23.
//

enum UserStatus: Int, CaseIterable {
    case notConfigured
    case available
    case busy
    case school
    case movies
    case work
    case batteryLow
    case meeting
    case gym
    case sleeping
    case urgentCallsOnly
    
    var title: String {
        switch self {
        case .notConfigured:
            return "Click here to update your status"
        case .available:
            return "Available"
        case .busy:
            return "Busy"
        case .school:
            return "At school"
        case .movies:
            return "At the movies"
        case .work:
            return "At work"
        case .batteryLow:
            return "Battery about to die"
        case .meeting:
            return "In a meeting"
        case .gym:
            return "At the gym"
        case .sleeping:
            return "Sleeping"
        case .urgentCallsOnly:
            return "Urgent Calls Only"
        }
    }
    
    static var statusDisplayList: [UserStatus] {
        self.allCases.filter {
            $0 != .notConfigured
        }
    }
}

