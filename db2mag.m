function y = db2mag(x)

% Convert decibels to magnitude
%
% y = db2mag(x)
    
y = 10.^(x / 20);
    