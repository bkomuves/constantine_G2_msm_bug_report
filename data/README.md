
`zs.bin` contains coeffiecients in the BN254 scalar field, Montgomery representation.
Length of the vector is 24101.

`B2_*.bin` contains affine G2 points in the BN254 scalar field, coordinates in
Montgomery representation.

- `B2_ark.bin`: each G2 point has an extra 8 byte at the end, containing 1
  if it's the point at infinity, 0 otherwise
- `B2_zik.bin`: the point at infinity is denoted by 128 bytes of `0xff`
- `B2_std.bin`: the point at infinity is denoted by 128 bytes of `0x00`