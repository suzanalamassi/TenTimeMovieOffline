//
//  PersistenceController.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//


import Foundation
import SwiftData

/// A singleton responsible for initializing and managing the SwiftData persistent container.
final class PersistenceController {

	// MARK: - Shared Instance

	/// The shared singleton instance of `PersistenceController`.
	static let shared = PersistenceController()

	// MARK: - Properties

	/// The SwiftData container used to manage the app's model storage.
	let container: ModelContainer

	// MARK: - Initialization

	/// Private initializer that sets up the SwiftData model container.
	/// If initialization fails, the app will terminate with a fatal error.
	private init() {
		do {
			container = try ModelContainer(
				for: Movie.self, // The main movie model
				Genre.self // The genre model
			)
		} catch {
			fatalError("Failed to initialize SwiftData container: \(error)")
		}
	}
}
