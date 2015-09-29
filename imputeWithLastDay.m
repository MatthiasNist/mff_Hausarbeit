function values = imputeWithLastDay(values)
%
% Input:
%   values      nxm matrix
%
% Output:
%   values      nxm matrix with imputed values

nCols = size(values, 2);

missingValues = isnan(values);
nansToReplace = logical([zeros(1, nCols); ...
    missingValues(2:end, :)]);
replaceWith = logical([missingValues(2:end, :); zeros(1, nCols)]);

values(nansToReplace) = values(replaceWith);

end