//
//  DownloadError.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import Foundation

/// Represents the different error cases that can occur during a file download process.
enum DownloadError: Error, LocalizedError {

	/// Indicates that the temporary file URL provided by the download task is invalid or missing.
	case invalidTemporaryURL

	/// A human-readable description of the error, suitable for user-facing messages.
	var errorDescription: String? {
		switch self {
			case .invalidTemporaryURL:
				return "Failed to download the file. Temporary file is missing."
		}
	}
}
