function retsTable = price2discretWithHolidays(prices)
%
% Input:
%   prices      nxm table of prices
%
% Output:
%   retsTable   (n-1)xm table of log returns

missingValues = isnan(prices{:, :});

% converting from table to matrix
prices_matrix = prices{:, :};
pricesImputed = imputeWithLastDay(prices_matrix);

% calculate discrete percentage returns
rets = 100*diff(pricesImputed)./pricesImputed(1:end-1,:);

rets(missingValues(2:end, :)) = NaN;

% return discrete returns as table
retsTable = prices(2:end, :);
retsTable{:, :} = rets;

end