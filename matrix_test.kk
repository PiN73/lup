import matrix

fun main() {
    val m = matrix-init(3, 3) fn(i, j) { i.double - j.double }
    println(m.show)
    println(m[0, 1])
    println("")

    val m2 = m.map fn(el) { el ^ 2.0 } + m
    println(m2.show)
    println("")
    println(m2.swap-rows(0, 0).show)
    println("")
    println(m2.swap-rows(0, 1).show)
    println("")
    println(m2.swap-cols(0, 1).show)
    println("")
    println(m2.transpose.show)
    println("")
    println(matrix-identity(4).show)
    println("")
    println(matrix-diag([3.0, 5.0, 9.0]).show)
    println("")

    val a = matrix-from-rows([
        [2, 3, 4],
        [1, 0, 0],
    ].map-inner(double))
    val b = matrix-from-rows([
        [0, 1000],
        [1,  100],
        [0,   10],
    ].map-inner(double))
    println((a * b).show)
    println("")

    vstack(
        [
            [1, 2, 3],
            [4, 5, 6],
        ].map-inner(double).matrix-from-rows,
        [
            [7, 8, 9],
        ].map-inner(double).matrix-from-rows
    ).show.println
    println("")

    hstack(
        [
            [1, 2, 3],
            [4, 5, 6],
        ].map-inner(double).matrix-from-rows,
        [
            [123],
            [456],
        ].map-inner(double).matrix-from-rows
    ).show.println
    println("")

    [
        [1, 2, 3],
        [0, 5, 6],
        [0, 0, 9],
    ].map-inner(double).matrix-from-rows
        .is-uppertriangular
        .println
    [
        [1, 2, 3],
        [0, 5, 6],
        [0, 8, 9],
    ].map-inner(double).matrix-from-rows
        .is-uppertriangular
        .println
    println("")

    var v := [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
    ].map-inner(double).matrix-from-rows
    v[1, 1] := 42.0
    v.show.println
    println("")

    // order matters!
    for-dec (12, 11) fn(i) {
        for-dec (5, 4) fn(j) {
            (i.show + " " + j.show).println
        }
    }
    println("")

    [
        [1, 2, 3],
        [0, 5, 6],
        [0, 0, 9],
    ].map-inner(double).matrix-from-rows
        .inverse-uppertriangular
        .show(precision=3).println
}
