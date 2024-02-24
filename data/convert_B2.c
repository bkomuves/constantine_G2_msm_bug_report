
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

int main() {

  FILE *f = fopen("B2_zik.bin","rb");
  fseek(f,0,SEEK_END);
  int nbytes = ftell(f);
  printf("file size = %d\n",nbytes);
  uint8_t *buf = malloc(nbytes);
  fseek(f,0,SEEK_SET);
  fread(buf, 1, nbytes, f);
  fclose(f);

  int N = nbytes/128;
  uint8_t *p,*q,*r;

  // constantine (and arkworks) uses (0,0) for the point at the infinity
  uint8_t *buf2 = malloc(nbytes);
  p = buf;
  q = buf2;
  for(int i=0; i<N; i++) {
    if ((p[31]==0xff) && p[63] == 0xff) {
      memset( q, 0, 128 );
    }
    else {
      memcpy( q, p, 128 );
    }
    p += 128;
    q += 128;
  }
  FILE *f2 = fopen("B2_std.bin","wb");
  fwrite(buf2, 1, nbytes, f2);
  fclose(f2);

  // arkworks also uses an extra boolean flag for infinity. And at least
  // on my machine, that bool is stored in 8 bytes...
  uint8_t *ark = malloc(N*136);
  p = buf;
  q = buf2;
  r = ark;
  for(int i=0; i<N; i++) {
    memcpy(r    , q, 128 );
    memset(r+128, 0, 8   );
    r[128] = ((p[31]==0xff) && p[63] == 0xff);
    p += 128;
    q += 128;
    r += 136;
  }
  FILE *f3 = fopen("B2_ark.bin","wb");
  fwrite(ark, 1, N*136, f3);
  fclose(f3);

}