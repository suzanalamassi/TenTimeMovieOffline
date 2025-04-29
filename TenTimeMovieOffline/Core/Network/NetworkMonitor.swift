//
//  NetworkMonitor.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import Foundation
import Network
import SwiftUI

/// A singleton class that monitors network connectivity status using `NWPathMonitor`.
@MainActor
final class NetworkMonitor: ObservableObject {

	// MARK: - Shared Instance

	/// Shared singleton instance of `NetworkMonitor`.
	static let shared = NetworkMonitor()

	// MARK: - Published Properties

	/// Indicates whether the device is currently connected to the internet.
	@Published private(set) var isConnected: Bool = true

	// MARK: - Private Properties

	/// System-level network path monitor.
	private let monitor = NWPathMonitor()

	/// Background queue on which the network monitor runs.
	private let queue = DispatchQueue(label: "NetworkMonitorQueue")

	/// The last known network status.
	private var previousStatus: NWPath.Status?

	// MARK: - Initialization

	/// Private initializer to set up and start monitoring the network path.
	private init() {
		monitor.pathUpdateHandler = { [weak self] path in
			Task { @MainActor in
				self?.handlePathUpdate(path) // Handles the network status change
			}
		}
		monitor.start(queue: queue)
	}

	// MARK: - Private Methods

	/// Handles updates to the network path status and updates the connectivity state.
	///
	/// - Parameter path: The updated network path object containing the current status.
	private func handlePathUpdate(
		_ path: NWPath // The latest network path status
	) {
		let currentStatus = path.status
		isConnected = (currentStatus == .satisfied)
		previousStatus = currentStatus
	}

	// MARK: - Deinitialization

	/// Stops the network monitor when the object is deallocated.
	deinit {
		monitor.cancel()
	}
}
