//
//  MyDocument.swift
//  SimpleBindingsSwift_04
//
//  Created by Daniel Tartaglia on 3/14/20.
//  Copyright © 2020 Daniel Tartaglia. MIT License.
//

import Cocoa
import RxSwift
import RxCocoa

class MyDocument: NSDocument {

	override class var autosavesInPlace: Bool {
		return true
	}

	@IBOutlet weak var slider: NSSlider!
	@IBOutlet weak var button: NSButton!
	@IBOutlet weak var textField: NSTextField!

	override var windowNibName: NSNib.Name { NSNib.Name("MyDocument") }

	private let trackRead = PublishSubject<Float>()
	private let trackSave = BehaviorRelay(value: Float(0.0))
	private let disposeBag = DisposeBag()
	
	deinit {
		trackRead.onCompleted()
	}
	
	override func windowControllerDidLoadNib(_ windowController: NSWindowController) {
		super.windowControllerDidLoadNib(windowController)

		let state = Observable.merge(
			slider.rx.value.map { Float($0) },
			button.rx.tap.map { Float(0.0) },
			textField.rx.floatValue.asObservable(),
			trackRead,
			Observable.just(Float(5.0))
		)
			.scan(into: Track()) { (current, next) in
				current.volume = next
			}
		
		let volume = state.map { $0.volume }
			.share(replay: 1)
		
		disposeBag.insert(
			volume.map { Double($0) }.bind(to: slider.rx.value),
			volume.bind(to: textField.rx.floatValue),
			volume.bind(to: trackSave)
		)
	}
	
	override func data(ofType typeName: String) throws -> Data {
		var volume = trackSave.value
		return Data(buffer: UnsafeBufferPointer(start: &volume, count: 1))
	}
	
	override func read(from data: Data, ofType typeName: String) throws {
		trackRead.onNext(data.withUnsafeBytes { $0.load(as: Float.self) })
	}
}

struct Track {
	var volume: Float = 0
	var title: String = ""
}

extension Reactive where Base: NSTextField {
	var floatValue: ControlProperty<Float> {
		return controlProperty(
			getter: { field in field.floatValue },
			setter: { field, value in field.floatValue = value}
		)
	}
}
