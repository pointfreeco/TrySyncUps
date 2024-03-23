import ComposableArchitecture
import SwiftUI

extension URL {
  static let syncUps = URL.documentsDirectory.appending(path: "sync-ups.json")
}

@Reducer
struct SyncUpsListFeature {
  @ObservableState
  struct State: Equatable {
    @Presents var addSyncUp: SyncUpFormFeature.State?
    @Presents var syncUpDetail: SyncUpDetailFeature.State?
    @Shared(.fileStorage(.syncUps)) var syncUps: IdentifiedArrayOf<SyncUp> = []
  }
  enum Action {
    case addSyncUp(PresentationAction<SyncUpFormFeature.Action>)
    case addSyncUpButtonTapped
    case cancelAddSyncUpButtonTapped
    case confirmAddSyncUpButtonTapped
    case onDelete(IndexSet)
    case syncUpDetail(PresentationAction<SyncUpDetailFeature.Action>)
    case syncUpTapped(id: SyncUp.ID)
  }
  @Dependency(\.uuid) var uuid
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .addSyncUp:
        return .none

      case .addSyncUpButtonTapped:
        state.addSyncUp = SyncUpFormFeature.State(syncUp: SyncUp(id: uuid()))
        return .none

      case .cancelAddSyncUpButtonTapped:
        state.addSyncUp = nil
        return .none

      case .confirmAddSyncUpButtonTapped:
        guard let syncUp = state.addSyncUp?.syncUp
        else { return .none }
        state.syncUps.append(syncUp)
        state.addSyncUp = nil
        return .none

      case let .onDelete(indexSet):
        state.syncUps.remove(atOffsets: indexSet)
        return .none

      case .syncUpDetail:
        return .none

      case let .syncUpTapped(id: id):
        guard let syncUp = state.$syncUps[id: id]
        else { return .none }
        state.syncUpDetail = SyncUpDetailFeature.State(syncUp: syncUp)
        return .none
      }
    }
    .ifLet(\.$addSyncUp, action: \.addSyncUp) {
      SyncUpFormFeature()
    }
    .ifLet(\.$syncUpDetail, action: \.syncUpDetail) {
      SyncUpDetailFeature()
    }
  }
}

@Observable
class SyncUpsModel {
  var syncUps: IdentifiedArrayOf<SyncUp> = []
  func onDelete(_ indexSet: IndexSet) {
  }
}

struct SyncUpsListView: View {
  @Bindable var store: StoreOf<SyncUpsListFeature>
  //let model: SyncUpsModel

  var body: some View {
    List {
      ForEach(store.syncUps) { syncUp in
        Button {
          store.send(.syncUpTapped(id: syncUp.id))
        } label: {
          CardView(syncUp: syncUp)
        }
        .listRowBackground(syncUp.theme.mainColor)
      }
      .onDelete { indexSet in
        store.send(.onDelete(indexSet))
        //model.onDelete(indexSet)
      }
    }
    .toolbar {
      Button {
        store.send(.addSyncUpButtonTapped)
      } label: {
        Image(systemName: "plus")
      }
    }
    .navigationTitle("Daily Sync-ups")
    .sheet(item: $store.scope(state: \.addSyncUp, action: \.addSyncUp)) { formStore in
      NavigationStack {
        SyncUpFormView(store: formStore)
          .navigationTitle("New sync up")
          .toolbar {
            ToolbarItem {
              Button("Add") { store.send(.confirmAddSyncUpButtonTapped) }
            }
            ToolbarItem(placement: .cancellationAction) {
              Button("Cancel") { store.send(.cancelAddSyncUpButtonTapped) }
            }
          }
      }
    }
    .navigationDestination(item: $store.scope(state: \.syncUpDetail, action: \.syncUpDetail)) { detailStore in
      SyncUpDetailView(store: detailStore)
    }
  }
}

#Preview {
  NavigationStack {
    SyncUpsListView(
      store: Store(
        initialState: SyncUpsListFeature.State(
          //addSyncUp: SyncUpFormFeature.State(syncUp: .mock),
          syncUps: [.mock, .productMock, .engineeringMock]
        )
      ) {
        SyncUpsListFeature()._printChanges()
      }
    )
  }
}

struct CardView: View {
  let syncUp: SyncUp

  var body: some View {
    VStack(alignment: .leading) {
      Text(syncUp.title)
        .font(.headline)
      Spacer()
      HStack {
        Label("\(syncUp.attendees.count)", systemImage: "person.3")
        Spacer()
        Label(syncUp.duration.formatted(.units()), systemImage: "clock")
          .labelStyle(.trailingIcon)
      }
      .font(.caption)
    }
    .padding()
    .foregroundColor(syncUp.theme.accentColor)
  }
}

struct TrailingIconLabelStyle: LabelStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.title
      configuration.icon
    }
  }
}

extension LabelStyle where Self == TrailingIconLabelStyle {
  static var trailingIcon: Self { Self() }
}
