tickSym = 'DBK.DE';     % Ticker symbol of Deutsche Bank AG (https://de.finance.yahoo.com/q/cp?s=%5EGDAXI)

% specify beginning and ending as string variables
dateBeg = '01012000';   %  first observation on first of January 2000
dateEnd = '01012015'; % Last observation on first of January 2015

dbk_data = getPrices(dateBeg, dateEnd, tickSym)

% calculating logarithmic returns
dbk_returns = price2retWithHolidays(dbk_data);

%%

dats = datenum(dbk_returns.Properties.RowNames, 'yyyy-mm-dd');

dbk_returns_vec = dbk_returns.(1) % Vector of dbk_returns
logRets = 100*dbk_returns_vec

% object_specif = arima('ARLags',1,'Variance',garch(1,1))
object_specif = garch(1,1)

[params output] = estimate(object_specif, logRets)
print(params,output)

% constant = params.Constant;
% ar_1 = params.AR;
% garch_val = params.Variance.GARCH{1}; % GARCH-parameter
% arch_val = params.Variance.ARCH{1};   % ARCH-parameter
% k = params.Variance.Constant; % offset labeled "k"


object_specif_var = garch(1,1)

% estimate-method for object of class "GARCH" => calculation of process-parameters
params_var = estimate(object_specif_var, logRets)

%EstMdl = estimate(Mdl,y) estimates the unknown parameters of the 
%conditional variance model object Mdl with the observed univariate time 
%series y, using maximum likelihood (!). EstMdl is a fully specified 
%conditional variance model object that stores the results. It is the 
%same model type as Mdl (see garch, egarch, and gjr).

garch_val = params_var.GARCH{1} % GARCH-parameter
arch_val = params_var.ARCH{1}   % ARCH-parameter
k = params_var.Constant % offset labeled "k"


var = infer(params_var, logRets)
%mu = infer(params, logRets)

alphaLevels = 1 - [0.95];
sigma = sqrt(var)
val_pdf_crit = norminv(alphaLevels, arch_val, sigma) % schaut gut aus, aber ist wirklich der ARCH-parameter der gesuchte Mittelwert?


figure('position', [50 50 1200 600])

scatter(dats, logRets, '.')
datetick 'x'
set(gca, 'xLim', [dats(end) dats(1)])

hold on;

% line([dats(end) dats(1)], val_pdf_crit*[1 1], 'Color', 'black')

exceedances = logRets < val_pdf_crit;
dats_exceed = dats(exceedances);
logRets_exceed = logRets(exceedances);

plot(dats_exceed, logRets_exceed, '.r')

%% Teil mit den Häufigkeiten aus vierter teilaufgabe

freq_exceed = numel(find(logRets < val_pdf_crit))/length(logRets)

%% Überprüfung Varianz (langsamer)

sigmaHat0 = 2;

retrieveSigmas = zeros(numel(y), 1);
retrieveSigmas(1) = sigmaHat0;

for ii=2:numel(y)
    retrieveSigmas(ii) = sqrt(k + garch*retrieveSigmas(ii-1).^2 +...
        arch*y(ii-1).^2);
end



