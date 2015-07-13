function out = runWithRandomSeed(seed, fn, varargin)

% Call a function with a particular random seed without disturbing the random state
%
% out = runWithRandomSeed(seed, fn, varargin)
%
% seed is the seed, fn is a handle to the function, varargin are the
% arguments it will be called with, out is the single output of the
% function.

if exist('rng', 'file')
    state = rng;
    rng(seed);
    
    out = fn(varargin{:});
    
    rng(state);

else
    warning('MimLib:RunWithRandomSeed', 'Function "rng" not found, using separate seeds for rand and randn');
    
    stateRand  = rand('state');
    stateRandn = randn('state');
    rand('state', seed);
    randn('state', seed);
    
    out = fn(varargin{:});
    
    rand('state', stateRand);
    randn('state', stateRandn);
end
