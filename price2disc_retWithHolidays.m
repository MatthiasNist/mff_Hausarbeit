function disc_rets_out = price2disc_retWithHolidays(prices)
%
% Input:
%   prices      nxm table of prices
%
% Output:
%   disc_rets_out   (n-1)xm matrix of discrete percentage returns

missingValues = isnan(prices{:, :});

% converting from table to matrix
prices_matrix = prices{:, :};

pricesImputed = imputeWithLastDay(prices_matrix);

% calculate discrete percentage returns
disc_rets = 100*diff(pricesImputed)./pricesImputed(1:end-1,:);

disc_rets(missingValues(2:end, :)) = NaN;

disc_rets_out = disc_rets

end