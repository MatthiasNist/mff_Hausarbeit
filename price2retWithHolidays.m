function retsTable = price2retWithHolidays(prices)
%
% Input:
%   prices      nxm table of prices
%
% Output:
%   retsTable   (n-1)xm table of log returns

missingValues = isnan(prices{:, :});

% log prices
logPrices = log(prices{:, :});
pricesImputed = imputeWithLastDay(logPrices);

% calculate returns
rets = pricesImputed(2:end, :) - pricesImputed(1:end-1, :);

rets(missingValues(2:end, :)) = NaN;

% return log returns as table
retsTable = prices(2:end, :);
retsTable{:, :} = rets;

end

