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
    case cancelEditSyncUpButtonTapped
    case confirmSaveSyncUpButtonTapped
    case deleteButtonTapped
    case editButtonTapped
    case editSyncUp(PresentationAction<SyncUpFormFeature.Action>)
    case recordMeeting(PresentationAction<RecordMeetingFeature.Action>)
    case startMeetingButtonTapped
    enum Alert {
      case confirmDelete
    }
  }
  var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case .alert(.presented(.confirmDelete)):
        // ????
        return .none
      case .alert:
        return .none
      case .cancelEditSyncUpButtonTapped:
        state.editSyncUp = nil
        return .none
      case .confirmSaveSyncUpButtonTapped:
        guard let syncUp = state.editSyncUp?.syncUp
        else { return .none }
        state.syncUp = syncUp
        state.editSyncUp = nil
        return .none
      case .deleteButtonTapped:
        state.alert = AlertState {
          TextState("Are you sure you want to delete this sync up?")
        } actions: {
          ButtonState(action: .confirmDelete) {
            TextState("Yes")
          }
          ButtonState(role: .cancel) {
            TextState("Nevermind")
          }
        }
        return .none
      case .editButtonTapped:
        state.editSyncUp = SyncUpFormFeature.State(syncUp: state.syncUp)
        return .none
      case .editSyncUp:
        return .none
      case .recordMeeting:
        return .none
      case .startMeetingButtonTapped:
        state.recordMeeting = RecordMeetingFeature.State(syncUp: state.syncUp)
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
    .ifLet(\.$editSyncUp, action: \.editSyncUp) {
      SyncUpFormFeature()
    }
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
          Text(store.syncUp.theme.name)
            .padding(4)
            .foregroundColor(store.syncUp.theme.accentColor)
            .background(store.syncUp.theme.mainColor)
            .cornerRadius(4)
        }
      } header: {
        Text("Sync-up Info")
      }

      if store.syncUp.meetings.isEmpty == false {
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
    .navigationTitle(Text(store.syncUp.title))
    .alert($store.scope(state: \.alert, action: \.alert))
    .sheet(item: $store.scope(state: \.editSyncUp, action: \.editSyncUp)) { formStore in
      NavigationStack {
        SyncUpFormView(store: formStore)
          .navigationTitle(Text("Edit sync up"))
          .toolbar {
            ToolbarItem {
              Button("Save") {
                store.send(.confirmSaveSyncUpButtonTapped)
              }
            }
            ToolbarItem(placement: .cancellationAction) {
              Button("Cancel") {
                store.send(.cancelEditSyncUpButtonTapped)
              }
            }
          }
      }
    }
    .sheet(item: $store.scope(state: \.recordMeeting, action: \.recordMeeting)) { recordStore in
      NavigationStack {
        RecordMeetingView(store: recordStore)
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
