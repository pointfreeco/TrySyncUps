import SwiftUI

struct RecordMeetingView: View {
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 16)
        .fill(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=appOrange@*/Theme.appOrange/*@END_MENU_TOKEN@*/.mainColor)

      VStack {
        MeetingHeaderView(
          secondsElapsed: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=60 seconds@*/60/*@END_MENU_TOKEN@*/,
          durationRemaining: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=14 minutes@*/.seconds(60 * 14)/*@END_MENU_TOKEN@*/,
          theme: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=appOrange@*/Theme.appOrange/*@END_MENU_TOKEN@*/
        )
        MeetingTimerView(
          syncUp: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=syncUp@*/SyncUp.mock/*@END_MENU_TOKEN@*/,
          speakerIndex: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=0@*/0/*@END_MENU_TOKEN@*/
        )
        MeetingFooterView(
          syncUp: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=syncUp@*/SyncUp.mock/*@END_MENU_TOKEN@*/,
          nextButtonTapped: {
            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Do something...@*//*@END_MENU_TOKEN@*/
          },
          speakerIndex: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=0@*/0/*@END_MENU_TOKEN@*/
        )
      }
    }
    .padding()
    .foregroundColor(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=appOrange@*/Theme.appOrange/*@END_MENU_TOKEN@*/.accentColor)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .cancellationAction) {
        Button("End meeting") {
          /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Do something...@*//*@END_MENU_TOKEN@*/
        }
      }
    }
    .interactiveDismissDisabled(true)
    .navigationBarBackButtonHidden(true)
  }
}

#Preview {
  NavigationStack {
    RecordMeetingView()
  }
}

struct MeetingHeaderView: View {
  let secondsElapsed: Int
  let durationRemaining: Duration
  let theme: Theme

  var body: some View {
    VStack {
      ProgressView(value: progress)
        .progressViewStyle(MeetingProgressViewStyle(theme: theme))
      HStack {
        VStack(alignment: .leading) {
          Text("Time Elapsed")
            .font(.caption)
          Label(
            Duration.seconds(secondsElapsed).formatted(.units()),
            systemImage: "hourglass.bottomhalf.fill"
          )
        }
        Spacer()
        VStack(alignment: .trailing) {
          Text("Time Remaining")
            .font(.caption)
          Label(durationRemaining.formatted(.units()), systemImage: "hourglass.tophalf.fill")
            .font(.body.monospacedDigit())
            .labelStyle(.trailingIcon)
        }
      }
    }
    .padding([.top, .horizontal])
  }

  private var totalDuration: Duration {
    .seconds(secondsElapsed) + durationRemaining
  }

  private var progress: Double {
    guard totalDuration > .seconds(0) else { return 0 }
    return Double(secondsElapsed) / Double(totalDuration.components.seconds)
  }
}

struct MeetingProgressViewStyle: ProgressViewStyle {
  var theme: Theme

  func makeBody(configuration: Configuration) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 10)
        .fill(theme.accentColor)
        .frame(height: 20)

      ProgressView(configuration)
        .tint(theme.mainColor)
        .frame(height: 12)
        .padding(.horizontal)
    }
  }
}

struct MeetingTimerView: View {
  let syncUp: SyncUp
  let speakerIndex: Int

  var body: some View {
    Circle()
      .strokeBorder(lineWidth: 24)
      .overlay {
        VStack {
          Group {
            if speakerIndex < syncUp.attendees.count {
              Text(syncUp.attendees[speakerIndex].name)
            } else {
              Text("Someone")
            }
          }
          .font(.title)
          Text("is speaking")
          Image(systemName: "mic.fill")
            .font(.largeTitle)
            .padding(.top)
        }
        .foregroundStyle(syncUp.theme.accentColor)
      }
      .overlay {
        ForEach(Array(syncUp.attendees.enumerated()), id: \.element.id) { index, attendee in
          if index < speakerIndex + 1 {
            SpeakerArc(totalSpeakers: syncUp.attendees.count, speakerIndex: index)
              .rotation(Angle(degrees: -90))
              .stroke(syncUp.theme.mainColor, lineWidth: 12)
          }
        }
      }
      .padding(.horizontal)
  }
}

struct SpeakerArc: Shape {
  let totalSpeakers: Int
  let speakerIndex: Int

  func path(in rect: CGRect) -> Path {
    let diameter = min(rect.size.width, rect.size.height) - 24
    let radius = diameter / 2
    let center = CGPoint(x: rect.midX, y: rect.midY)
    return Path { path in
      path.addArc(
        center: center,
        radius: radius,
        startAngle: startAngle,
        endAngle: endAngle,
        clockwise: false
      )
    }
  }

  private var degreesPerSpeaker: Double {
    360 / Double(totalSpeakers)
  }
  private var startAngle: Angle {
    Angle(degrees: degreesPerSpeaker * Double(speakerIndex) + 1)
  }
  private var endAngle: Angle {
    Angle(degrees: startAngle.degrees + degreesPerSpeaker - 1)
  }
}

struct MeetingFooterView: View {
  let syncUp: SyncUp
  var nextButtonTapped: () -> Void
  let speakerIndex: Int

  var body: some View {
    VStack {
      HStack {
        if speakerIndex < syncUp.attendees.count - 1 {
          Text("Speaker \(speakerIndex + 1) of \(syncUp.attendees.count)")
        } else {
          Text("No more speakers.")
        }
        Spacer()
        Button(action: nextButtonTapped) {
          Image(systemName: "forward.fill")
        }
      }
    }
    .padding([.bottom, .horizontal])
  }
}
