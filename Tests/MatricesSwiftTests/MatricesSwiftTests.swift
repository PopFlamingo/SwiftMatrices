import XCTest
@testable import MatricesSwift

final class MatricesSwiftTests: XCTestCase {
    func testExample() {
        let maMatrice = Matrix<Double>(n: 10, m: 10) { i, j in
            Double(i * j)
        }
       
        for i in 0..<10 {
            for j in 0..<10 {
                XCTAssert(maMatrice[i,j] == Double(i*j))
            }
        }
        
    }
    
    func testSet() {
        var maMatrice = Matrix<Double>(n: 10, m: 10, filler: { _,_  in 0 })
        XCTAssertEqual(maMatrice[5,5], 0)
        maMatrice[5,5] = 8
        XCTAssertEqual(maMatrice[5,5], 8)
    }
    
    func testIdentity() {
        let identity = Matrix<Double>.identity(size: 10)
        for i in 0..<10 {
            for j in 0..<10 {
                if i == j {
                    XCTAssertEqual(identity[i,j], 1)
                } else {
                    XCTAssertEqual(identity[i,j], 0)
                }
            }
        }
    }
    
    func testMultiplication() {
        let id = Matrix<Double>.identity(size: 3)
        let a = Matrix<Double>(n: 3, m: 10) { i, j in
            return Double(i*j)
        }
        let result = id * a
        for i in 0..<3 {
            for j in 0..<10 {
                XCTAssertEqual(result[i,j], Double(i*j))
            }
        }
    }
    
    func testArrayEquality() {
        let mesValeurs: [Double] = [
            1, 0, 0,
            0, 1, 0,
            0, 0 ,1
        ]
        let maMatrice = Matrix(n: 3, m: 3, values: mesValeurs)
        XCTAssertEqual(maMatrice, Matrix<Double>.identity(size: 3))
        
        let mesValeursB: [Double] = [
            2, 0, 0,
            0, 1, 0,
            0, 0, 0
        ]
        let maMatriceB = Matrix(n: 3, m: 3, values: mesValeursB)
        XCTAssertNotEqual(maMatriceB, Matrix<Double>.identity(size: 3))
    }
    
    func testAddition() {
        let matrixAValues: [Double] = [
            2, 10, -2,
            0, 0, 0,
            1, 2, 3
        ]
        
        let matrixBValues: [Double] = [
            1, 2, 3,
            4, 5, 6,
            7, 8, 9
        ]
        
        let matrixA = Matrix<Double>(n: 3, m: 3, values: matrixAValues)
        let matrixB = Matrix<Double>(n: 3, m: 3, values: matrixBValues)
        
        let expectedResultValues: [Double] = [
            3, 12, 1,
            4, 5, 6,
            8, 10, 12
        ]
        
        let expectedResult = Matrix<Double>(n: 3, m: 3, values: expectedResultValues)
        
        XCTAssertEqual(expectedResult, matrixA + matrixB)
    }
    
    func testTranspose() {
        let baseValues: [Double] = [
            1, 2, 0,
            4, 3, -1
        ]
        let base = Matrix(n: 2, m: 3, values: baseValues)
        
        let expectedTransposedValues: [Double] = [
            1, 4,
            2, 3,
            0, -1
        ]
        let expectedTransposed = Matrix(n: 3, m: 2, values: expectedTransposedValues)
        XCTAssertEqual(base.transposed(), expectedTransposed)
    }
    
    func testLiteral() {
        let matrix: Matrix = [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9]
        ]
        
        let values: [Double] = [
            1, 2, 3,
            4, 5, 6,
            7, 8, 9
        ]
        
        let otherMatrix = Matrix<Double>(n: 3, m: 3, values: values)
        XCTAssertEqual(matrix, otherMatrix)
    }

    static var allTests = [
        ("testExample", testExample),
        ("testSet", testSet),
        ("testIdentity", testIdentity),
        ("testMultiplication", testMultiplication),
        ("testArrayEquality", testArrayEquality),
        ("testAddition", testAddition),
        ("testTranspose", testTranspose),
        ("testLiteral", testLiteral)
    ]
}
