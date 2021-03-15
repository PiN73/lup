import permutation

fun main() {
    [20, 10, 40, 10, 30, 20, 20, 30, 30, 10]
        .count fn(el) { el == 30 }
        .println

    permutation([2, 0, 1]).show.println

    (
        permutation([1,4,5,2,0,3]) * permutation([3,0,2,5,4,1])
    ).show.println // 2,1,5,3,0,4

    permutation([1, 2, 0]).inverse.show.println // 2 0 1

    permutation-identity(10).swap(2, 5).show.println
}
