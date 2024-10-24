//
//  ChannelsService.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 22.10.24.
//

import Foundation
import FirebaseFirestore

class ChannelsService: ObservableObject {
    @Published private(set) var channels: [Channel] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isLoadingMore = false
    
    var currentUser: User?
    
    private var firstDocument: DocumentSnapshot?
    private var hasMoreChannels = true
    private let pageSize = 14
    private var listener: ListenerRegistration?
    
    private var collectionRef: CollectionReference {
        FirestoreConstants.ChannelsCollection
    }
    
    init(currentUser: User? = nil) {
        self.currentUser = currentUser
    }
    
    func fetchChannels(isInitialFetch: Bool = true) {
        guard !isLoading,
              let currentUserId = currentUser?.id else { return }
        
        // If not initial fetch, check if we have more channels to load
        if !isInitialFetch && !hasMoreChannels {
            return
        }
        
        isLoading = true
        
        // Reset state for initial fetch
        if isInitialFetch {
            firstDocument = nil
            hasMoreChannels = true
            listener?.remove()
            channels.removeAll()
            
            // For initial fetch, only setup listener for latest messages
            let query = collectionRef
                .whereField("uids", arrayContains: currentUserId)
                .order(by: "updatedAt", descending: true) // Get newest first
                .limit(to: pageSize)
            
            setupListener(for: query)
        } else {
            isLoadingMore = true
            
            // For pagination, get messages older than the oldest we currently have
            let query = collectionRef
                .whereField("uids", arrayContains: currentUserId)
                .order(by: "updatedAt", descending: true)
                .limit(to: pageSize)
            
            if let firstDoc = firstDocument {
                query.start(afterDocument: firstDoc)
                    .getDocuments { [weak self] querySnapshot, error in
                        guard let self = self else { return }
                        self.handlePaginatedResults(querySnapshot, error)
                    }
            }
        }
    }
    
    private func setupListener(for query: Query) {
        listener = query.addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }
            
            guard let snapshot = querySnapshot else {
                print("Error in real-time updates: \(error?.localizedDescription ?? "Unknown error")")
                self.isLoading = false
                return
            }
            
            let newChannels = snapshot.documents.compactMap { document -> Channel? in
                try? document.data(as: Channel.self)
            }
            
            // Update first document for pagination
            self.firstDocument = snapshot.documents.last
            self.hasMoreChannels = snapshot.documents.count == self.pageSize
            
            if self.channels.isEmpty {
                // Initial load - reverse to show oldest at top
                self.channels = newChannels.reversed()
            } else {
                // Real-time updates - add new channels at the bottom
                let existingIds = Set(self.channels.map { $0.id })
                let newFilteredChannels = newChannels
                    .filter { !existingIds.contains($0.id) }
                    .reversed()
                
                self.channels.append(contentsOf: newFilteredChannels)
            }
            print("DEBUG: Listener set for \(channels.count) channels")
            self.isLoading = false
        }
    }
    
    private func handlePaginatedResults(_ querySnapshot: QuerySnapshot?, _ error: Error?) {
        guard let snapshot = querySnapshot else {
            print("Error fetching channels: \(error?.localizedDescription ?? "Unknown error")")
            self.isLoading = false
            self.isLoadingMore = false
            return
        }
        
        let olderChannels = snapshot.documents.compactMap { document -> Channel? in
            try? document.data(as: Channel.self)
        }
        
        // Update pagination state
        self.firstDocument = snapshot.documents.last
        self.hasMoreChannels = snapshot.documents.count == self.pageSize
        
        // Add older channels at the top in reverse order
        let existingIds = Set(self.channels.map { $0.id })
        let newFilteredChannels = olderChannels
            .filter { !existingIds.contains($0.id) }
            .reversed()
        
        self.channels.insert(contentsOf: newFilteredChannels, at: 0)
        print("DEBUG: Pagination fetched \(channels.count) channels")
        self.isLoading = false
        self.isLoadingMore = false
    }
    
    func cleanup() {
        listener?.remove()
        listener = nil
        firstDocument = nil
        hasMoreChannels = true
        isLoading = false
        channels.removeAll()
    }
}
