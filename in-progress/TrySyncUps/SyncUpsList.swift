import ComposableArchitecture
import SwiftUI

extension URL {
  static let syncUps = URL.documentsDirectory.appending(path: "sync-ups.json")
}

@Reducer
struct SyncUpsListFeature {
  @Reducer(state: .equatable)
  enum Destination {
    case addSyncUp(SyncUpFormFeature)
    case syncUpDetail(SyncUpDetailFeature)
  }

  @ObservableState
  struct State: Equatable {
//    @Presents var addSyncUp: SyncUpFormFeature.State?
//    @Presents var syncUpDetail: SyncUpDetailFeature.State?
    @Presents var destination: Destination.State?
    @Shared(.fileStorage(.syncUps)) var syncUps: [SyncUp] = []
  }
  enum Action {
    case addButtonTapped
//    case addSyncUp(PresentationAction<SyncUpFormFeature.Action>)
//    case syncUpDetail(PresentationAction<SyncUpDetailFeature.Action>)
    case destination(PresentationAction<Destination.Action>)
    case cancelButtonTapped
    case onDelete(_ indexSet: IndexSet)
    case syncUpTapped(id: SyncUp.ID)
    case addSyncUpButtonTapped
  }
  @Dependency(\.uuid) var uuid
  var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case .addButtonTapped:
        guard let syncUp = state.destination?.addSyncUp?.syncUp
        else { return .none }
        state.syncUps.append(syncUp)
        state.destination = nil
        return .none
      case .cancelButtonTapped:
        state.destination = nil
        return .none
      case let .onDelete(indexSet):
        state.syncUps.remove(atOffsets: indexSet)
        return .none
      case let .syncUpTapped(id):
        guard let syncUpIndex = state.syncUps.firstIndex(where: { $0.id == id })
        else { return .none }
        state.destination = .syncUpDetail(SyncUpDetailFeature.State(syncUp: state.$syncUps[syncUpIndex]))
        return .none
      case .addSyncUpButtonTapped:
        state.destination = .addSyncUp(SyncUpFormFeature.State(syncUp: SyncUp(id: uuid())))
        return .none
      case .destination:
        return .none
      }
    }
//    .ifLet(\.$addSyncUp, action: \.addSyncUp) {
//      SyncUpFormFeature()
//    }
//    .ifLet(\.$syncUpDetail, action: \.syncUpDetail) {
//      SyncUpDetailFeature()
//    }
    .ifLet(\.$destination, action: \.destination) {
      Destination.body
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
    .sheet(item: $store.scope(state: \.destination?.addSyncUp, action: \.destination.addSyncUp)) { addSyncUpStore in
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
    .navigationDestination(item: $store.scope(state: \.destination?.syncUpDetail, action: \.destination.syncUpDetail)) { syncUpDetailStore in
      SyncUpDetailView(store: syncUpDetailStore)
    }
  }
}

#Preview {
  NavigationStack {
    SyncUpsListView(
      store: Store(
        initialState: SyncUpsListFeature.State(
//          addSyncUp: SyncUpFormFeature.State(syncUp: .mock),
          syncUps: [
            SyncUp(
              id: UUID(),
              attendees: [
                Attendee(id: UUID(), name: "Blob 1"),
                Attendee(id: UUID(), name: "Blob 2"),
                Attendee(id: UUID(), name: "Blob 3"),
                Attendee(id: UUID(), name: "Blob 4"),
                Attendee(id: UUID(), name: "Blob 5"),
                Attendee(id: UUID(), name: "Blob 6"),
              ],
              duration: .seconds(6)
            )
//            .mock, .engineeringMock, .productMock
          ]
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
