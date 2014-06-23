function y = db(x)
    
% Convert amplitude to decibels
%
% y = db(x)
    
y = 10*log10(magSq(x));
