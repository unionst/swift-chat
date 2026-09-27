import SwiftUI

struct DemoList: View {
    var body: some View {
        NavigationStack {
            List(Demo.allCases) { demo in
                NavigationLink(value: demo) {
                    DemoRow(demo: demo)
                }
            }
            .navigationTitle("Swift Chat")
            .navigationDestination(for: Demo.self) { demo in
                DemoDestination(demo: demo)
            }
        }
    }
}

#Preview {
    DemoList()
}
