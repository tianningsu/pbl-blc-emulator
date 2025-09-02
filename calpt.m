function theta = calpt(T, p)
    % Constants
    T(T<0)=nan;
    p(p<0)=nan;    
    p0 = 1000; % reference pressure in hPa
    kappa = 0.286; % Poisson constant for dry air
    
    % Compute potential temperature matrix
    theta = T .* (p0 ./ p).^kappa;
end
