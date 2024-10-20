//

import Testing
@testable import SandPlayground

struct SandPlaygroundTests {
    
    var model: SandGameModel
    
    init() {
        model = SandGameModel()
    }
    
    @Test("Initial grid state is empty and correct size")
    func initialGridState() throws {
        let optionalString: String? = "Hello, World!"
        let string = try #require(optionalString)
        
        #expect(model.grid.count == model.rows)
        #expect(model.grid[0].count == model.columns)
        
        for row in model.grid {
            #expect(row.filter { $0 == .sand }.isEmpty)
        }
    }
    
    @Test("Adding sand at valid and invalid positions")
    func addSandAt() throws {
        model.addSandAt(row: 10, col: 20)
        #expect(model.grid[10][20] == .sand)
        
        // Test adding sand out of bounds
        model.addSandAt(row: -1, col: 20)
        model.addSandAt(row: 10, col: -1)
        model.addSandAt(row: model.rows, col: 20)
        model.addSandAt(row: 10, col: model.columns)
        
        // Ensure only the valid addition changed the grid
        #expect(model.grid.flatMap { $0 }.filter { $0 == .sand }.count == 1)
    }
    
    @Test("Sand falls down when updated")
    func updateSand() throws {
        // Add sand at the top
        model.addSandAt(row: 0, col: model.columns / 2)
        
        // Update sand once
        model.updateSand()
        
        // Check if sand has moved down
        #expect(model.grid[0][model.columns / 2] != .sand)
        #expect(model.grid[1][model.columns / 2] == .sand)
    }
    
    @Test("Sand piles up and spreads correctly")
    func sandPileUp() throws {
        let middleColumn = model.columns / 2

        model.addSandAt(row: model.rows - 1, col: middleColumn)
        model.addSandAt(row: model.rows - 2, col: middleColumn)

        // Update sand once
        model.updateSand()

        // Check if sand has piled up correctly
        #expect(model.grid[model.rows - 1][middleColumn] == .sand)
        #expect(model.grid[model.rows - 1][middleColumn - 1] == .sand)

        // Add one more sand particle at the top
        model.addSandAt(row: model.rows - 2, col: middleColumn)
        model.updateSand()

        // Check if the new particle has moved to the side
        #expect(model.grid[model.rows - 1][middleColumn] == .sand)
        #expect(model.grid[model.rows - 1][middleColumn - 1] == .sand)
        #expect(model.grid[model.rows - 1][middleColumn + 1] == .sand)


        model.addSandAt(row: model.rows - 2, col: middleColumn)
        model.updateSand()

        // Check if the new particle has stayed on top
        #expect(model.grid[model.rows - 1][middleColumn] == .sand)
        #expect(model.grid[model.rows - 1][middleColumn - 1] == .sand)
        #expect(model.grid[model.rows - 1][middleColumn + 1] == .sand)
        #expect(model.grid[model.rows - 2][middleColumn] == .sand)
    }
}
