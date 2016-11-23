
tickSym = 'DBK.DE';     % Ticker symbol of Deutsche Bank AG (https://de.finance.yahoo.com/q/cp?s=%5EGDAXI)

% specify beginning and ending as string variables
dateBeg = '01012000';   %  first observation on first of January 2000
dateEnd = '01012015'; % Last observation on first of January 2015

dbk_data = getPrices(dateBeg, dateEnd, tickSym)

% calculating logarithmic returns
dbk_returns = price2retWithHolidays(dbk_data);

%%
dbk_returns_vec = dbk_returns.(1) % input-data must be of type 'double'
%object-specification, input for method estimate() must be of class
%GARCH(P, Q) with P = lags of GARCH and Q = lags of Arch. Here: garch(1,1)
object_specif_var = garch(1,1)

% estimate-method for object of class "GARCH" => calculation of process-parameters
params_var = estimate(object_specif_var, dbk_returns_vec)

%EstMdl = estimate(Mdl,y) estimates the unknown parameters of the 
%conditional variance model object Mdl with the observed univariate time 
%series y, using maximum likelihood (!). EstMdl is a fully specified 
%conditional variance model object that stores the results. It is the 
%same model type as Mdl (see garch, egarch, and gjr).

garch_val = params_var.GARCH{1} % GARCH-parameter
arch_val = params_var.ARCH{1}   % ARCH-parameter
k = params_var.Constant % offset labeled "k"

%% Estimating "conditional-means":

object_specif = arima('ARLags',1,'Variance',garch(1,1))

[params output] = estimate(object_specif, dbk_returns_vec)
print(params,output)

constant = params.Constant;
ar_1 = params.AR;
garch_val = params.Variance.GARCH{1}; % GARCH-parameter
arch_val = params.Variance.ARCH{1};   % ARCH-parameter
k = params.Variance.Constant; % offset labeled "k"

%% retrieve dynamic coniditional means:

%sigmaHat0 = 1; %initial-value

%preallocation
retrieveMus = zeros(numel(logRets), 1);
%
%retrieveMus(1) = sigmaHat0;

for ii=1:numel(logRets)
    retrieveMus(ii) = constant + ar*logRets(ii-1) + ; %0.0389 - 
end

%% dynamische Varianzbestimmung
% retrieve dynamic sigmas:
logRets = 100*dbk_returns_vec;
sigmaHat0 = 1; %initial-value

%preallocation
retrieveSigmas = zeros(numel(logRets), 1);
retrieveSigmas(1) = sigmaHat0;

for ii=2:numel(logRets)
    retrieveSigmas(ii) = sqrt(k + garch_val*retrieveSigmas(ii-1).^2 +...
        arch_val*logRets(ii-1).^2);
end

%%

% figure('position', [50 50 1200 600])
% subplot(2,1,1)
% plot(dats, logRets)
% datetick 'x'


% das ist wohl "real world observations:
subplot(2,1,2)
plot(dats, retrieveSigmas)
datetick 'x'

%% simulate

Mdl = garch('Constant',0.5,'GARCH',garch_val,...
    'ARCH',arch_val);
rng default; % For reproducibility
[v,y] = simulate(Mdl,3883);

%% Vergleich der Autokorrelationsfunktionen

autoCorrCoef_real = corr(logRets(1:end-1), logRets(2:end))
autoCorrCoef_sim = corr(y(1:end-1), y(2:end))

%%

nLags = 20;

autoCorrCoef = zeros(1, nLags);
for ii=1:nLags
    autoCorrCoef(1, ii) = ...
        corr(logRets(1:end-ii), logRets(1+ii:end));
end

subplot(1,2,1)
stem(1:nLags, autoCorrCoef, '.r', 'MarkerSize', 12)
set(gca, 'yLim', [-0.5 1])



autoCorrCoefy = zeros(1, nLags);
for ii=1:nLags
    autoCorrCoefy(1, ii) = ...
        corr(y(1:end-ii), y(1+ii:end));
end

subplot(1,2,2)
stem(1:nLags, autoCorrCoefy, '.r', 'MarkerSize', 12)
set(gca, 'yLim', [-0.5 1])
