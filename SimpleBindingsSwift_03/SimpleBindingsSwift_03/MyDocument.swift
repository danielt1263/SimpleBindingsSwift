//
//  MyDocument.swift
//  SimpleBindingsSwift_03
//
//  Created by Daniel Tartaglia on 3/14/20.
//  Copyright © 2020 Daniel Tartaglia. MIT License.
//

import Cocoa

class MyDocument: NSDocument {
	
	override class var autosavesInPlace: Bool {
		return true
	}
	
	@objc var track: Track = Track(volume: 5.0, title: "")
	
	override var windowNibName: NSNib.Name? { NSNib.Name("MyDocument") }
	
	override func data(ofType typeName: String) throws -> Data {
		var volume = track.volume
		return Data(buffer: UnsafeBufferPointer(start: &volume, count: 1))
	}
	
	override func read(from data: Data, ofType typeName: String) throws {
		track.volume = data.withUnsafeBytes { $0.load(as: Float.self) }
	}
	
	@IBAction func muteTrack(_ sender: Any) {
		track.volume = 0
	}
}

class Track: NSObject {
	@objc dynamic var volume: Float
	var title: String
	
	init(volume: Float, title: String) {
		self.volume = volume
		self.title = title
	}
}
