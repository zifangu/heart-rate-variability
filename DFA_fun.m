function[A,F] = DFA_fun(data,pts,order)

% -----------------------------------------------------
% DESCRIPTION:
% Function for the DFA analysis.

% INPUTS: 
% data: a one-dimensional data vector.
% pts: sizes of the windows/bins at which to evaluate the fluctuation
% order: (optional) order of the polynomial for the local trend correction.
% if not specified, order == 1;

% OUTPUTS: 
% A: a 2x1 vector. A(1) is the scaling coefficient "alpha",
% A(2) the intercept of the log-log regression, useful for plotting (see examples).
% F: A vector of size Nx1 containing the fluctuations corresponding to the
% windows specified in entries in pts.
%% -----------------------------------------------------

% Checking the inputs
if nargin == 2
   order = 1; 
end

sz = size(data);
if sz(1)< sz(2)
    data = data';
end

exit = 0;

if min(pts) == order+1
        disp(['WARNING: The smallest window size is ' num2str(min(pts)) '. DFA order is ' num2str(order) '.'])
        disp('This severly affects the estimate of the scaling coefficient')
        disp('(If order == [] (so 1), the corresponding fluctuation is zero.)')
elseif min(pts) < (order+1)
        disp(['ERROR: The smallest window size is ' num2str(min(pts)) '. DFA order is ' num2str(order) ':'])
        disp(['Aborting. The smallest window size should be of ' num2str(order+1) ' points at least.'])
        exit = 1;
end

if exit == 1
    return
end


% DFA
npts = numel(pts);

F = zeros(npts,1);
N = length(data);


for h = 1:npts
    
    w = pts(h);
    
%     omit the last box
    n = floor(N/w);
    
%     the last index. If n = 58, h = 1, pts(1) is 4. 58*4 = 232. Index 232
%     is the last index that can be put into a full size box.
    Nfloor = n*pts(h);
    D = data(1:Nfloor);
    
%     this is the actual data point minus the average of all data points
    y = cumsum(D-mean(D));
    
%     w is the box size for this loop
    bin = 0:w:(Nfloor-1);
    vec = 1:w;
%     arrayfun means apply function to the each elements of the array
%     @ operator is defining an instant function
%     ' operator is transpose 
    coeff = arrayfun(@(j) polyfit(vec',y(bin(j) + vec),order),1:n,'uni',0);
    
%     combines a cell of rectangle dimensions to one N x S dimension
%     polyval(x,y). x: polynomial coefficients. y:the points plugging in to
%     produce the value.
    y_hat = cell2mat(cellfun(@(z) polyval(z,vec),coeff,'uni',0));
    F(h)  = mean((y - y_hat').^2)^0.5;
    
end

A = polyfit(log(pts),log(F)',1);

end
