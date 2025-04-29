//
//  GenreDTO.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import Foundation

/// A Data Transfer Object (DTO) representing a single genre received from the API response.
struct GenreDTO: Decodable {

	/// The unique identifier for the genre.
	let id: Int // Genre ID as returned by the API

	/// The display name of the genre.
	let name: String // Genre name as returned by the API
}

/// A container struct that wraps a list of genres from the API response.
struct GenreResponse: Decodable {

	/// An array of genre data.
	let genres: [GenreDTO] // Decoded list of genres
}
