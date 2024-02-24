
import Data.Proxy
import ZK.Algebra.API
import ZK.Algebra.Curves.BN128

main = do 

  zs <- readFlatArray (Proxy @Fr      ) "../data/zs.bin"
  b2 <- readFlatArray (Proxy @G2Affine) "../data/B2_zik.bin"
  
  let nn = flatArrayLength zs

  putStrLn ""
  putStrLn ""
  putStrLn "sanity check for loading in `zs`"
  putStrLn "--------------------------------"
  print (peekFlatArray zs     0 )
  print (peekFlatArray zs     1 )
  print (peekFlatArray zs (nn-1))

  putStrLn ""
  putStrLn "sanity check for loading in `b2`"
  putStrLn "--------------------------------"
  print (peekFlatArray b2     0 )
  print (peekFlatArray b2     1 )
  print (peekFlatArray b2 (nn-1))

  let prefixMSM n = do
        putStrLn ""
        putStrLn $ "MSM of the prefix of size " ++ show n
        putStrLn   "==============================="
        print $ msm (takeFlatArray n zs) (takeFlatArray n b2)

  prefixMSM nn
  prefixMSM 10000
  prefixMSM 1000
  prefixMSM 100

