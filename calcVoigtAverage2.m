function [ Ev, Nuv, Gv, Kv, Betav ] = calcVoigtAverage2(cV) 

A = ( cV(1,1) + cV(2,2) + cV(3,3) ) / 3 ; 
B = ( cV(2,3) + cV(1,3) + cV(1,2) ) / 3 ; 
C = ( cV(4,4) + cV(5,5) + cV(6,6) ) / 3 ; 

Kv = ( A + 2 * B ) / 3 ; 
Gv = ( A - B + 3 * C ) / 5 ; 

Ev = 1 / ( 1 / ( 3 * Gv ) + 1 / ( 9 * Kv ) ) ; 
Nuv = 0.5 * ( 1 - ( 3 * Gv ) / ( 3 * Kv + Gv ) ) ; 
Betav = 1 / Kv ; 
