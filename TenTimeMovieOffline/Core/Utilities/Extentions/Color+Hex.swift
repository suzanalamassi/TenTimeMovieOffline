//
//  Color+Hex.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 29/04/2025.
//

import Foundation
import SwiftUI

/// Extension on `Color` that adds an initializer to create a color from a hex string.
extension Color {

	/// Initializes a `Color` from a hexadecimal string.
	///
	/// The initializer supports the following hex formats:
	/// - `"#RRGGBB"`
	/// - `"RRGGBBAA"`
	/// - `"GG"` (grayscale)
	/// - `"GGAA"` (grayscale with alpha)
	/// - Invalid strings will default to white color.
	///
	/// - Parameter string: A hex color string that may include optional `#` and alpha values.
	init(
		hex string: String // Hexadecimal color string (e.g., "#FFAA00", "CCC", "12345678")
	) {
		var string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		if string.hasPrefix("#") {
			_ = string.removeFirst()
		}

		// Duplicate last character if hex string is incomplete
		if !string.count.isMultiple(of: 2), let last = string.last {
			string.append(last)
		}

		// Trim excess characters beyond 8
		if string.count > 8 {
			string = String(string.prefix(8))
		}

		// Parse hex string into integer
		let scanner = Scanner(string: string)
		var color: UInt64 = 0
		scanner.scanHexInt64(&color)

		// Handle grayscale (2 digits)
		if string.count == 2 {
			let mask = 0xFF
			let g = Int(color) & mask
			let gray = Double(g) / 255.0
			self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)

			// Handle grayscale with alpha (4 digits)
		} else if string.count == 4 {
			let mask = 0x00FF
			let g = Int(color >> 8) & mask
			let a = Int(color) & mask
			let gray = Double(g) / 255.0
			let alpha = Double(a) / 255.0
			self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)

			// Handle RGB (6 digits)
		} else if string.count == 6 {
			let mask = 0x0000FF
			let r = Int(color >> 16) & mask
			let g = Int(color >> 8) & mask
			let b = Int(color) & mask
			self.init(.sRGB,
					  red: Double(r) / 255.0,
					  green: Double(g) / 255.0,
					  blue: Double(b) / 255.0,
					  opacity: 1)

			// Handle RGBA (8 digits)
		} else if string.count == 8 {
			let mask = 0x000000FF
			let r = Int(color >> 24) & mask
			let g = Int(color >> 16) & mask
			let b = Int(color >> 8) & mask
			let a = Int(color) & mask
			self.init(.sRGB,
					  red: Double(r) / 255.0,
					  green: Double(g) / 255.0,
					  blue: Double(b) / 255.0,
					  opacity: Double(a) / 255.0)

			// Default fallback color
		} else {
			self.init(.sRGB, red: 1, green: 1, blue: 1, opacity: 1)
		}
	}
}
