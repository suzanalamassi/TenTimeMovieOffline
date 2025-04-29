//
//  URL+Cache.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//

import Foundation
import UIKit
import SwiftUI

/// An extension to `URL` that provides functionality for loading cached images.
extension URL {

	/// Attempts to retrieve a cached image for the URL using `URLCache`.
	///
	/// - Returns: A `UIImage` if a valid cached response exists and can be converted, otherwise `nil`.
	func loadCachedImage() -> UIImage? {
		let request = URLRequest(url: self)
		if let cachedResponse = URLCache.shared.cachedResponse(for: request),
		   let image = UIImage(data: cachedResponse.data) {
			return image
		}
		return nil
	}
}
