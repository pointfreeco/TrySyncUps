import ComposableArchitecture
import SwiftUI

@Reducer
struct SyncUpDetailFeature {
  @ObservableState
  struct State: Equatable {
    @Presents var alert: AlertState<Action.Alert>?
    @Presents var editSyncUp: SyncUpFormFeature.State?
    @Presents var recordMeeting: RecordMeetingFeature.State?
    @Shared var syncUp: SyncUp
  }
  enum Action {
    case alert(PresentationAction<Alert>)
    case editButtonTapped
    case editSyncUp(PresentationAction<SyncUpFormFeature.Action>)
    case cancelButtonTapped
    case saveButtonTapped
    case deleteButtonTapped
    case recordMeeting(PresentationAction<RecordMeetingFeature.Action>)
    case startMeetingButtonTapped

    enum Alert {
      case confirmDeletion
    }
  }
  
  //@Environment(\.dismiss) var dismiss
  @Dependency(\.dismiss) var dismiss

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .alert(.presented(.confirmDeletion)):
        return .run { [id = state.syncUp.id] _ in
          await dismiss()
          @Shared(.fileStorage(.syncUps)) var syncUps: [SyncUp] = []
          syncUps.removeAll(where: { $0.id == id })
        }

      case .alert:
        return .none

      case .editButtonTapped:
        state.editSyncUp = SyncUpFormFeature.State(syncUp: state.syncUp)
        return .none
      case .editSyncUp:
        return .none
      case .cancelButtonTapped:
        state.editSyncUp = nil
        return .none
      case .saveButtonTapped:
        guard let syncUp = state.editSyncUp?.syncUp
        else { return .none }
        state.syncUp = syncUp
        state.editSyncUp = nil
        return .none
      case .deleteButtonTapped:
        state.alert = AlertState {
          TextState("Are you sure you want to delete this sync up?")
        } actions: {
          ButtonState(role: .destructive, action: .confirmDeletion) {
            TextState("Delete")
          }
        }
        return .none

      case .recordMeeting:
        return .none

      case .startMeetingButtonTapped:
        state.recordMeeting = RecordMeetingFeature.State(syncUp: state.syncUp)
        return .none
      }
    }
      .ifLet(\.$editSyncUp, action: \.editSyncUp) {
        SyncUpFormFeature()
      }
      .ifLet(\.$alert, action: \.alert)
      .ifLet(\.$recordMeeting, action: \.recordMeeting) {
        RecordMeetingFeature()
      }
  }
}

struct SyncUpDetailView: View {
  @Bindable var store: StoreOf<SyncUpDetailFeature>

  var body: some View {
    Form {
      Section {
        Button {
          store.send(.startMeetingButtonTapped)
        } label: {
          Label("Start Meeting", systemImage: "timer")
            .font(.headline)
            .foregroundColor(.accentColor)
        }
        HStack {
          Label("Length", systemImage: "clock")
          Spacer()
          Text(store.syncUp.duration.formatted(.units()))
        }

        HStack {
          Label("Theme", systemImage: "paintpalette")
          Spacer()
          Text(store.syncUp.title)
            .padding(4)
            .foregroundColor(store.syncUp.theme.accentColor)
            .background(store.syncUp.theme.mainColor)
            .cornerRadius(4)
        }
      } header: {
        Text("Sync-up Info")
      }

      if !store.syncUp.meetings.isEmpty {
        Section {
          ForEach(store.syncUp.meetings) { meeting in
            NavigationLink {
              /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Do something...@*//*@END_MENU_TOKEN@*/
            } label: {
              HStack {
                Image(systemName: "calendar")
                Text(meeting.date, style: .date)
                Text(meeting.date, style: .time)
              }
            }
          }
          .onDelete { indices in
            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Do something...@*//*@END_MENU_TOKEN@*/
          }
        } header: {
          Text("Past meetings")
        }
      }

      Section {
        ForEach(store.syncUp.attendees) { attendee in
          Label(attendee.name, systemImage: "person")
        }
      } header: {
        Text("Attendees")
      }

      Section {
        Button("Delete") {
          store.send(.deleteButtonTapped)
        }
        .foregroundColor(.red)
        .frame(maxWidth: .infinity)
      }
    }
    .toolbar {
      Button("Edit") {
        store.send(.editButtonTapped)
      }
    }
    .navigationTitle(store.syncUp.title)
    .sheet(item: $store.scope(state: \.editSyncUp, action: \.editSyncUp)) { editSyncUpStore in
      NavigationStack {
        SyncUpFormView(store: editSyncUpStore)
          .navigationTitle(Text("Edit sync-up"))
          .toolbar {
            ToolbarItem(placement: .cancellationAction) {
              Button("Cancel") {
                store.send(.cancelButtonTapped)
              }
            }
            ToolbarItem {
              Button("Save") {
                store.send(.saveButtonTapped)
              }
            }
          }
      }
    }
    .alert($store.scope(state: \.alert, action: \.alert))
    .sheet(item: $store.scope(state: \.recordMeeting, action: \.recordMeeting)) { recordMeetingStore in
      NavigationStack {
        RecordMeetingView(store: recordMeetingStore)
      }
    }
  }
}

#Preview {
  NavigationStack {
    SyncUpDetailView(
      store: Store(initialState: SyncUpDetailFeature.State(syncUp: Shared(.mock))) {
        SyncUpDetailFeature()
          ._printChanges()
      }
    )
  }
}
