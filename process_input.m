function [xx, xx1] = process_input(elevation, southern, surf, prof)

sitevalue1 = load(['./input/',prof]);
sitevalue  = load(['./input/',surf]);

% Make sure date is numeric; keep as a column vector for build_sgp_pbl
sitevalue.date = double(sitevalue.date(:));

% --- Pad every N×14 numeric matrix in sitevalue to N×24 with NaNs in cols 1:10 ---
fns = fieldnames(sitevalue);
for k = 1:numel(fns)
    A = sitevalue.(fns{k});
    if isnumeric(A) && ismatrix(A) && size(A,2) == 14
        N = size(A,1);
        sitevalue.(fns{k}) = [nan(N,10), A];  % now N×24, with (:,1:10)=NaN
    end
end

% --- Call your builder (expects N×24 inputs for surface vars) ---
[xx, xx1] = build_sgp_pbl( ...
    sitevalue.rh,  sitevalue.u,   sitevalue.v, ...
    sitevalue.ps,   sitevalue.rain, sitevalue.t, ...
    sitevalue.sh,  sitevalue.lh, ...
    sitevalue1.theta, sitevalue1.height, ...     % θ-profile & heights
    sitevalue1.rh,    sitevalue1.u,  sitevalue1.v, ...  % RH, U, V profiles
    sitevalue1.time,  sitevalue.date, ...       % timestamps (row)
    elevation, southern );                                 % elevation=0 m, southern=false

% --- Save outputs ---
date=sitevalue.date;
save('input_for_dnn.mat','xx','xx1','date');

end
