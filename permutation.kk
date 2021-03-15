public module permutation

type permutation {
  private Permutation {
    data : vector<int>
  }
}

fun show( permutation : permutation ) : string {
   "(" + permutation.data.list.map(show).join(" ") + ")"
}

fun count( xs : list<a>, pred : a -> bool ) : int
{
  match(xs) {
    Nil -> 0
    Cons(x, xx) -> ( if (pred(x)) then 1 else 0 ) + count(xx, pred)
  }
}

fun is-valid-permutation( data : list<int> ) {
    list(0, data.length - 1).all fn(i) {
        data.count fn(el) { el == i } == 1
    }
}

fun permutation( data : list<int> ) {
    if (data.is-valid-permutation) {
        Permutation(data.vector)
    } else {
        throw("invalid permutation")
    }
}

fun permutation-identity ( n : int ) {
    list(0, n - 1).permutation
}

fun n( permutation : permutation ) {
    permutation.data.length
}

fun vector( permutation : permutation ) {
    permutation.data
}

fun (*)( a : permutation, b : permutation ) {
    if (a.data.length == b.data.length) {
        b.data.list.map fn(el) { a.data[el] } .permutation
    } else {
        throw("permutations must be same length")
    }
}

fun inverse( permutation : permutation ) {
    var v := vector(permutation.data.length, -1)
    permutation.data.foreach-indexed fn(el, i) {
        v[el] := i
    }
    permutation(v)
}

fun swap( permutation : permutation, i : int, j : int ) {
    var v := permutation.data
    val tmp = v[i]
    v[i] := v[j]
    v[j] := tmp
    permutation(v)
}

fun stack( a : permutation, b : permutation) {
    val na = a.data.length
    val aa = a.data.list
    val bb = b.data.list.map fn(el) { el + na }
    permutation(aa + bb)
}
