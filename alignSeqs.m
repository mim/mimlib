function [labels refAli traAli] = alignSeqs(ref, tra, verbose)

% Align two cell arrays, e.g., of words from ASR transcripts
%
% [labels refAli traAli] = alignSeqs(ref, tra, verbose)
%
% Use dynamic programming (via Dan Ellis' dp.m) to align two sequences
% based on perfect matching, with the same cost for an insertion, deletion,
% and substitution.  Returns labels and sequences expanded to best align
% with each other.  For insertions / deletions, the other sequence has the
% previous word repeated, so you must consult labels to see which sequence
% to read from.
%
% Output variable labels says which words in the best alignment are correct
% (0), insertions (1), deletions (2), and substitutions (3).
%
% Inputs:
%   ref:      reference sequence, cell array of strings
%   tra:      hypothesized (transcribed) sequence, cell array of strings
%   verbose:  boolean indicating whether to print out the aligned sequences
%
% Outputs:
%   labels:   type of operation at that point in sequence (0-3)
%   refAli:   reference transcript with previous word repeated during insertions
%   traAli:   transcribed sequence with previous word repeated during deletions

if nargin < 3, verbose = 0; end

% prepend known label that won't match anything else to simplify scoring of
% the first real word.
ref = [{''} ref];
tra = [{''} tra];

M = zeros(length(ref), length(tra));
for i = 1:size(M,2)
    M(:,i) = ~strcmp(ref, tra{i});
end

[refInd traInd] = dp(M);
refRep = (diff(refInd) == 0);
traRep = (diff(traInd) == 0);

refAli = ref(refInd(2:end));
traAli = tra(traInd(2:end));
match = strcmp(refAli, traAli);

if verbose
    for i = 1:length(refInd)
        widths{i} = max(length(refAli{i}), length(traAli{i}));
    end
    printSent(refAli, widths, refRep);
    printSent(traAli, widths, traRep);
end

% tag words as intertion, substitution, deletion
labels = zeros(size(refRep));
for i = 1:length(refRep)
    if refRep(i)
        labels(i) = 1;  % Insertion
    elseif traRep(i)
        labels(i) = 2;  % Deletion
    elseif ~match(i)
        labels(i) = 3;  % Substitution
    end
end
