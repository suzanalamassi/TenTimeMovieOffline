//
//  Genre.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import Foundation
import SwiftData

/// Represents a genre entity stored in the local database.
@Model
final class Genre: Identifiable {

	/// A unique identifier for the genre.
	@Attribute(.unique) var id: Int // Genre ID

	/// The name or label of the genre.
	var name: String // Genre name

	/// The list of movies associated with this genre.
	@Relationship(inverse: \Movie.genres) var movies: [Movie] = [] // Related movies

	/// Initializes a new genre entity.
	///
	/// - Parameters:
	///   - id: The unique identifier of the genre.
	///   - name: The name of the genre.
	init(
		id: Int, // Genre ID
		name: String // Genre name
	) {
		self.id = id
		self.name = name
	}
}
