public module permatrix

import permutation
import matrix

fun matrix( permutation : permutation ) {
    permutation.vector.list.map fn(el) {
        list(0, permutation.vector.length - 1) fn(i) {
            if (el == i) 1.0 else 0.0
        }
    }.matrix-from-rows
}
