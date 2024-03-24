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
    @Shared(.fileStorage(.syncUps)) var syncUps: [SyncUp] = []
  }
  enum Action {
    case addButtonTapped
    case addSyncUp(PresentationAction<SyncUpFormFeature.Action>)
    case cancelButtonTapped
    case onDelete(_ indexSet: IndexSet)
    case syncUpTapped(id: SyncUp.ID)
    case addSyncUpButtonTapped
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .addButtonTapped:
        guard let syncUp = state.addSyncUp?.syncUp
        else { return .none }
        state.syncUps.append(syncUp)
        state.addSyncUp = nil
        return .none
      case .cancelButtonTapped:
        state.addSyncUp = nil
        return .none
      case let .onDelete(indexSet):
        state.syncUps.remove(atOffsets: indexSet)
        return .none
      case .syncUpTapped:
        return .none
      case .addSyncUpButtonTapped:
        state.addSyncUp = SyncUpFormFeature.State(syncUp: SyncUp(id: UUID()))
        return .none
      case .addSyncUp:
        return .none
      }
    }
    .ifLet(\.$addSyncUp, action: \.addSyncUp) {
      SyncUpFormFeature()
    }
  }
}

@Observable
class SyncUpsListModel {
  var syncUps: [SyncUp] = []

  init(syncUps: [SyncUp] = []) {
    self.syncUps = syncUps
  }

  func onDelete(_ indexSet: IndexSet) {
    self.syncUps.remove(atOffsets: indexSet)
  }

  func syncUpTapped(id: SyncUp.ID) {
    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Do something...@*//*@END_MENU_TOKEN@*/
  }

  func addSyncUpButtonTapped() {
    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Do something...@*//*@END_MENU_TOKEN@*/
  }
}

struct SyncUpsListView: View {
  //let model: SyncUpsListModel
  @Bindable var store: StoreOf<SyncUpsListFeature>

  var body: some View {
    List {
      ForEach(store.syncUps) { syncUp in
        Button {
          //model.syncUpTapped(id: syncUp.id)
          store.send(.syncUpTapped(id: syncUp.id))
        } label: {
          CardView(syncUp: syncUp)
        }
        .listRowBackground(syncUp.theme.mainColor)
      }
      .onDelete { indexSet in
        //model.onDelete(indexSet)
        store.send(.onDelete(indexSet))
      }
    }
    .toolbar {
      Button {
        //model.addSyncUpButtonTapped()
        store.send(.addSyncUpButtonTapped)
      } label: {
        Image(systemName: "plus")
      }
    }
    .navigationTitle("Daily Sync-ups")
    .sheet(item: $store.scope(state: \.addSyncUp, action: \.addSyncUp)) { addSyncUpStore in
      NavigationStack {
        SyncUpFormView(store: addSyncUpStore)
          .navigationTitle("New sync-up")
          .toolbar {
            ToolbarItem {
              Button("Add") {
                store.send(.addButtonTapped)
              }
            }
            ToolbarItem(placement: .cancellationAction) {
              Button("Cancel") {
                store.send(.cancelButtonTapped)
              }
            }
          }
      }
    }
  }
}

#Preview {
  NavigationStack {
    SyncUpsListView(
      store: Store(
        initialState: SyncUpsListFeature.State(
          addSyncUp: SyncUpFormFeature.State(syncUp: .mock),
          syncUps: [.mock, .engineeringMock, .productMock]
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
