import SwiftUI
import Observation

@Observable
class SandGameModel {
    var grid: [[Bool]]
    let rows: Int
    let columns: Int
    
    init(rows: Int = 100, columns: Int = 60) {
        self.rows = rows
        self.columns = columns
        self.grid = Array(repeating: Array(repeating: false, count: columns), count: rows)
    }
    
    func addSandAt(row: Int, col: Int) {
        guard row >= 0 && row < rows && col >= 0 && col < columns else { return }
        grid[row][col] = true
    }
    
    func updateSand() {
        var newGrid = grid
        
        for row in (0..<rows-1).reversed() {
            for col in 0..<columns {
                if grid[row][col] {
                    if !grid[row + 1][col] {
                        newGrid[row][col] = false
                        newGrid[row + 1][col] = true
                    } else if col > 0 && !grid[row + 1][col - 1] {
                        newGrid[row][col] = false
                        newGrid[row + 1][col - 1] = true
                    } else if col < columns - 1 && !grid[row + 1][col + 1] {
                        newGrid[row][col] = false
                        newGrid[row + 1][col + 1] = true
                    }
                }
            }
        }
        
        grid = newGrid
    }
}

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
    let grid: [[Bool]]
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let cellWidth = geometry.size.width / CGFloat(grid[0].count)
                let cellHeight = geometry.size.height / CGFloat(grid.count)
                
                for (rowIndex, row) in grid.enumerated() {
                    for (colIndex, cell) in row.enumerated() {
                        if cell {
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
        }
        .background(Color.blue)
    }
}
