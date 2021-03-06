%% PART2: PORTFOLIO SELECTION----------------------------------------------
%---------------------------exercise 3:------------------------------------
%--------------------------------------------------------------------------
% Teilaufgabe 1: Loading Assets for DAX-30s:

% specifying all DAX-listed companies 
% (https://de.finance.yahoo.com/q/cp?s=%5EGDAXI):
ticker_symbs = {'ADS.DE','ALV.DE', 'BAS.DE','BAYN.DE','BEI.DE','BMW.DE',...
    'CBK.DE', 'CON.DE','DAI.DE','DB1.DE', 'DBK.DE','DPW.DE','DTE.DE', ...
    'EOAN.DE','FME.DE','FRE.DE', 'HEI.DE','HEN3.DE','IFX.DE','LHA.DE', ...
    'LIN.DE','LXS.DE', 'MRK.DE','MUV2.DE','RWE.DE','SAP.DE','SDF.DE',...
    'SIE.DE','TKA.DE','VOW3.DE'};

% specify beginning and ending as string variables
date_beg = '01012000';   % first observation on first of January 2000
date_end = '01012015';   % last observation on first of January 2015

% download data of DAX-companies 
dax_comp = getPrices_multi(date_beg,date_end, ticker_symbs);

size(dax_comp, 2) % 30


%% Teilaufgabe 2: Estimating discrete returns, expected percentage return 
%  and standard deviation

dax_comp_ret = price2disc_retWithHolidays(dax_comp); % this function
% returns a matrix with dicrete percentage returns, returns defined as:
% 100*[((price(t+1) - price(t))/price(t)]

% creating a structure of the data:
dax_comp_ret_struct = struct('dax_ret', dax_comp_ret);

% expected discrete percentage return:
exp_ret = mean(dax_comp_ret_struct.dax_ret, 'omitnan');

% expected standard_deviation:
sigma_ret = sqrt(var(dax_comp_ret_struct.dax_ret, 'omitnan'));

% relabelling of table:

col_names = dax_comp.Properties.VariableNames; %odering hasn't changed...
param_matrix = [exp_ret(:), sigma_ret(:)]
param_table = array2table(param_matrix);
param_table.Properties.RowNames = col_names; %ticker-symbols as col. names
param_table.Properties.VariableNames = {'expected' 'std_dev'}

%% Teilaufgabe 3: Estimating the correlation coefficients: 

%correlation matrix of all companies, pairwise:
corr_matrix = corrcoef(dax_comp_ret_struct.dax_ret,'rows','pairwise')

% => upper triangle-matrix already includes all correlation-coefficients:
corr_matrix_up = triu(corr_matrix)

% collapsing columns of upper triangle-matrix column by column in vector:
corr_vec = corr_matrix_up(corr_matrix_up~=1 & corr_matrix_up~=0)

%test:
length(corr_vec) % = 435 = 30*(29/2) (s. Angabe)

%% Teilaufgabe 4: Plotting histogramm concerning correlations:

% Plotting a histogramm concerning correlations (20 bins):
n_bins = 20;
hist(corr_vec, n_bins)

% labeling of plot
xlabel('correlation')
ylabel('density')
title('Histogramm of correlations concerning returns of DAX-30s (2000 - 2015)')
hold on

%% Teilaufgabe 5: Displaying pair of highest estimated correlation-coeff.:

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

%% Teilaufgabe 6: Scatterplot of (sigma_i, mu_i) 
% hold off
figure
plot(param_table.std_dev, param_table.expected, 'r.')
xlabel('standard deviation')
ylabel('expected percentage return')
title('Statistics of DAX-30s Companies (2000 - 2015)')
hold on

%% Teilaufgabe 7: Estimating and plotting portfolio components (i = 2)

% weigth_1 drawn from U([0, 1])
w_dbk = unifrnd(0, 1, 200, 1);

% weight_2 = 1- weight_1 becauso of restriction sum(w_1, w_2) = 1
w_dpw = 1 - w_dbk;

%test:
w_dbk + w_dpw % immer 1

% estimating expected portfolio return:
portfolio_ret = w_dpw.*param_table{'DPW_DE', 'expected'} + ...
    w_dbk.*param_table{'DBK_DE', 'expected'};

% Covariance beteewn DBK_DE (index: 11) und DPW_DE (index: 12):
cov_dbk_dpw = cov(dax_comp_ret(:, 11) , ...
    dax_comp_ret(:, 12) , 'omitrows');

% estimating portfolio standard deviation:
portfolio_std_dev = sqrt((w_dpw.^2).*param_table{'DPW_DE', 'std_dev'}^2 +...
    (w_dbk.^2).*param_table{'DBK_DE', 'std_dev'}^2 + ...
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
    param_table{'DPW_DE', 'expected'} + 0.004, 'DPW_DE', ...
    'interpreter', 'none')
dpw_display(1).Color = 'green';
dpw_display(1).FontSize = 6;

dbk_display = text(param_table{'DBK_DE', 'std_dev'}, ...
    param_table{'DBK_DE', 'expected'} + 0.004, 'DBK_DE', 'interpreter', ...
    'none')
dbk_display(1).Color = 'green';
dbk_display(1).FontSize = 6;

%% Teilaufgabe 8: Portfolio components simulation:

w_dpw_tka_cbk = unif_random2(); % my own function to simulate weigths

%extracting weights:
w_dpw = w_dpw_tka_cbk(:, 1);
w_tka = w_dpw_tka_cbk(:, 2);
w_cbk = w_dpw_tka_cbk(:, 3);
w_dbk = 1 - sum(w_dpw_tka_cbk, 2);

 %tests on constraints:
(min(w_dpw) > 0) + (min(w_tka) > 0) + (min(w_cbk) > 0) + ...
    (min(w_dbk) > 0) == 4
any(w_dpw + w_tka + w_cbk + w_dbk) ~= 1 
mean(w_dpw)
mean(w_tka)
mean(w_cbk)
mean(w_dbk)

%% estimating portfolio expected return 

w_dpw_tka_cbk_dbk = [w_dpw_tka_cbk, w_dbk];

matrix_ret_exp_4 = [param_table{'DPW_DE', 'expected'}, ...
    param_table{'TKA_DE', 'expected'}, ...
    param_table{'CBK_DE', 'expected'}, ...
    param_table{'DBK_DE', 'expected'}];

portfolio_ret_4 = w_dpw_tka_cbk_dbk*(matrix_ret_exp_4'); 

%%
% estimating covariance-matrix with cov()
matrix_ret_4 = [dax_comp_ret(:, 12), ...
    dax_comp_ret(:, 29), dax_comp_ret(:, 7), ...
    dax_comp_ret(:, 11)];

matrix_cov_4 = cov(matrix_ret_4, 'omitrows');

%%
% estimating portfolio standard deviation:

matrix_sd_4 = [param_table{'DPW_DE', 'std_dev'}, ...
    param_table{'TKA_DE', 'std_dev'}, ...
    param_table{'CBK_DE', 'std_dev'}, ...
    param_table{'DBK_DE', 'std_dev'}];

% extracting vecor with all covariances
vector_cov_4 = [matrix_cov_4(1, 2:4), matrix_cov_4(2, 3:4), ...
    matrix_cov_4(3, 4)];

% estimating weight-products:
vector_w_products = [w_dpw_tka_cbk_dbk(:,1:3).*w_dpw_tka_cbk_dbk(:, 2:4),...
    w_dpw_tka_cbk_dbk(:,1:2).*w_dpw_tka_cbk_dbk(:,3:4),  ...
    w_dpw_tka_cbk_dbk(:,1).*w_dpw_tka_cbk_dbk(:,4)];

% estimating portfolio standard deviation:
portfolio_std_dev_4 = sqrt((w_dpw_tka_cbk_dbk.^2)*(matrix_sd_4.^2)' + 2 ...
    *(vector_w_products*vector_cov_4'));      

%% plotting of results:

figure
plot(param_table.std_dev, param_table.expected, 'r.')
xlabel('standard deviation')
ylabel('expected percentage return')
title('Statistics of DAX-30s Companies (2000 - 2015)')
hold on

% plotting portfolio-simulations:
plot(portfolio_std_dev_4, portfolio_ret_4, 'b.')
hold on

% plotting the investigated companies in green:

dbk_tka_cbk_dpw = plot([param_table{'DPW_DE', 'std_dev'}, ...
    param_table{'TKA_DE', 'std_dev'}, param_table{'CBK_DE', 'std_dev'}, ...
    param_table{'DBK_DE', 'std_dev'}], [param_table{'DPW_DE', ...
    'expected'}, param_table{'TKA_DE', 'expected'}, ...
    param_table{'CBK_DE', 'expected'}, param_table{'DBK_DE', 'expected'}...
    ], 'go')
set(dbk_tka_cbk_dpw, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', 'g')

dpw_display = text(param_table{'DPW_DE', 'std_dev'}, ...
    param_table{'DPW_DE', 'expected'} + 0.004, 'DPW_DE', 'interpreter', ...
    'none')
dpw_display(1).Color = 'green';
dpw_display(1).FontSize = 6;

dbk_display = text(param_table{'DBK_DE', 'std_dev'}, ...
    param_table{'DBK_DE', 'expected'} + 0.004, 'DBK_DE', 'interpreter', ...
    'none')
dbk_display(1).Color = 'green';
dbk_display(1).FontSize = 6;

dbk_display = text(param_table{'CBK_DE', 'std_dev'}, ...
    param_table{'CBK_DE', 'expected'} + 0.004, 'CBK_DE', 'interpreter', ...
    'none')
dbk_display(1).Color = 'green';
dbk_display(1).FontSize = 6;

dbk_display = text(param_table{'TKA_DE', 'std_dev'}, ...
    param_table{'TKA_DE', 'expected'} + 0.004, 'TKA_DE', 'interpreter', ...
    'none')
dbk_display(1).Color = 'green';
dbk_display(1).FontSize = 6;

%% letzte Teilaufgabe:

% W�nschenswerte Punkte aus Sicht eines Anlegers sind diejenigen, die 
% m�glichst weit links (geringe Standardabweichung, geht einher mit 
% Risikoaversion der Anleger) und m�glichst weit oben (hohe erwartete 
% Rendite) liegen. Eine analytische L�sung w�re mit einem linearen 
% Optimierungsverfahren bestimmbar. Die Menge der optimalen L�sungen eines 
% solchen Ansatzes w�re in der Menge der Extremalpunkte zu erwarten, also 
% jener Punkte, die das blaue Polyeder umschlie�en. Extremalpunkte sind als
% Verbindungspunkte von Schnitten der Kanten definiert. 
% Letztlich w�re aus der Menge der Extremalpunkte der Extremalpunkt ganz
% oben links im blauen Bereich als optimale analytische L�sung zu erwarten.


