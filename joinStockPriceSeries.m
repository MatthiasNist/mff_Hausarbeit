function joinedTable = joinStockPriceSeries( structArr )
%
% Input:
%   structArr   structure array as returned by hist_stock_data
%
% Output:
%   joinedTable     single table with ones dates column and individual
%                   stocks as columns

nStocks = length(structArr);
tableContainer = cell(1, nStocks);

for ii=1:nStocks
    tableContainer{1, ii} = singleYahooStructure2table(structArr(ii));
end

% join individual tables into single large table
joinedTable = joinMultipleTables(tableContainer);

end

