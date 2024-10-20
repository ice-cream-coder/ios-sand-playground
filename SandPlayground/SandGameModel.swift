import Observation

@Observable
class SandGameModel {
    var selectedMatter = Matter.sand
    var grid: [[Matter]]
    let rows: Int
    let columns: Int
    
    init(rows: Int = 100, columns: Int = 60) {
        self.rows = rows
        self.columns = columns
        self.grid = Array(repeating: Array(repeating: .air, count: columns), count: rows)
    }
    
    func addSandAt(row: Int, col: Int) {
        guard row >= 0 && row < rows && col >= 0 && col < columns else { return }
        grid[row][col] = selectedMatter
    }
    
    func updateSand() {
        var newGrid = grid
        
        for row in (0..<rows-1).reversed() {
            for col in 0..<columns {
                if grid[row][col] == .sand {
                    if grid[row + 1][col] != .sand {
                        newGrid[row][col] = .air
                        newGrid[row + 1][col] = .sand
                    } else if col > 0 && grid[row + 1][col - 1] != .sand {
                        newGrid[row][col] = .air
                        newGrid[row + 1][col - 1] = .sand
                    } else if col < columns - 1 && grid[row + 1][col + 1] != .sand {
                        newGrid[row][col] = .air
                        newGrid[row + 1][col + 1] = .sand
                    }
                }
                if grid[row][col] == .water {
                    if grid[row + 1][col] == .air {
                        newGrid[row][col] = .air
                        newGrid[row + 1][col] = .water
                    } else if col > 0 && grid[row + 1][col - 1] == .air {
                        newGrid[row][col] = .air
                        newGrid[row + 1][col - 1] = .water
                    } else if col < columns - 1 && grid[row + 1][col + 1] == .air {
                        newGrid[row][col] = .air
                        newGrid[row + 1][col + 1] = .water
                    } else if col > 0 && grid[row][col - 1] == .air {
//                        newGrid[row][col] = .air
                        newGrid[row][col - 1] = .water
                    } else if col < columns - 1 && grid[row][col + 1] == .air {
//                        newGrid[row][col] = .air
                        newGrid[row][col + 1] = .water
                    }
                }
            }
        }
        
        grid = newGrid
    }
}
