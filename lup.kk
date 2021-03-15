public module lup

import matrix
import permutation
import permatrix

fun isPowerOf2( n : int ) : div bool {
    match(compare(n, 1)) {
        Lt -> False
        Eq -> True
        Gt -> n % 2 == 0 && isPowerOf2(n / 2)
    }
}

// pure is combination of exn and div
// replace pure with <pure,console> to allow println (for debugging)
fun lup( a : matrix ) : pure (matrix, matrix, permutation) {

    if (not(a.m >= a.n)) {
        throw("cols must be >= than rows")
    }
    if (not(a.n.isPowerOf2)) {
        throw("rows must be power of 2")
    }
    // also rank of the input matrix must be equal to rows count

    if (a.n == 1) {
        val row = a.rows.head.unjust
        val i = row.index-of fn(el) { el != 0.0 }
        if (i == -1) {
            throw("singular matrix")
        }
        ( matrix-identity(1), a.swap-cols(0, i), permutation-identity(a.m).swap(0, i) )
    } else {
        val (b, c) = a.vsplit(a.n / 2)
        val (l1, u1, p1) = b.lup
        val d = c * p1.inverse.matrix
        val e = u1.cols.take(u1.n).matrix-from-cols
        val f = d.cols.take(d.n).matrix-from-cols
        val g = d - f * e.inverse-uppertriangular * u1
        val g' = g.cols.drop(g.n).matrix-from-cols
        val (l2, u2, p2) = g'.lup
        val l = vstack(
            hstack( l1, matrix-zeros(l2.n, l1.m) ),
            hstack( f * e.inverse-uppertriangular, l2 )
        )
        val u = vstack(
            u1,
            hstack( matrix-zeros(g.n, g.n), u2 )
        )
        val p = stack(
            permutation-identity(a.m - p2.n),
            p2
        ) * p1
        ( l, u, p )
    }
}
