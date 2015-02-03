function x2 = magSq(x)
% Compute magnitude squared of complex matrix x.
%
% x2 = magSq(x)

% In order of speed (fastest first):
x2 = real(x).^2 + imag(x).^2;
%x2 = x .* conj(x);
%x2 = x .* (x'.');
%x2 = abs(x).^2;
