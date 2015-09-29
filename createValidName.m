function varname = createValidName( tickSymb )
%
% Input:
%   tickSymb    ticker symbol as string
%
% Output:
%   varname     modified and valid ticker name

tickSymbNoHat = tickSymb(tickSymb ~= '^');
tickSymbNoHat(tickSymbNoHat == '.') = '_';

varname = genvarname(tickSymbNoHat);

end