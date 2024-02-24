#![feature(vec_into_raw_parts)]
#![feature(seek_stream_len)]

use ark_bn254::{g2::Config, Bn254, Fr, G1Affine, G1Projective, G2Affine, G2Projective};
use ark_ec::{AffineRepr, CurveGroup, VariableBaseMSM};

use std::mem;
use std::io::{Read,Seek};
use std::fs::{File}; 
use std::fs;

fn read_file<T>(path: &str, unitSize: usize) -> Vec<T> {
  let data : Vec<u8> = std::fs::read(path).unwrap();
  let size = data.len();
  println!("file size = {}", size);
  let len  = size / unitSize;
  //let mut vec: Vec<T> = Vec::with_capacity(len);
  let (ptr,oldlen,oldcap) =  data.into_raw_parts();
  let ptr2 = ptr as *mut T;
  unsafe { Vec::from_raw_parts(ptr2,len,len) }
}

fn main() {

  let coeffs: Vec<Fr>       = read_file::<Fr>       ("../data/zs.bin"    , 32  );
  let points: Vec<G2Affine> = read_file::<G2Affine> ("../data/b2_ark.bin", 136 );

  let N  = coeffs.len();
  let N2 = points.len();

  println!("sizeOf(G2Affine) = {}", std::mem::size_of::<G2Affine>() );

  println!("N  = {}" , N  );
  println!("N2 = {}" , N2 );
  println!("");
  println!("zs[0]   = {}", coeffs[0]   );
  println!("zs[1]   = {}", coeffs[1]   );
  println!("zs[N-1] = {}", coeffs[N-1] );

  println!("");
  println!("b2[0]    = {}", points[0]   );
  println!("b2[1]    = {}", points[1]   );
  //println!("b2[1000] = {}", points[1000]   );
  //println!("b2[N-2]  = {}", points[N-2] );
  println!("b2[N-1]  = {}", points[N-1] );

  println!("");
  let r = G2Projective::msm( &points[..] , &coeffs[..] ).unwrap();
  println!("MSM = {}", r);

}