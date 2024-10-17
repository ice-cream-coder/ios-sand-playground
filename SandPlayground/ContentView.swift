import SwiftUI

struct ContentView: View {
    @State var grid: [[Bool]]
    @State private var timer: Timer?
    
    let rows = 100
    let columns = 60
    
    init() {
        _grid = State(initialValue: Array(repeating: Array(repeating: false, count: columns), count: rows))
    }
    
    var body: some View {
        GeometryReader { geometry in
            GridView(grid: grid)
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged { value in
                            let row = Int(value.location.y / (geometry.size.height / CGFloat(rows)))
                            let col = Int(value.location.x / (geometry.size.width / CGFloat(columns)))
                            addSandAt(row: row, col: col)
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
            updateSand()
        }
    }
    
    func stopSimulation() {
        timer?.invalidate()
        timer = nil
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
