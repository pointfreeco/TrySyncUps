import ComposableArchitecture
import XCTest

@testable import TrySyncUps

final class SyncUpsListsTests: XCTestCase {
  @MainActor
  func testDelete() async {
    let store = TestStore(
      initialState: SyncUpsListFeature.State(
        syncUps: [.mock, .engineeringMock]
      )
    ) {
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
    await store.send(\.addSyncUp.binding.syncUp, SyncUp(id: UUID(0), title: "Morning")) {
      $0.addSyncUp?.syncUp.title = "Morning"
    }
    await store.send(.confirmAddSyncUpButtonTapped) {
      $0.addSyncUp = nil
      $0.syncUps = [
        SyncUp(id: UUID(0), title: "Morning")
      ]
    }
  }
}
