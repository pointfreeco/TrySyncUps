import ComposableArchitecture
import XCTest

@testable import TrySyncUps

final class SyncUpsListTests: XCTestCase {
  @MainActor
  func testBasics() async {
    let store = TestStore(initialState: SyncUpsListFeature.State(syncUps: [.mock, .productMock])) {
      SyncUpsListFeature()
    }
    await store.send(.onDelete([1])) {
      $0.syncUps.remove(at: 1)
    }
  }

  @MainActor
  func testAddSyncUp() async {
    let store = TestStore(initialState: SyncUpsListFeature.State()) {
      SyncUpsListFeature()
    } withDependencies: {
      $0.uuid = .incrementing
    }

    await store.send(.addSyncUpButtonTapped) {
      $0.addSyncUp = SyncUpFormFeature.State(syncUp: SyncUp(id: UUID(0)))
    }
//    await store.send(.addSyncUp(.presented(.set(\.syncUp, SyncUp(id: UUID(0), title: "Morning Sync")))))
    await store.send(\.addSyncUp.binding.syncUp, SyncUp(id: UUID(0), title: "Morning Sync")) {
      $0.addSyncUp?.syncUp.title = "Morning Sync"
    }
    await store.send(.addButtonTapped) {
      $0.addSyncUp = nil
      $0.syncUps = [
        SyncUp(id: UUID(0), title: "Morning Sync")
      ]
    }
  }

  @MainActor
  func testModel() {
    let model = SyncUpsListModel(syncUps: [.mock, .productMock])
    model.onDelete([1])
//    XCTAssertEqual(model.syncUps, [.mock])
  }
}
