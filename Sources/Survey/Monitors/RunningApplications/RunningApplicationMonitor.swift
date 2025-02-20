//
//  RunningApplicationMonitor.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

#if os(macOS)
import Foundation
import Cocoa


@MainActor class RunningApplicationMonitor: NSObject {
	static let instance = RunningApplicationMonitor()
	
	var initialState: RunningApplicationState!
	var lastState: RunningApplicationState!
	weak var delegate: RecordedEventDelegate!
	
	// NSWorkspace.shared.frontmostApplication?.localizedName
	func setup(delegate: RecordedEventDelegate) {
		initialState = .current
		lastState = .current
		
		self.delegate = delegate
		let initialEvent = RecordedEvent.applicationEvent(.initialState(.current), Date())
		Task { await delegate.receivedEvents([initialEvent]) }
		
		NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(didActivateApplication), name: NSWorkspace.didActivateApplicationNotification, object: nil)
		NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(didLaunchApplication), name: NSWorkspace.didLaunchApplicationNotification, object: nil)
		NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(didTerminateApplication), name: NSWorkspace.didTerminateApplicationNotification, object: nil)
		NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(didWake), name: NSWorkspace.didWakeNotification, object: nil)
		NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(willSleep), name: NSWorkspace.willSleepNotification, object: nil)
		NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(willPowerOff), name: NSWorkspace.willPowerOffNotification, object: nil)
	}
	
	func update() {
		let newState = RunningApplicationState.current
		
		let diff = newState.diffs(since: lastState)
		if !diff.isEmpty {
			self.lastState = newState
			Task { await delegate.receivedEvents(diff.events) }
		}

	}
	
	func process(application: NSRunningApplication?) {
		update()
	}
	
	@objc func didActivateApplication(_ note: Notification) {
		process(application: note.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication)
	}
	
	@objc func didLaunchApplication(_ note: Notification) {
		process(application: note.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication)
	}
	
	@objc func didTerminateApplication(_ note: Notification) {
		process(application: note.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication)
	}
	
	@objc func didWake(_ note: Notification) {
		update()
    //Timeline.instance.record(special: .wake)
	}
	
	@objc func willSleep(_ note: Notification) {
		update()
    //Timeline.instance.record(special: .sleep)
	}
	
	@objc func willPowerOff(_ note: Notification) {
		update()
    //Timeline.instance.record(special: .powerOff)
	}

	
}
#endif
