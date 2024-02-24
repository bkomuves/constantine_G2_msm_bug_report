
import os, streams

import ./constantine/constantine/math/arithmetic    
import ./constantine/constantine/math/io/io_fields  
import ./constantine/constantine/math/io/io_bigints
import ./constantine/constantine/math/config/curves  
import ./constantine/constantine/math/extension_fields/towers 
import ./constantine/constantine/platforms/abstractions 
import ./constantine/constantine/math/isogenies/frobenius 
import ./constantine/constantine/math/elliptic/ec_shortweierstrass_affine    
import ./constantine/constantine/math/elliptic/ec_shortweierstrass_projective 
import ./constantine/constantine/math/elliptic/ec_scalar_mul                
import ./constantine/constantine/math/elliptic/ec_scalar_mul_vartime                
import ./constantine/constantine/math/elliptic/ec_multi_scalar_mul

#-------------------------------------------------------------------------------

type B  = BigInt[254]
type P  = Fp[BN254Snarks]
type R  = Fr[BN254Snarks]
type F2 = QuadraticExt[P]
type GA = ECP_ShortW_Aff[F2, G2]
type GP = ECP_ShortW_Prj[F2, G2]

#-------------------------------------------------------------------------------

proc printB( x: B ) =
  echo(" = " & x.toDecimal)

proc printFr( x: R ) =
  echo(" = " & x.toDecimal)

proc printFp( x: P ) =
  echo(" = " & x.toDecimal)
  
proc printF2( z: F2) =
  echo("   1 ~> " & z.coords[0].toDecimal )
  echo("   u ~> " & z.coords[1].toDecimal )

proc printGA( pt: GA ) =
  echo(" affine x coord: ");  printF2( pt.x )
  echo(" affine y coord: ");  printF2( pt.y )

proc printGP( pt: GP ) =
  var aff : GA # ECP_ShortW_Aff[F2, G2];
  aff.affine(pt)
  echo(" affine x coord: ");  printF2( aff.x )
  echo(" affine y coord: ");  printF2( aff.y )

#-------------------------------------------------------------------------------

proc loadZS() : seq[R] =
  let fname1 = "../data/zs.bin"
  let size = int(getFileSize(fname1))
  echo size
  let n = size div 32
  var zs : seq[R] = newSeq[R](n)
  let stream = newFileStream(fname1, mode = fmRead)
  let k = stream.readData( addr(zs[0]) , size )
  stream.close()
  return zs

proc loadB2() : seq[GA] =
  let fname1 = "../data/B2_std.bin"
  let size = int(getFileSize(fname1))
  echo size
  let n = size div 128
  var b2 : seq[GA] = newSeq[GA](n)
  let stream = newFileStream(fname1, mode = fmRead)
  let k = stream.readData( addr(b2[0]) , size )
  stream.close()
  return b2

proc prefixMSM(N: int, cs: seq[B], gs: seq[GA]) =
  var r : GP
  multiScalarMul_vartime( r, toOpenArray(cs, 0, N-1), toOpenArray(gs, 0, N-1) ) 
  echo("\nMSM of size " & $N)
  printGP(r)

var zs = loadZS()
let N = len(zs)
echo("\nsanity check for `zs`")
printF_r(zs[0])
printF_r(zs[1])
printF_r(zs[N-1])

var cs : seq[B] 
for z in zs: cs.add( z.toBig() )

var b2 = loadB2()
echo("\nsanity check for `b2`")
printGA(b2[0])
printGA(b2[1])
printGA(b2[N-1])

prefixMSM(N     , cs , b2)
prefixMSM(10000 , cs , b2)
prefixMSM(1000  , cs , b2)
prefixMSM(100   , cs , b2)

