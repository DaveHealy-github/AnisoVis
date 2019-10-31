function tensor4 = mapVoigt2TensorS(voigt_matrix6) 

%% Copyright
% Permission is hereby granted, free of charge, to any person obtaining a
% copy of this software and associated documentation files (the
% "Software"), to deal in the Software without restriction, including
% without limitation the rights to use, copy, modify, merge, publish,
% distribute, sublicense, and/or sell copies of the Software, and to permit
% persons to whom the Software is furnished to do so, subject to the
% following conditions:
% 
% The above copyright notice and this permission notice shall be included
% in all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
% OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
% NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
% DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
% OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
% USE OR OTHER DEALINGS IN THE SOFTWARE.

debugFlag = 0 ; 

if debugFlag == 1 
    disp('Input matrix:') ; 
    disp(voigt_matrix6) ; 
end ; 

tensor4 = zeros(3,3,3,3) ; 

for ij = 1:3 
    
    switch ij 
        case 1
            i = 1 ; 
            j = 1 ; 
        case 2 
            i = 2 ; 
            j = 2 ;
        case 3 
            i = 3 ; 
            j = 3 ; 
    end ; 
    
    for kl = 1:3 
    
        switch kl 
            case 1
                k = 1 ; 
                l = 1 ; 
            case 2 
                k = 2 ; 
                l = 2 ; 
            case 3 
                k = 3 ; 
                l = 3 ; 
        end ; 
        
        tensor4(i,j,k,l) = voigt_matrix6(ij, kl) ; 
        tensor4(i,j,l,k) = voigt_matrix6(ij, kl) ; 
        tensor4(j,i,k,l) = voigt_matrix6(ij, kl) ; 
    
    end ; 
    
    for kl = 4:6 
    
        switch kl 
            case 4 
                k = 2 ; 
                l = 3 ; 
            case 5 
                k = 3 ; 
                l = 1 ; 
            case 6 
                k = 1 ; 
                l = 2 ; 
        end ; 
        
        tensor4(i,j,k,l) = voigt_matrix6(ij, kl) / 2 ; 
        tensor4(i,j,l,k) = voigt_matrix6(ij, kl) / 2 ; 
        tensor4(j,i,k,l) = voigt_matrix6(ij, kl) / 2 ; 
    
    end ; 

    for kl = 4:6 
    
        switch kl 
            case 4 
                k = 3 ; 
                l = 2 ; 
            case 5 
                k = 1 ; 
                l = 3 ; 
            case 6 
                k = 2 ; 
                l = 1 ; 
        end ; 
        
        tensor4(i,j,k,l) = voigt_matrix6(ij, kl) / 2 ; 
        tensor4(i,j,l,k) = voigt_matrix6(ij, kl) / 2 ; 
        tensor4(j,i,k,l) = voigt_matrix6(ij, kl) / 2 ; 
    
    end ; 

end ; 

for ij = 4:6 
    
    switch ij 
        case 4 
            i = 2 ;
            j = 3 ; 
        case 5 
            i = 3 ; 
            j = 1 ; 
        case 6 
            i = 1 ; 
            j = 2 ; 
    end ; 
    
    for kl = 1:3 
    
        switch kl 
            case 1 
                k = 1 ; 
                l = 1 ; 
            case 2 
                k = 2 ; 
                l = 2 ; 
            case 3 
                k = 3 ; 
                l = 3 ; 
        end ; 
        
        tensor4(i,j,k,l) = voigt_matrix6(ij, kl) / 2 ; 
        tensor4(i,j,l,k) = voigt_matrix6(ij, kl) / 2 ; 
        tensor4(j,i,k,l) = voigt_matrix6(ij, kl) / 2 ; 
    
    end ; 
    
    for kl = 4:6 
    
        switch kl 
            case 4 
                k = 2 ; 
                l = 3 ; 
            case 5 
                k = 3 ; 
                l = 1 ; 
            case 6 
                k = 1 ; 
                l = 2 ; 
        end ; 
        
        tensor4(i,j,k,l) = voigt_matrix6(ij, kl) / 4 ; 
        tensor4(i,j,l,k) = voigt_matrix6(ij, kl) / 4 ; 
        tensor4(j,i,k,l) = voigt_matrix6(ij, kl) / 4 ; 
    
    end ; 

    switch ij 
        case 4 
            i = 3 ;
            j = 2 ; 
        case 5 
            i = 1 ; 
            j = 3 ; 
        case 6 
            i = 2 ; 
            j = 1 ; 
    end ; 
    
    for kl = 4:6 
    
        switch kl 
            case 4 
                k = 3 ; 
                l = 2 ; 
            case 5 
                k = 1 ; 
                l = 3 ; 
            case 6 
                k = 2 ; 
                l = 1 ; 
        end ; 
        
        tensor4(i,j,k,l) = voigt_matrix6(ij, kl) / 4 ; 
        tensor4(i,j,l,k) = voigt_matrix6(ij, kl) / 4 ; 
        tensor4(j,i,k,l) = voigt_matrix6(ij, kl) / 4 ; 
    
    end ; 

end ; 

if debugFlag == 1 
    vout = mapTensor2VoigtS(tensor4) ; 
    disp('Output matrix:') ; 
    disp(vout) ;
end ; 
