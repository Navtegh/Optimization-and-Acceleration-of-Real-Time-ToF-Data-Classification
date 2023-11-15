function varargout = inverse_cat(DIM,C)
% INVERSE_CAT splits data into sub-arrays along the specified dimension.
%     [A B]=INVERSE_CAT(DIM,M) splits array M along dimension, DIM,
%     returning sub-arrays A and B.
%
%  Examples:
%     M = [1 2 3; 4 5 6; 7 8 9];
%     C = cat(2,M,M)
%     [A B] = inverse_cat(2,C)         ... returns A=M and B=M
%     [A B] = inverse_cat(1,rot90(C))  ... returns A=rot90(M) B=rot90(M)
%     [A B] = inverse_cat(3,cat(3,M,M))... returns A=M and B=M
%
%     See also cat, num2cell.

if (~(DIM==round(DIM)) || DIM<1)
    error('Dimension must be a finite integer.');
end

nout = max(nargout,1);
x = cell(nout,1);
q = floor(size(C,DIM)/nout);

if (isempty(C)), varargout = x; return; end

%separate along dimension 2
if (DIM==1)
    for i=1:nout
    	x{i} = C(i*q - q + 1:i*q, :);
    end
    %include extra data from uneven division
    if (mod(size(C,DIM),nout)~=0)
        x{nout} = C(nout*q - q + 1:end, :);
    end
%separate along dimension 2
elseif (DIM==2)
    for i=1:nout
        x{i} = C(:, i*q - q + 1:i*q);
    end
    %include extra data from uneven division
    if (mod(size(C,DIM),nout)~=0)
        x{nout} = C(:, nout*q - q + 1:end);
    end
%separate along dimension 3
elseif (DIM==3)
    for i=1:nout
        x{i} = C(: , :, i*q - q + 1:i*q);
    end
    %include extra data from uneven division
    if (mod(size(C,DIM),nout)~=0)
        x{nout} = C(:, :, nout*q - q + 1:end);
    end
%separate along arbitrary dimension
else 
    index = cell(1, ndims(C)); 
    index(:) = {':'}; 
    for i = 1:nout 
      index{DIM} = i*q - q + 1:i*q; 
      x{i} = C(index{:}); 
    end
end

varargout=x;

%==========================================================================
%inverse_cat.m
%Function to split a data array into sub-arrays along specified dimension.
%--------------------------------------------------------------------------
%author:  David Sedarsky
%date:    April, 2012