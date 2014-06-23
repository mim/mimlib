function C = cellFrom3D(X)

% Convert each "page" of X into a separate entry in 1D cell array C
%
% C = cellFrom3D(X)

C = cell(1, size(X,3));
for i = 1:size(X,3)
    C{i} = X(:,:,i);
end
