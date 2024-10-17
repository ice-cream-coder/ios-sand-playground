import XCTest
@testable import SandPlayground

final class SandPlaygroundTestsOld: XCTestCase {

    var contentView: ContentView!
        
        override func setUpWithError() throws {
            contentView = ContentView()
        }

        override func tearDownWithError() throws {
            contentView = nil
        }

        func testInitialGridState() throws {
            XCTAssertEqual(contentView.grid.count, contentView.rows)
            XCTAssertEqual(contentView.grid[0].count, contentView.columns)
            
            for row in contentView.grid {
                XCTAssertEqual(row.filter { $0 }, [])
            }
        }
        
        func testAddSandAt() throws {
            contentView.addSandAt(row: 10, col: 20)
            XCTAssertTrue(contentView.grid[10][20])
            
            // Test adding sand out of bounds
            contentView.addSandAt(row: -1, col: 20)
            contentView.addSandAt(row: 10, col: -1)
            contentView.addSandAt(row: contentView.rows, col: 20)
            contentView.addSandAt(row: 10, col: contentView.columns)
            
            // Ensure only the valid addition changed the grid
            XCTAssertEqual(contentView.grid.flatMap { $0 }.filter { $0 }.count, 1)
        }
        
        func testUpdateSand() throws {
            // Add sand at the top
            contentView.addSandAt(row: 0, col: contentView.columns / 2)
            
            // Update sand once
            contentView.updateSand()
            
            // Check if sand has moved down
            XCTAssertFalse(contentView.grid[0][contentView.columns / 2])
            XCTAssertTrue(contentView.grid[1][contentView.columns / 2])
        }
        
        func testSandPileUp() throws {
            let middleColumn = contentView.columns / 2
            
            // Add sand to fill up a column
            for row in 0..<contentView.rows {
                contentView.addSandAt(row: row, col: middleColumn)
            }
            
            // Update sand once
            contentView.updateSand()
            
            // Check if sand has piled up correctly
            for row in 0..<contentView.rows {
                XCTAssertTrue(contentView.grid[row][middleColumn])
            }
            
            // Add one more sand particle at the top
            contentView.addSandAt(row: 0, col: middleColumn)
            contentView.updateSand()
            
            // Check if the new particle has moved to the side
            XCTAssertTrue(contentView.grid[1][middleColumn - 1] || contentView.grid[1][middleColumn + 1])
        }
        
        func testPerformanceUpdateSand() throws {
            measure {
                for _ in 0..<100 {
                    contentView.updateSand()
                }
            }
        }

}
