function [ mi ] = ComputeMI( i, j, fUV )
% Calculate Mutual Information between Node i and Node j
% According to the MI estimation form from the Chow-Liu slides.
% Parameters:
%   - {i,j} : Index of the variables
%   - fUV   : pairwise variable frequency of all possible states
% Output:
%   - mi    : Mutual Information between variable i and i

    nStates = size(fUV,1);
    mi = 0;
    sumRow = sum(fUV(:, :, i, j), 2);
    sumCol = sum(fUV(:, :, i, j));
    for u=1:nStates
        for v=1:nStates
            logProd = 0;
            den = sumRow(u) * sumCol(v);
            num = fUV(u, v, i, j);
            
            % Avoid taking log of 0 and divide by 0
            if(den ~= 0 && num ~= 0)
                logProd = log(fUV(u, v, i ,j)/den);
            else
                fprintf('\nu=%i, v=%i, i=%i, j=%i', u, v, i, j);
            end
            
            mi = mi + fUV(u, v, i, j) * logProd;
        end
    end
end

