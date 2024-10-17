import XCTest
@testable import SandPlayground

final class SandPlaygroundTestsOld: XCTestCase {

    var model: SandGameModel!
      
      override func setUpWithError() throws {
          model = SandGameModel()
      }

      override func tearDownWithError() throws {
          model = nil
      }

      func testInitialGridState() throws {
          XCTAssertEqual(model.grid.count, model.rows)
          XCTAssertEqual(model.grid[0].count, model.columns)
          
          for row in model.grid {
              XCTAssertEqual(row.filter { $0 }, [])
          }
      }
      
      func testAddSandAt() throws {
          model.addSandAt(row: 10, col: 20)
          XCTAssertTrue(model.grid[10][20])
          
          // Test adding sand out of bounds
          model.addSandAt(row: -1, col: 20)
          model.addSandAt(row: 10, col: -1)
          model.addSandAt(row: model.rows, col: 20)
          model.addSandAt(row: 10, col: model.columns)
          
          // Ensure only the valid addition changed the grid
          XCTAssertEqual(model.grid.flatMap { $0 }.filter { $0 }.count, 1)
      }
      
      func testUpdateSand() throws {
          // Add sand at the top
          model.addSandAt(row: 0, col: model.columns / 2)
          
          // Update sand once
          model.updateSand()
          
          // Check if sand has moved down
          XCTAssertFalse(model.grid[0][model.columns / 2])
          XCTAssertTrue(model.grid[1][model.columns / 2])
      }
      
      func testSandPileUp() throws {
          let middleColumn = model.columns / 2
          
          
          model.addSandAt(row: model.rows - 1, col: middleColumn)
          model.addSandAt(row: model.rows - 2, col: middleColumn)
          
          // Update sand once
          model.updateSand()
          
          // Check if sand has piled up correctly
          XCTAssertTrue(model.grid[model.rows - 1][middleColumn])
          XCTAssertTrue(model.grid[model.rows - 1][middleColumn - 1])
          
          // Add one more sand particle at the top
          model.addSandAt(row: model.rows - 2, col: middleColumn)
          model.updateSand()
          
          // Check if the new particle has moved to the side
          XCTAssertTrue(model.grid[model.rows - 1][middleColumn])
          XCTAssertTrue(model.grid[model.rows - 1][middleColumn - 1])
          XCTAssertTrue(model.grid[model.rows - 1][middleColumn + 1])
          
          
          model.addSandAt(row: model.rows - 2, col: middleColumn)
          model.updateSand()
          
          // Check if the new particle has stayed on top
          XCTAssertTrue(model.grid[model.rows - 1][middleColumn])
          XCTAssertTrue(model.grid[model.rows - 1][middleColumn - 1])
          XCTAssertTrue(model.grid[model.rows - 1][middleColumn + 1])
          XCTAssertTrue(model.grid[model.rows - 2][middleColumn])
      }
      
      func testPerformanceUpdateSand() throws {
          measure {
              for _ in 0..<100 {
                  model.updateSand()
              }
          }
      }
}
