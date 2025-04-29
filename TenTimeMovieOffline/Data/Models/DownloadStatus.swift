//
//  DownloadStatus.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import Foundation

/// Represents the current download state of a media item.
enum DownloadStatus: String, Codable {

	/// No download has been initiated.
	case none         // Not started

	/// The item is queued for download.
	case waiting      // Waiting in queue

	/// The item is currently being downloaded.
	case downloading  // Actively downloading

	/// The download has completed successfully.
	case downloaded   // Download completed
}

extension DownloadStatus {

	/// A system icon name that visually represents the current download state.
	var iconName: String {
		switch self {
			case .none:
				return "square.and.arrow.down"
			case .waiting:
				return "clock"
			case .downloading:
				return "arrow.down.circle.fill"
			case .downloaded:
				return "checkmark.circle.fill"
		}
	}

	/// A short, user-facing text description of the download status.
	var textDescription: String {
		switch self {
			case .none:
				return "Download"
			case .waiting:
				return "Waiting..."
			case .downloading:
				return "Downloading..."
			case .downloaded:
				return "Downloaded"
		}
	}
}
