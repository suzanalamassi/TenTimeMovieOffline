//
//  DownloadManager.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import Foundation
import SwiftData
import SwiftUI

/// A singleton responsible for managing movie download tasks, tracking progress, and handling persistence.
@MainActor
final class DownloadManager: NSObject, ObservableObject, @preconcurrency URLSessionDownloadDelegate {

	// MARK: - Shared Instance

	/// Shared singleton instance of `DownloadManager`.
	static let shared = DownloadManager()

	// MARK: - Initialization

	/// Private initializer to prevent external instantiation.
	private override init() {}

	// MARK: - Private Properties

	/// Queue of movies waiting to be downloaded.
	private var downloadQueue: [Movie] = []

	/// Indicates whether a download is currently in progress.
	private var isDownloading: Bool = false

	/// Currently active download including the movie and its task.
	private var activeDownload: (movie: Movie, task: URLSessionDownloadTask)?

	/// The current download progress (range: 0.0 to 1.0).
	@Published var downloadProgress: Double = 0 // Current progress of active download

	// MARK: - Public Method

	/// Adds a movie to the download queue if it's not already being downloaded.
	///
	/// - Parameter movie: The movie to download.
	func queueDownload(for movie: Movie) { // Movie to be downloaded
		guard movie.downloadStatus == .none else { return }

		movie.downloadStatus = .waiting
		saveMovie(movie)
		downloadQueue.append(movie)

		if !isDownloading {
			startNextDownload()
		}
	}

	// MARK: - Start Next Download

	/// Starts downloading the next movie from the queue.
	private func startNextDownload() {
		guard !downloadQueue.isEmpty else {
			isDownloading = false
			return
		}

		isDownloading = true
		let movie = downloadQueue.removeFirst()
		movie.downloadStatus = .downloading
		saveMovie(movie)

		downloadMovieInternal(from: movie.onlineVideoNSURL, for: movie)
	}

	// MARK: - Start Download Task

	/// Initiates a download task for the specified movie.
	///
	/// - Parameters:
	///   - url: The remote video URL.
	///   - movie: The movie model associated with the download.
	private func downloadMovieInternal(
		from url: URL, // URL to download from
		for movie: Movie // Associated movie
	) {
		let configuration = URLSessionConfiguration.default
		let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)

		let task = session.downloadTask(with: url)
		self.activeDownload = (movie: movie, task: task)
		task.resume()
	}

	/// Timestamp of the last progress update.
	private var lastProgressUpdate: Date = .distantPast

	/// Delegate method called periodically to report download progress.
	func urlSession(
		_ session: URLSession, // Download session
		downloadTask: URLSessionDownloadTask, // Task in progress
		didWriteData bytesWritten: Int64, // Bytes written in the latest chunk
		totalBytesWritten: Int64, // Total bytes written so far
		totalBytesExpectedToWrite: Int64 // Total expected bytes
	) {
		let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
		let now = Date()

		// Update only if more than 0.7 seconds have passed since the last update
		if now.timeIntervalSince(lastProgressUpdate) > 0.7 {
			lastProgressUpdate = now

			Task { @MainActor in
				self.downloadProgress = progress

				if let movie = self.activeDownload?.movie {
					movie.downloadPercentage = ceil(progress * 100)
				}
			}
		}
	}

	/// Delegate method called when the download finishes successfully.
	func urlSession(
		_ session: URLSession, // Download session
		downloadTask: URLSessionDownloadTask, // Finished task
		didFinishDownloadingTo location: URL // Temporary file location
	) {
		guard let movie = activeDownload?.movie else { return }

		do {
			let fileManager = FileManager.default
			let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
			let videosDirectory = documentsDirectory.appendingPathComponent("Videos")

			if !fileManager.fileExists(atPath: videosDirectory.path) {
				try fileManager.createDirectory(at: videosDirectory, withIntermediateDirectories: true)
			}

			let destinationURL = videosDirectory.appendingPathComponent(movie.onlineVideoNSURL.lastPathComponent)

			if fileManager.fileExists(atPath: destinationURL.path) {
				try fileManager.removeItem(at: destinationURL)
			}

			try fileManager.moveItem(at: location, to: destinationURL)

			DispatchQueue.main.async {
				movie.localVideoPath = destinationURL.path
				movie.downloadStatus = .downloaded
				movie.downloadPercentage = 100
				self.saveMovie(movie)
				self.isDownloading = false
				self.downloadProgress = 0
				self.startNextDownload()
			}
		} catch {
			print("❌ Moving downloaded file failed: \(error)")
		}
	}

	// MARK: - Save Movie

	/// Saves the current state of the movie to persistent storage.
	///
	/// - Parameter movie: The movie to save.
	private func saveMovie(_ movie: Movie) { // Movie to persist
		print("movie localfile will save in ==", movie.localVideoPath ?? "")
		do {
			try PersistenceController.shared.container.mainContext.save()
		} catch {
			print("❌ Failed to save movie: \(error.localizedDescription)")
		}
	}
}
