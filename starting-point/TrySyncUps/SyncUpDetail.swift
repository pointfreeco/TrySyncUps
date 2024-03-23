import ComposableArchitecture
import SwiftUI

@Reducer
struct SyncUpDetailFeature {
  @ObservableState
  struct State: Equatable {
    var syncUp: SyncUp
  }
  enum Action {
  }
  var body: some ReducerOf<Self> {
    EmptyReducer()
  }
}

struct SyncUpDetailView: View {
  var body: some View {
    Form {
      Section {
        Button {
          /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Do something...@*//*@END_MENU_TOKEN@*/
        } label: {
          Label("Start Meeting", systemImage: "timer")
            .font(.headline)
            .foregroundColor(.accentColor)
        }
        HStack {
          Label("Length", systemImage: "clock")
          Spacer()
          Text(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=15 minutes@*/Duration.seconds(15 * 60)/*@END_MENU_TOKEN@*/.formatted(.units()))
        }

        HStack {
          Label("Theme", systemImage: "paintpalette")
          Spacer()
          Text(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=appOrange@*/Theme.appOrange/*@END_MENU_TOKEN@*/.name)
            .padding(4)
            .foregroundColor(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=appOrange@*/Theme.appOrange/*@END_MENU_TOKEN@*/.accentColor)
            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=appOrange@*/Theme.appOrange/*@END_MENU_TOKEN@*/.mainColor)
            .cornerRadius(4)
        }
      } header: {
        Text("Sync-up Info")
      }

      if /*@START_MENU_TOKEN@*//*@PLACEHOLDER=meetings@*/SyncUp.mock.meetings/*@END_MENU_TOKEN@*/.isEmpty == false {
        Section {
          ForEach(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=meetings@*/SyncUp.mock.meetings/*@END_MENU_TOKEN@*/) { meeting in
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
        ForEach(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=attendees@*/SyncUp.mock.attendees/*@END_MENU_TOKEN@*/) { attendee in
          Label(attendee.name, systemImage: "person")
        }
      } header: {
        Text("Attendees")
      }

      Section {
        Button("Delete") {
          /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Do something...@*//*@END_MENU_TOKEN@*/
        }
        .foregroundColor(.red)
        .frame(maxWidth: .infinity)
      }
    }
    .toolbar {
      Button("Edit") {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Do something...@*//*@END_MENU_TOKEN@*/
      }
    }
    .navigationTitle(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=Design@*/SyncUp.mock.title/*@END_MENU_TOKEN@*/)
  }
}

#Preview {
  NavigationStack {
    SyncUpDetailView()
  }
}
