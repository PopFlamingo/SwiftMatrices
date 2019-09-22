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
    
    func transposed() -> Matrix {
        Matrix(n: self.m, m: self.n) { i, j in
            self[j,i]
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
    
    static func filled(n: Int, m: Int, value: Scalar) -> Matrix {
        Matrix(n: n, m: m) { _, _ in
            value
        }
    }
    
    static func zero(n: Int, m: Int) -> Matrix {
        Matrix.filled(n: n, m: m, value: 0)
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
            let index = i * m + j
            return values[index]
        }
        set {
            let index = i * m + j
            values[index] = newValue
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
        for i in 1..<n {
            for j in 1..<m {
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
