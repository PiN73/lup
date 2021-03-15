public module matrix

import std/core/hnd

type matrix {
  // private
  Matrix {
    n : int  // rows
    m : int  // columns
    data : vector<double>
  }
}

fun matrix-full( n : int, m : int, fill-value : double ) {
    Matrix(n, m, vector(n * m, fill-value))
}

fun matrix-full-like( other : matrix, fill-value : double ) {
    matrix-full(other.n, other.m, fill-value)
}

fun matrix-zeros( n : int, m : int ) {
    matrix-full(n, m, 0.0)
}

fun matrix-zeros-like( other : matrix ) {
    matrix-zeros(other.n, other.m)
}

fun matrix-ones( n : int, m : int ) {
    matrix-full(n, m, 1.0)
}

fun matrix-ones-like( other : matrix ) {
    matrix-ones(other.n, other.m)
}

fun matrix-init( n : int, m : int, f : (int, int) -> double ) {
    val data = vector-init(n * m) fn(i) { f(i / m, i % m) }
    Matrix(n, m, data)
}

// standard vector-init doesn't allow effects in f
fun vector-init-e( n : int, f : (int) -> e a ) : e vector<a> {
    list(0, n - 1, f).vector
}

fun matrix-init-e( n : int, m : int, f : (int, int) -> e double ) : e matrix {
    val data = vector-init-e(n * m) fn(i) { f(i / m, i % m) }
    Matrix(n, m, data)
}

fun matrix-init-like( other : matrix, f : (int, int) -> double ) {
    matrix-init(other.n, other.m, f)
}

fun matrix-identity( n : int ) {
    matrix-init(n, n) fn(i, j) {
        if (i == j)
            1.0
        else
            0.0
    }
}

fun matrix-diag( diag : list<double> ) : exn matrix {
    val n = diag.length
    diag.map-indexed fn(i, x) {
        list(0, n - 1) fn(j) {
            if (i == j) x else 0.0
        }
    }.matrix-from-rows
}

fun []( matrix : matrix, i : int, j : int ) : exn double {
    matrix.data[i * matrix.m + j]
}

fun rows( matrix : matrix ) : exn list<list<double>> {
    list(0, matrix.n - 1) fn(i) {
        list(0, matrix.m - 1) fn(j) {
            matrix[i, j]
        }
    }
}

fun all-same( xs : list<int> ) : bool
{
  match(xs) {
    Cons(x,xx) -> xx.all fn(el) { el == x }
    Nil -> True
  }
}

fun matrix-from-rows( rows : list<list<double>> ) : exn matrix {
    val n = rows.length
    val m = rows.head.default([]).length
    if (rows.all fn(el) { el.length == m }) {
        Matrix(n, m, rows.concat.vector)
    } else {
        throw("rows must have same length: " + rows.map(fn(row){row.map(fn(x){x.show}).join(",")}).join("; "))
    }
}

fun cols( matrix : matrix ) : exn list<list<double>> {
    list(0, matrix.m - 1) fn(j) {
        list(0, matrix.n - 1) fn(i) {
            matrix[i, j]
        }
    }
}

fun transpose( matrix : matrix ) {
    matrix.cols.matrix-from-rows
}

fun matrix-from-cols( cols : list<list<double>> ) : exn matrix {
    cols.matrix-from-rows.transpose
}

fun map-inner(xs : list<list<a>>, f : a -> e b) : e list<list<b>> {
    xs.map fn(row) { row.map(f) }
}

fun show( matrix : matrix, precision : int = -17 ) : exn string {
    val strings = matrix.rows
        .map-inner fn(el) { el.show(precision) }
    val width = strings
        .concat
        .map fn(el) { el.count }
        .maximum
    strings
        .map-inner fn(el) { el.pad-left(width) }
        .map fn(row) { row.join(" ") }
        .join("\n")
}

fun map( matrix : matrix, f : double -> e double ) : e matrix {
    Matrix(matrix.n, matrix.m, matrix.data.map(f))
}

fun size( matrix : matrix ) : (int, int) {
    (matrix.n, matrix.m)
}

fun (==)( a : (int, int), b : (int, int) ) : bool {
    val (a1, a2) = a
    val (b1, b2) = b
    a1 == b1 && a2 == b2
}

fun show-size( a : (int, int) ) : string {
    a.fst.show + "x" + a.snd.show
}

fun show-size( matrix : matrix ) : string {
    matrix.size.show-size
}

fun zipwith( xs : vector<a>, ys : vector<b>, f : (a,b) -> e c ) : e vector<c> {
  zipwith(xs.list, ys.list, f).vector
}

fun zipwith(
    a : matrix,
    b : matrix,
    f : (double, double) -> <exn|e> double
) : <exn|e> matrix {
    if (a.size == b.size) {
        Matrix(a.n, a.m, zipwith(a.data, b.data, f))
    } else {
        throw("matrices have different sizes: " + a.show-size + " and " + b.show-size)
    }
}

fun (+)( a : matrix, b : matrix ) : exn matrix {
    zipwith(a, b, (+))
}

fun (-)( a : matrix, b : matrix ) : exn matrix {
    zipwith(a, b, (-))
}


fun sum( xs : list<double> ) : double
{
    xs.foldl(0.0, (+))
}

// fun tmp( a : matrix, b : matrix ) : exn matrix {
//     zipwith(a.rows, b.cols) fn(row, col) {
//         zipwith(row, col, (*)).sum
//     }.matrix-diag
// }

fun (*)( a : matrix, b : matrix ) : exn matrix {
    val rows = a.rows
    val cols = b.cols
    if (a.m == b.n) {
        matrix-init-e(a.n, b.m) fn(i, j) {
            zipwith(rows[i].unjust, cols[j].unjust, (*)).sum
        }
    } else {
        throw("expected nxm and mxk, recieved " + a.show-size + " and " + b.show-size)
    }
}

fun swap( xs : list<a>, i : int, j : int ) : exn list<a> {
    val (tmp, end) = xs.split(j)
    val (beg, mid) = tmp.split(i)
    if (end.length == 0 || mid.length == 0) {
        throw("length of list is " + xs.length.show + ", unable to swap items " + i.show + " and " + j.show)
    }
    beg + [end.head.unjust] + mid.tail + [mid.head.unjust] + end.tail
}

fun swap-rows( matrix : matrix, r1 : int, r2 : int ) {
    if (r1 == r2) {
        matrix
    } else {
        matrix.rows.swap(r1, r2).matrix-from-rows
    }
}

fun swap-cols( matrix : matrix, r1 : int, r2 : int ) {
    matrix.transpose.swap-rows(r1, r2).transpose
}

fun vsplit( matrix : matrix, i : int ) {
    matrix.rows.split(i).map(matrix-from-rows)
}

fun hsplit( matrix : matrix, i : int ) {
    matrix.cols.split(i).map(matrix-from-cols)
}

fun vstack( a : matrix, b : matrix ) {
    (a.rows + b.rows).matrix-from-rows
}

fun hstack( a : matrix, b : matrix ) {
    (a.cols + b.cols).matrix-from-cols
}

fun all-indexed( xs : list<a>, predicate : (idx : int, value : a) -> e bool ) : e bool
{
  fun all-idx(ys, i) {
    match(ys) {
      Cons(y, yy) -> if (predicate(i, y)) then yy.all-idx(i + 1) else False
      Nil -> True
    }
  }
  all-idx(xs, 0)
}

fun is-uppertriangular( matrix : matrix ) {
    matrix.rows.all-indexed fn(i, row) {
        row.take(i).all fn(el) { el == 0.0 }
    }
}

// Assign operator. Usage:
// var m := [
//     [1.0, 2.0, 3.0],
//     [4.0, 5.0, 6.0],
//     [7.0, 8.0, 9.0],
// ].matrix-from-rows
// m[1, 1] := 42.0
// m.show.println
fun []( self : local-var<s,matrix>, i : int, j : int, assigned : double ) : <local<s>,exn|e> () {
    with v = local-var(self.data)
    v[i * self.m + j] := assigned
}

fun for-dec( start: int, end : int, action : (int) -> e () ) : e ()
{
    for(0, start - end) fn(i) {
        action(start - i)
    }
}

fun inverse-uppertriangular( a : matrix ) {
    if (a.n != a.m)
        throw("matrix must be square")
    val n = a.n

    if (!a.is-uppertriangular)
        throw("matrix must be uppertriangular")

    var x := matrix-zeros-like(a)

    for (0, n - 1) fn(k) {
        if (a[k, k] == 0.0) {
            throw("diagonal must be nonzero")
        }
        x[k, k] := 1.0 / a[k, k]
    }

    for-dec (n - 2, 0) fn(i) {
        for-dec (n - 1, i + 1) fn(j) {
            val sum = list(i + 1, j).map fn(k) {
                a[i, k] * x[k, j]
            }.sum()
            x[i, j] := 0.0 - x[i, i] * sum
        }
    }

    x
}
