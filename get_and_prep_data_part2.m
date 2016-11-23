
% specifying all DAX-listed companies (https://de.finance.yahoo.com/q/cp?s=%5EGDAXI):
ticker_symbs = {'ADS.DE','ALV.DE', 'BAS.DE','BAYN.DE','BEI.DE','BMW.DE',...
    'CBK.DE', 'CON.DE','DAI.DE','DB1.DE', 'DBK.DE','DPW.DE','DTE.DE', ...
    'EOAN.DE','FME.DE','FRE.DE', 'HEI.DE','HEN3.DE','IFX.DE','LHA.DE', ...
    'LIN.DE','LXS.DE', 'MRK.DE','MUV2.DE','RWE.DE','SAP.DE','SDF.DE',...
    'SIE.DE','TKA.DE','VOW3.DE'};

% specify beginning and ending as string variables
dateBeg = '01012000';   %  first observation on first of January 2000
dateEnd = '01012015';   % Last observation on first of January 2015

% download data of DAX-companies 
dax_comp = getPrices_multi(dateBeg,dateEnd, ticker_symbs);

size(dax_comp, 2) % 30


%%
% calculating discrete returns

% transform to discrete returns: exp(log(a)) = a                        
% here: in price2retWithHolidays: log(prices(2:end)/prices(1:end-1)) 
% = log(prices(2:end) - log(prices(1:end-1) => Output                            
% to get: prices(2:end)/prices(1:end-1) compute exp() on Output of
% price2retWithHolidays.

dax_comp_ret = price2retWithHolidays(dax_comp);

% converting logRets to array (to apply exp()-fct) and back to table
row_names = dax_comp_ret.Properties.RowNames;
col_names = dax_comp_ret.Properties.VariableNames;
dax_comp_ret_disc_array = 100*exp(table2array(dax_comp_ret));

% relabelling of table:
dax_comp_ret_disc = array2table(dax_comp_ret_disc_array);
dax_comp_ret_disc.Properties.RowNames = row_names;
dax_comp_ret_disc.Properties.VariableNames = col_names;

