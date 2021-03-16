# LUP matrix decomposition

This is a recursive implementation of LUP decomposition in [Koka Language](https://koka-lang.github.io/koka/doc/index.html). Input matrix is decomposed to L * U * P, where L is a lower triangular matrix, P is an upper triangular matrix, and P is a permutation matrix.

The algorithm implementation is located in [lup.kk](./lup.kk) file.

### Requirements

This code requires Koka Language 2.0.16.

To install it on Linux, type

```bash
curl -sSL https://github.com/koka-lang/koka/releases/download/v2.0.16/install.sh | sh
```

For more instructions, see [oficial repository](https://github.com/koka-lang/koka/releases/v2.0.16/).

### Running

To run some examples, clone this repo and type

```bash
koka lup_examples.kk
```

### Note

Despite the fact that the implementation is written in Koka, it doesn't utilize much Koka's benefits like effects system and possibility to write perfomant code. This is just proof of concept.
