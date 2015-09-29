function dbk_table_sorted = getPrices(dateBeg, dateEnd, tickerSymbs)
%
% Input:
%   dateBeg     same format as for hist_stock_data
%   dateEnd     same format as for hist_stock_data
%   tickerSymbs     in this case one string for Deutsche Bank ('DBK.DE')
%
% Output:
%   dbk_table_sorted  table of stock prices for one company/Index, with
%                     all dates that occur and missing observations filled 
%                     with NaNs.

% download data
dbk_structure = hist_stock_data(dateBeg, dateEnd, tickerSymbs);

% converting structure to table
dbk_table = singleYahooStructure2table(dbk_structure); 

% sort (and rename the date-variable)
dbk_table_sorted = sortrows(dbk_table, 1);

dats = dbk_table.(1);
dbk_table_sorted(:, 1) = [];
dbk_table_sorted.Properties.RowNames = dats;

end
