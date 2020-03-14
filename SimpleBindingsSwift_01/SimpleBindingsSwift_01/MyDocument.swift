//
//  MyDocument.swift
//  SimpleBindingsSwift_01
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

	override var windowNibName: NSNib.Name { NSNib.Name("MyDocument") }

	private var track: Track = Track(volume: 5.0, title: "")

	override func windowControllerDidLoadNib(_ windowController: NSWindowController) {
		super.windowControllerDidLoadNib(windowController)
		updateUserInterface()
	}
	
	override func data(ofType typeName: String) throws -> Data {
		var volume = track.volume
		return Data(buffer: UnsafeBufferPointer(start: &volume, count: 1))
	}
	
	override func read(from data: Data, ofType typeName: String) throws {
		track.volume = data.withUnsafeBytes { $0.load(as: Float.self) }
	}
	
	@IBAction func updateVolumeFrom(_ sender: HasFloatValue) {
		let newVolume = sender.floatValue
		track.volume = newVolume
		updateUserInterface()
	}
	
	@IBAction func muteTrack(_ sender: Any) {
		track.volume = 0
		updateUserInterface()
	}
	
	private func updateUserInterface() {
		slider.floatValue = track.volume
		textField.floatValue = track.volume
	}
	
}

struct Track {
	var volume: Float
	var title: String
}

@objc
protocol HasFloatValue: AnyObject {
	var floatValue: Float { get set }
}

extension NSSlider: HasFloatValue { }
extension NSTextField: HasFloatValue { }
