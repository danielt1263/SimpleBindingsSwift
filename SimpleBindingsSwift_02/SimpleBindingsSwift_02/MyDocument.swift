//
//  MyDocument.swift
//  SimpleBindingsSwift_02
//
//  Created by Daniel Tartaglia on 3/10/20.
//  Copyright © 2020 Daniel Tartaglia. MIT License.
//

import Cocoa

class MyDocument: NSDocument {
	
	override class var autosavesInPlace: Bool {
		return true
	}
	
	@IBOutlet weak var slider: NSSlider!
	@IBOutlet weak var textField: NSTextField!

	@objc var track: Track = Track(volume: 5.0, title: "")

	override var windowNibName: NSNib.Name? { NSNib.Name("MyDocument") }
	
	override func windowControllerDidLoadNib(_ windowController: NSWindowController) {
		super.windowControllerDidLoadNib(windowController)
		
		let controller = NSObjectController()
		controller.bind(NSBindingName("contentObject"), to: self, withKeyPath: "track", options: nil)
		
		textField.bind(NSBindingName("value"), to: controller, withKeyPath: "selection.volume", options: nil)
		slider.bind(NSBindingName("value"), to: controller, withKeyPath: "selection.volume", options: nil)
	}
	
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
