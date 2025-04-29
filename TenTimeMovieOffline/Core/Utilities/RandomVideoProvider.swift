//
//  RandomVideoProvider.swift
//  TenTimeMovieOffline
//
//  Created by Suzan Amassy on 28/04/2025.
//


import Foundation

/// A static utility that provides random video URLs for testing or demo purposes.
struct RandomVideoProvider {

	/// A predefined list of video URLs.
    private static let videos: [String] = [
		// Long, signed IMDb video URLs (temporary and may expire)
		"https://imdb-video.media-imdb.com/vi3015231513/1434659607842-pgv4ql-1745424821833.mp4?Expires=1745960518&Signature=Q0IsAPgnKYnkP9paWXDEwdtWB3~VtcbTafqSfjHukIil1E5ziAwakLI7x1wzfB2ZrACM-0M3q2wgzB~Xg8poJQ4ukAFBlDtVR37dDfz6ZPQ6k~ccAO7HZ3RHxlYp3VL-bRq4g-16oXmRXjzzNXBRChox3UA1t3JRfCTzRp4kPxiXOYx7dTkHSpb-56DLBC~0762qobrT9aHcOipGot1lGvPkXnggdanb54jVr~5oBQyLyFy~HKdNnGCUX31e9SbohJw-gGdxn9SySCRRiryTh4Rxe~fKFcMxFyF1k8QRBKrm~7sKF936ZuamDprH-1w7ozWf6ccte33aWCUzTibDFw__&Key-Pair-Id=APKAIFLZBVQZ24NQH3KA",
		"https://imdb-video.media-imdb.com/vi2612578329/1434659607842-pgv4ql-1745414714725.mp4?Expires=1745960338&Signature=QRyrVgLdx0puagImS~SutMzfVVELGNbGEj2UIVzHTEmEbuA7tDw04m9AYRLuRnaK5AspfKML~RWi34QrIBnX8DxhmnUu7th05-TK3HsYzplNZ7zI3-wlv3uxXHIb1xx6anMHX73F3cET6qOBVdvTs69SWH0lp~PX~p6YwbgSMtd0DsxqpMAej5S013ngh~K~lSsPLGs49BuYbz6YnQB4rtDzFWkpOc0y~3fR8dv29vImBNpPH1pHz1x2~WREgqbx~gqgDGcpoQqMaejnN1mxK7kr-ITQ4uMfHzj3UlQmP0vU6IzgC6CXa0fPRoaOlP9Lk5JL3oYUkfgQfy9Fg9~uGQ__&Key-Pair-Id=APKAIFLZBVQZ24NQH3KA",
		"https://imdb-video.media-imdb.com/vi968280089/1434659607842-pgv4ql-1745252098869.mp4?Expires=1745960976&Signature=PdirEoJdL4hohHieusdGoYFEk-xitUREr4NibeKSXseC6J1vv7qDfH3OJSFNkNy1YyajLCOu8WggrRIjTmBWlWX6O1iW5kyWJhI3X90H1SGkACmo9iuo3iySI93-GDogDchCZzMhUNoNwx7IZOXM7oFW2TTABOyD2UqAQJT7jddByoYdQkL1xB51U0l0e12pq0xaCaaw2HdJLtcSszbNa2TSKJaaIyzcJXu2NJSlTSS3lAs8-0vLJPDCto0NRMgFZMWd7RwVM6xUf9CdIawRNp~fKPPjbZSbPj6dvEaiiKMxbpQ2FRjTTCNnR~fWRw5Ik1e8PtkMWyihMLA3wfQsPQ__&Key-Pair-Id=APKAIFLZBVQZ24NQH3KA",
		"https://imdb-video.media-imdb.com/vi324468761/1434659607842-pgv4ql-1563712918369.mp4?Expires=1745961017&Signature=mk17F1T7REjjnP7aKc7i777Jz2zD2GMchhfYh5P3INNK7TO-RBGHqeuttjXaZt5-G-OQAmm8KLHWv8aFnUqGRDT~NI~kgz44mThIn4L7pom3bUfpDtCweVI8xaGIcnj3-k4tlNK2qf~6NKKYVkatCKDk0nHTO6NGEJBdowZcKYW8OzWjiBBzxOgBXZjh~FQ8PSeqT0JW1BqoZ7o7TsDl4BOAwrlyZPKvYb-VV4Q3rarOve-6FFxFDoU6e6WMiGeWuebaiHUSnJDeUANFJLAPitnC3PVA-PBhHmgkhZ3oJu6B1~HJhmCpRs~WMu0YsRxPViEPG8LoUU1APEc9G38wTQ__&Key-Pair-Id=APKAIFLZBVQZ24NQH3KA",
		"https://imdb-video.media-imdb.com/vi696162841/1434659607842-pgv4ql-1564159556047.mp4?Expires=1745961048&Signature=qAoNuf6DBuivY5XluC6VzXVh0L4nAUmvnlA-4XTEAaUAn8y4iZpf~tZfPaHXbUm~4JrkmEJ7A6Z6AaYGvffUEGyR42RmnVleRW64m-0ebIxUSCJpOvZ52sHdv3ZOxIvdABCGQn~VSDs8QYwbosigjF2k7g0BGYPEAan1ICM~n6OGHNdc~s2jN88xewRiNsA5XL3X~6cF4MNy0sT06Acs9-SM~h22kbIJvXSKSMQyWye32qUxYayrK-3L9eArmFFbwMAR~FGaRQelH9dZ4682q3-~5CIdDCQs~f6LasjpMQy9xRN58~Lekc9FaRtpgxQv8wqQXiX12e4cf6UWtWprHQ__&Key-Pair-Id=APKAIFLZBVQZ24NQH3KA",
		"https://imdb-video.media-imdb.com/vi2959588889/1434659607842-pgv4ql-1596404706743.mp4?Expires=1745961082&Signature=qz7Nf8inBd8hu0A4Crqc3D89KnfJrrTy1tCiOiTV1IHo2z4A~V07iRebJICWM1NcqV9MxU04m8C80R9vQ64Ivbxfylz7VDoai5mLsscdJVpFB9ogL1eT93hhAEOm-7Tx246S1E7RB~Ex3A3gvVKW7tF5aT4yj2Jr8m-YsWRG23jxu32q1KmKRPm~FAbuu4YPWesvUyPogz8x~zTgMuSxe455xerIhUU8AZHIMibW1UQOJW2EpusF4Ter7oCRxPVmHxB8EqEjd774PtzWW8q4gjSXXu4NWE9-c4TuZ98~4~ex4bRtTlJ3SKZxGT2D413KefYTlS3-h0kTiM~PV1Cj1Q__&Key-Pair-Id=APKAIFLZBVQZ24NQH3KA"

	]


	/// Returns a randomly selected video URL from the predefined list.
	///
	/// - Returns: A valid `URL` pointing to a video resource. If selection or parsing fails, a fallback video URL is returned.
	static func randomVideoURL() -> URL {
		if let randomString = videos.randomElement(),
		   let url = URL(string: randomString) {
			return url
		}

		// Fallback: Big Buck Bunny sample video
		return URL(string: "https://commondatastorage.googleapis.com/gtv-Movies-bucket/sample/BigBuckBunny.mp4")!
	}
}
