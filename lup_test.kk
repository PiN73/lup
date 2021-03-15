import matrix
import permutation
import permatrix
import lup

fun main() {
    val (l, u, p) = [[0,0,0,6,7,8,0,9]]
        .map-inner(double)
        .matrix-from-rows
        .lup
    l.show.println
    u.show.println
    p.show.println
    (l * u * p.matrix).show.println
    println("")

    val a2 = [
        [11, 9,24,2],
        [ 1, 5, 2,6],
        [ 3,17,18,1],
        [ 2, 5, 7,1]
    ]
    val (l2, u2, p2) = a2
        .map-inner(double)
        .matrix-from-rows
        .lup
    l2.show(5).println
    u2.show(5).println
    p2.matrix.show.println
    (l2 * u2 * p2.matrix).show(-5).println
    println("")

    val a3 = [
        [0,0,0,1],
        [0,0,1,0],
        [0,1,0,0],
        [1,0,0,0],
    ]
    val (l3, u3, p3) = a3
        .map-inner(double)
        .matrix-from-rows
        .lup
    l3.show.println
    u3.show.println
    p3.matrix.show.println
    (l3 * u3 * p3.matrix).show.println
    println("")
}
