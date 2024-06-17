//
//  Surveyor.swift
//  Survey
//
//  Created by Ben Gottlieb on 6/13/24.
//

import Foundation
import Combine

#if os(macOS)

public protocol RecordedEventDelegate: AnyActor {
	func receivedEvents(_ events: [RecordedEvent])
}

public actor Surveyor: RecordedEventDelegate {
	public static let instance = Surveyor()
	
	nonisolated let pendingEvents: PassthroughSubject<[RecordedEvent], Never> = .init()
	public func recordedEvents() -> AsyncStream<RecordedEvent> {//} AsyncStream<RecordedEvent>.Iterator {
		AsyncStream(bufferingPolicy: .bufferingOldest(0)) { continuation in
		  let cancellable = pendingEvents.sink { events in
			  for event in events {
				  continuation.yield(event)
			  }
		  }
		  continuation.onTermination = { continuation in
			 cancellable.cancel()
		  }
		}

	}
//	
//	public class RecordedEventStream: AsyncSequence, AsyncIteratorProtocol {
//		public typealias Element = RecordedEvent
//		let stream: AsyncStream<RecordedEvent>
//		
//		init(pendingEvents: PassthroughSubject<[RecordedEvent], Never>) {
//			stream = //
////			return stream//.makeAsyncIterator()
//		}
//		
//		public func next() async -> RecordedEvent? {
//			for await value in stream { return value }
//			return nil
//		}
//
//		public func makeAsyncIterator() -> RecordedEventStream {
//			self
//		}
//
//	}
//		
	public func setup() async {
		await ScriptRunner.instance.setup()
		await RunningApplicationMonitor.instance.setup(delegate: self)
		await BrowserMonitor.instance.setup(delegate: self)
	}
	
	nonisolated public func receivedEvents(_ events: [RecordedEvent]) {
		Task { await self.append(events) }
	}
	
	func append(_ events: [RecordedEvent]) {
		pendingEvents.send(events)
	}
	
//	public func nextEvent() -> RecordedEvent {
//		await recordedEvents.next()!
//	}
	
	
//	actor RecordedEventsSequence: AsyncSequence, AsyncIteratorProtocol {
//		typealias Element = RecordedEvent
//		var pendingEvents: CurrentValueSubject<[RecordedEvent], Never>
//		var queued: [RecordedEvent] = []
//		
//		init(subject: CurrentValueSubject<[RecordedEvent], Never>) {
//			self.pendingEvents = subject
//		}
//		
//		func next() async -> RecordedEvent? {
//			if queued.isEmpty {
//				await pendingEvents.convertToAsync(block: <#T##([RecordedEvent]) async -> MyOutput#>)
//			}
//		}
//		
//		func makeAsyncIterator() -> Counter {
//			self
//		}
//	}
	
}
#endif
