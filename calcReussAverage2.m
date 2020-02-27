function [ Er, Nur, Gr, Kr, Betar ] = calcReussAverage2(sR) 

a = ( sR(1,1) + sR(2,2) + sR(3,3) ) / 3 ; 
b = ( sR(2,3) + sR(1,3) + sR(1,2) ) / 3 ; 
c = ( sR(4,4) + sR(5,5) + sR(6,6) ) / 3 ; 

Kr = 1 / ( 3 * a + 6 * b) ;  
Gr = 5 / ( 4 * a - 4 * b + 3 * c ) ; 

Er = 1 / ( 1 / ( 3 * Gr ) + 1 / ( 9 * Kr ) ) ; 
Nur = 0.5 * ( 1 - ( 3 * Gr ) / ( 3 * Kr + Gr ) ) ; 
Betar = 1 / Kr ; 
