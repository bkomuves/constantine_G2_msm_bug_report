
This is a collection of files demonstrating a bug in G2 multi-scalar-multiplication
(specifically, `multiScalarMul_vartime`) in constantine.

Unfortunately I don't have a small example; this particular example has size 24101.

The actual coefficients and G2 points are in the `data` subdirectory. The curve
is BN254, the coefficients are in the scalar field Fr, in Montgomery representation,
little-endian; and the G2 affine curve point coordinates are also in Montgomery.
Since different backends use slightly different representations (in particular
for the point at infinity), there are 3 versions for the G2 points.

Both arkworks and my implementation gives the correct result. Constantine also
gives the correct result for smaller prefixes, like for example the first 10,000
points, but incorrect result for the full array.

- machine used for the testing: macbook pro M2 (arm)
- constantine commit used: latest commit `c7979b0`
  (but the bug should be present for at least a few months)
- nim version: 1.6.18

