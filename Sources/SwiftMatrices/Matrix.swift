struct Matrix<Scalar: FloatingPoint>: Equatable, ExpressibleByArrayLiteral {
    
    init(arrayLiteral elements: [Scalar]...) {
        self.init(elements: elements)
    }
    
    init(elements: [[Scalar]]) {
        self.n = elements.count
        self.m = elements.first?.count ?? 0
        self.values = Array()
        self.values.reserveCapacity(n * m)
        for line in elements {
            precondition(line.count == self.m)
            for value in line {
                self.values.append(value)
            }
        }
    }
    
    typealias ArrayLiteralElement = [Scalar]
    
    public internal(set) var values: [Scalar]
    public internal(set) var n: Int
    public internal(set) var m: Int
    
    init(n: Int, m: Int, filler: (Int,Int)->Scalar) {
        values = Array<Scalar>()
        values.reserveCapacity(n*m)
        self.n = n
        self.m = m
        
        for i in 0..<n {
            for j in 0..<m {
                values.append(filler(i,j))
            }
        }
    }
    
    init(n: Int, m: Int, values: [Scalar]) {
        precondition(values.count == n*m)
        self.n = n
        self.m = m
        self.values = values
    }
    
    func gaussElimination() -> Matrix {
        var a = self
        var r = 0
        for j in 0..<a.m where r < a.n {
            var max: Scalar = 0
            var k = r
            for i in r..<a.n {
                let value = abs(a[i,j])
                if value > max {
                    max = value
                    k = i
                }
            }
            
            if a[k,j] != 0 {
                let divider = a[k,j]
                for sj in 0..<a.m {
                    a[k,sj] /= divider
                }
                a.swapLines(k, r)
                for i in 0..<self.n {
                    if i != r {
                        let modifiedR = -(a[i,j] * a.line(at: r))
                        a.addLine(modifiedR, at: i)
                    }
                }
                r += 1
            }
        }
        return a
    }
 
    
    func transposed() -> Matrix {
        Matrix(n: self.m, m: self.n) { i, j in
            self[j,i]
        }
    }
    
    func line(at i: Int) -> Matrix {
        Matrix(n: 1, m: self.m) { _, j in
            self[i,j]
        }
    }
    
    func column(at j: Int) -> Matrix {
        Matrix(n: self.n, m: 1) { i, j in
            self[i,j]
        }
    }
    
    mutating func swapLines(_ line1: Int, _ line2: Int) {
        precondition(line1 >= 0 && line1 < self.n)
        precondition(line2 >= 0 && line2 < self.n)
        for j in 0..<self.m {
            let index1 = line1 * m + j
            let index2 = line2 * m + j
            values.swapAt(index1, index2)
        }
    }
    
    mutating func swapColumns(_ column1: Int, _ column2: Int) {
        precondition(column1 >= 0 && column1 < self.m)
        precondition(column2 >= 0 && column2 < self.m)
        for i in 0..<self.n {
            let index1 = i * m + column1
            let index2 = i * m + column2
            values.swapAt(index1, index2)
        }
    }
    
    mutating func addLine(_ values: Matrix, at line: Int) {
        precondition(values.m == self.m)
        precondition(values.n == 1)
        let i = line
        for j in 0..<self.m {
            let index = i * m + j
            self.values[index] += values[0,j]
        }
    }
    
    static func diagonal(size: Int, diagonalValue: Scalar) -> Matrix<Scalar> {
        Matrix(n: size, m: size) { i, j in
            if i == j {
                return diagonalValue
            } else {
                return 0
            }
        }
    }
    
    static func identity(size: Int) -> Matrix<Scalar> {
        Matrix.diagonal(size: size, diagonalValue: 1)
    }
    
    static func filled(n: Int, m: Int, with value: Scalar) -> Matrix {
        Matrix(n: n, m: m) { _, _ in
            value
        }
    }
    
    static func zero(n: Int, m: Int) -> Matrix {
        Matrix.filled(n: n, m: m, with: 0)
    }
    
    static func *(lhs: Matrix, rhs: Matrix) -> Matrix {
        precondition(lhs.m == rhs.n)
        let result = Matrix(n: lhs.n, m: rhs.m) { i, j in
            var acc: Scalar = 0
            for x in 0..<lhs.m {
                acc += (lhs[i,x] * rhs[x,j])
            }
            return acc
        }
        return result
    }
    
    static func *(lhs: Scalar, rhs: Matrix) -> Matrix {
        Matrix(n: rhs.n, m: rhs.m) { i, j in
            lhs * rhs[i,j]
        }
    }
    
    static func /(lhs: Matrix, rhs: Scalar) -> Matrix {
        (1/rhs) * lhs
    }
    
    static func +(lhs: Matrix, rhs: Matrix) -> Matrix {
        precondition(lhs.n == rhs.n && lhs.m == rhs.m)
        return Matrix(n: lhs.n, m: lhs.m) { i, j in
            lhs[i,j] + rhs[i,j]
        }
    }
    
    static func -(lhs: Matrix, rhs: Matrix) -> Matrix {
        precondition(lhs.n == rhs.n && lhs.m == rhs.m)
        return Matrix(n: lhs.n, m: lhs.m) { i, j in
            lhs[i,j] - rhs[i,j]
        }
    }
    
    static prefix func -(value: Matrix) -> Matrix {
        return Matrix(n: value.n, m: value.m) { i, j in
            -value[i, j]
        }
    }
    
    subscript(i: Int, j: Int) -> Scalar {
        get {
            precondition(i >= 0 && i < self.n && j >= 0 && j < self.m)
            let index = i * m + j
            return values[index]
        }
        set {
            precondition(i >= 0 && i < self.n && j >= 0 && j < self.m)
            let index = i * m + j
            values[index] = newValue
        }
    }
    
    func isAlmostEqual(to other: Matrix, epsilon: Scalar) -> Bool {
        return self.n == other.n && self.m == other.m && zip(self.values, other.values).allSatisfy { lhs, rhs in
            lhs >= rhs-epsilon && lhs <= rhs+epsilon
        }
    }
    
}

extension Matrix: CustomStringConvertible {
    var description: String {
        let stringValues = self.values.map { "\($0)" }
        guard let maxCharCount = stringValues.map({ $0.count }).max() else {
            return "[Ø]"
        }
        var value = ""
        for i in 0..<n {
            for j in 0..<m {
                let currentStr = "\(self[i,j])"
                let currentCount = currentStr.count
                let remaining = maxCharCount - currentCount
                let offset = String(repeatElement(" ", count: remaining))
                value += currentStr
                if j != m-1 {
                    value += (offset + "  ")
                }
            }
            if i != n-1 {
                value += "\n"
            }
        }
        
        return value
    }
}
