function [t,m,S,p,ll] = gmmCluster(X,K)
%
% [t,m,S,p,ll] = gmmCluster(X,K)
%
% Cluster data points in X into a mixture of K gaussians using
% expectation-maximization.  X is NxD and each row of it is a point. t is a
% column vector of assignments of points to clusters, m is a matrix of the
% means of each cluster, S is a DxDxM matrix where S(:,:,i) is the
% covariance of the i-th cluster, p is a column vector of the priors over
% the gaussians in the mixture, and ll is the evolution of the log
% likelihood of the data as a function of iteration.

[N, D] = size(X);
max_iter = 30;
% done_thresh = -inf;
done_thresh = 1e-3;
eta = 1e-2;
small = 1e-6/eta;

% initialize variables randomly
[m,S,p] = randInit(X,K);
S = S ./ 2;

last_ll = -inf;

for step=1:max_iter
  plotGmm(struct('mu', m, 's', S, 'pi', p), X)
  pause(.1)
    
  % Expectation step
  for i=1:K
    l(:,i) = normal(X, m(i,:), S(:,:,i));
  end
  ll(step) = mean(log(l * p), 1);

  if ll(step) - last_ll < -eps
    warning('Log likelihood has decreased by %f to %f on step %d', ...
            last_ll-ll(step), ll(step), step)
  elseif ll(step) - last_ll < done_thresh
    % stop if we haven't improved much recently
    break
  end
  last_ll = ll(step);
  
  t = (l * diag(p)) ./ repmat(l * p, 1, K);

  
  % Maximization step
  sumt = sum(t,1);
  p = sumt' / N;
  for i=1:K
    m(i,:) = t(:,i)' * X / sumt(i);
    xc = X - repmat(m(i,:), N, 1);
    S(:,:,i) = ...
        xc' * (xc .* repmat(t(:,i),1,D))/(sumt(i)+eta) + eta*small*eye(D);
  end
end



function l = normal(X, m, S)

% cs4771 hw3 problem 2
%
% Evaluate the likelihood of the rows of X (assumed IID) under a
% Gaussian model with mean m and covariance S.

% $$$ det(S)
Z = 1/((2*pi)^(size(X,2)/2)*det(S));
R = inv(S);
XminM = X - repmat(m, size(X,1), 1);

l = Z * exp(-1/2* sum(XminM' .* (R * XminM'), 1))';



function [mu,covar,mix] = randInit(inputs,M)
%
% function [mu,covar,mix] = randInit(inputs,M)
%
%
%  inputs      are the data, columns are dimensions, rows are points
%  M           is # clusters to fit
%
%  mu          are the resulting means (cols are dimensions)
%  cov         are the resulting covariance matricies stacked vertically
%              (i.e. cov is M*dim rows by dim cols)
%  mix         is a column vector of the component mixtures
%
%  D is dimensionality
%  N is # data points in set to fit
%  R is inverse of covariance matrix

dim1 = 1;
dim2 = 2;
vscale = 2;
grain = 40;

[N,D]=size(inputs); 	

% Randomly initialize M Gaussians

mx = max(inputs);
mn = min(inputs);
initmu = (mx+mn)/2;
initsd = (mx-mn)/(M^(1/D));

mu = [];
for (i=1:M)
  mux = (rand(size(mx)).*(mx-mn) + mn);
  mu  = [mu; mux];
end

initcv = diag((initsd/vscale).^2,0);

R=zeros(M*D,D);
for i=1:M
  q = rand(size(initcv))-0.5*ones(size(initcv));
  q = q*q'*2*mean(initsd);
  scal = (mean(initsd)/M)*(mean(initsd)/M);
  q = scal*eye(size(initcv));
  R((i-1)*D+1:i*D,:)=inv(q);
end

mix = ones(M,1)/M;

% clf
% axis([mn(dim1) mx(dim1) mn(dim2) mx(dim2)]);
covar = zeros(D,D,M);
for i=1:M
  covar(:,:,i)=inv(R((i-1)*D+1:i*D,:));
end
 
% plot(inputs(:,dim1),inputs(:,dim2),'g.');
% hold on; plotClust(mu,covar,dim1,dim2); hold off;
% axis('image');
% drawnow;
