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


%% estimating discrete returns, expected percentage return and std. dev.

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

% crating a structure of the data:
dax_comp_ret_struct = struct('dax_ret', dax_comp_ret_disc_array)

% expected discrete percentage return:
exp_ret = mean(dax_comp_ret_struct.dax_ret, 'omitnan');

% expected standard_deviation:
sigma_ret = sqrt(var(dax_comp_ret_struct.dax_ret, 'omitnan'));

% relabelling of table:

param_matrix = [exp_ret(:), sigma_ret(:)]
param_table = array2table(param_matrix);
param_table.Properties.RowNames = col_names;
param_table.Properties.VariableNames = {'expected' 'std_dev'}

%% estimating the correlation coefficients: 

% % saving vector of companies' names
% names_vec = dax_comp_ret_disc.Properties.VariableNames

%correlation matrix of all companies, pairwise:
corr_matrix = corrcoef(dax_comp_ret_struct.dax_ret,'rows','pairwise')

% => upper triangle-matrix already includes all correlation-coefficients:
corr_matrix_up = triu(corr_matrix)

% collapsing columns of upper triangle-matrix column by column in vector:
corr_vec = corr_matrix_up(corr_matrix_up~=1 & corr_matrix_up~=0)

%test:
length(corr_vec) % = 435 = 30*(29/2) (s. Angabe)

%% plotting histogramm:

n_bins = 20;

hist(corr_vec, n_bins)

% labeling of plot
xlabel('correlation')
ylabel('density')
title('Histogramm of correlations concerning returns of DAX-30s (2000 - 2015)')
hold on

%% displaying pair of highest estimated correlation-coefficient:

% finding the index of the highest correaltion in corr_matrix_up
max_corr = max(corr_vec)
[max_row_index, max_col_index] = find((corr_matrix_up == max_corr))

% test:
corr_matrix_up(max_row_index, max_col_index) == max_corr % TRUE

% displaying the ticker symbols of highest correlation in histogramm:
max_corr_disp = text(max_corr-0.05, 5, [col_names(max_row_index), ...
    'vs.', col_names(max_col_index)], 'interpreter', 'none')
max_corr_disp(1).Color = 'blue';
max_corr_disp(1).FontSize = 7;

%% scatterplot of (sigma_i, mu_i) 
hold off
plot(param_table.std_dev, param_table.expected, 'r.')
xlabel('standard deviation')
ylabel('expected percentage return')
title('Statistics of DAX-30s Companies (2000 - 2015)')
hold on

%% estimating portfolio components:

% weigth_1 drawn from U([0, 1])
w_dbk = unifrnd(0,1, 200);

% weight_2 = 1- weight_1 becauso of restriction sum(w_1, w_2) = 1
w_dpw = 1 - w_dbk;

%test:
w_dbk + w_dpw % immer 1

% estimating expected portfolio return:
portfolio_ret = w_dpw*param_table{'DPW_DE', 'expected'} + ...
    w_dbk*param_table{'DBK_DE', 'expected'};

% Covariance beteewn DBK_DE (index: 11) und DPW_DE (index: 12):
cov_dbk_dpw = cov(dax_comp_ret_disc_array(:, 11) , ...
    dax_comp_ret_disc_array(:, 12) , 'omitrows');

% estimating portfolio standard deviation:
portfolio_std_dev = sqrt((w_dpw.^2)*param_table{'DPW_DE', 'std_dev'}^2 +...
    (w_dbk.^2)*param_table{'DBK_DE', 'std_dev'}^2 + ...
    2*(w_dpw.*w_dbk)*cov_dbk_dpw(1,2));

% plotting of portfolio-values:
plot(portfolio_std_dev, portfolio_ret, 'b.')
hold on


% highlighting the represantitives of DBK_DE and DPW_DE
dbk_dpw = plot([param_table{'DPW_DE', 'std_dev'}, param_table{'DBK_DE', ...
    'std_dev'}], [param_table{'DPW_DE', 'expected'}, param_table{'DBK_DE',...
    'expected'}], 'go')
set(dbk_dpw,'MarkerEdgeColor','none','MarkerFaceColor','g')
legend('DAX-30s without DBK/DPW', 'simulated weights DBK/DPW', ...
    'location', 'southwest')

dpw_display = text(param_table{'DPW_DE', 'std_dev'}, ...
    param_table{'DPW_DE', 'expected'}+0.004, 'DPW_DE', 'interpreter', 'none')
dpw_display(1).Color = 'green';
dpw_display(1).FontSize = 6;

dbk_display = text(param_table{'DBK_DE', 'std_dev'}, ...
    param_table{'DBK_DE', 'expected'}+0.004, 'DBK_DE', 'interpreter', 'none')
dbk_display(1).Color = 'green';
dbk_display(1).FontSize = 6;

% findnan(dax_comp_ret_struct.dax_ret(:,100))
% 
% 
% mean(dax_comp_ret_struct.dax_ret(1:1600,1))
% dax_comp_ret_struct.dax_ret(1600:1700,1)
% 
% mean(dax_comp_ret_struct.dax_ret(:,1), 'omitnan')


