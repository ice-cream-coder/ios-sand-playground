import SwiftUI

struct ContentView: View {
    @State private var model: SandGameModel
    @State private var timer: Timer?
    
    init(model: SandGameModel = SandGameModel()) {
        _model = State(initialValue: model)
    }
    
    var body: some View {
        GeometryReader { geometry in
            GridView(grid: model.grid)
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged { value in
                            let row = Int(value.location.y / (geometry.size.height / CGFloat(model.rows)))
                            let col = Int(value.location.x / (geometry.size.width / CGFloat(model.columns)))
                            model.addSandAt(row: row, col: col)
                        }
                )
        }
        .edgesIgnoringSafeArea(.all)
        .overlay(alignment: .top) {
            HStack {
                if model.selectedMatter == .sand {
                    Button(action: { model.selectedMatter = .sand }) {
                        Text("Sand")
                            .padding(12)
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Button(action: { model.selectedMatter = .sand }) {
                        Text("Sand")
                            .padding(12)
                    }
                    .buttonStyle(.bordered)
                }
                if model.selectedMatter == .water {
                    Button(action: { model.selectedMatter = .water }) {
                        Text("Water")
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Button(action: { model.selectedMatter = .water }) {
                        Text("Water")
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .onAppear {
            startSimulation()
        }
        .onDisappear {
            stopSimulation()
        }
    }
    
    func startSimulation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            model.updateSand()
        }
    }
    
    func stopSimulation() {
        timer?.invalidate()
        timer = nil
    }
}

struct GridView: View {
    let grid: [[Matter]]
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let cellWidth = geometry.size.width / CGFloat(grid[0].count)
                let cellHeight = geometry.size.height / CGFloat(grid.count)
                
                for (rowIndex, row) in grid.enumerated() {
                    for (colIndex, cell) in row.enumerated() {
                        if cell == .sand {
                            let rect = CGRect(x: CGFloat(colIndex) * cellWidth,
                                              y: CGFloat(rowIndex) * cellHeight,
                                              width: cellWidth,
                                              height: cellHeight)
                            path.addRect(rect)
                        }
                    }
                }
            }
            .fill(Color.yellow)
            Path { path in
                let cellWidth = geometry.size.width / CGFloat(grid[0].count)
                let cellHeight = geometry.size.height / CGFloat(grid.count)
                
                for (rowIndex, row) in grid.enumerated() {
                    for (colIndex, cell) in row.enumerated() {
                        if cell == .water {
                            let rect = CGRect(x: CGFloat(colIndex) * cellWidth,
                                              y: CGFloat(rowIndex) * cellHeight,
                                              width: cellWidth,
                                              height: cellHeight)
                            path.addRect(rect)
                        }
                    }
                }
            }
            .fill(Color.blue)
        }
        .background(Color.blue.opacity(0.2))
    }
}
