function [xx, xx1] = build_sgp_pbl( ...
    rh, u_surf, v_surf, ps, pr, t2, sh, lh, ...   % N×24 surface arrays
    sonde_th, sonde_h, ...                       % M×K potential-temp & height profiles
    sonde_r, sonde_u, sonde_v, ...               % M×K RH, u and v profiles from sondes
    sonde_time, date_arr, elevation, southern)
%BUILD_SGP_PBL   Produce xx (via pbloutput_13) and xx1 (via pbloutput3).
% Inputs:
%   rh, u_surf, v_surf, ps, pr, t2, sh, lh   — N×24 surface vars
%   sonde_th, sonde_h                       — M×K theta & height profiles
%   sonde_r, sonde_u, sonde_v               — M×K RH, u, v profiles
%   sonde_time                              — 1×M timestamps (yyyymmddHH*100)\%   date_arr                                — N×1 timestamps (yyyymmddHH)
%   elevation                               — scalar to subtract from heights
%   southern                                — bool; if true, adds +6 to month

N = numel(date_arr);
all13 = [];
all3  = [];
% compute months and apply SH→NH shift
% compute months and apply SH→NH shift
% For YYYYMMDD (8 digits)
mons = floor(mod(date_arr,10000)/100);

% For YYYYMMDDHH (10 digits)
% mons = floor(mod(floor(date_arr/100),10000)/100);

if southern
    mons = mod(mons + 6 - 1, 12) + 1;
end

for i = 1:N
    %-- find morning sonde between 10–13 UTC
    lo  = date_arr(i)*100 + 4;
    hi  = date_arr(i)*100 + 7;
    idx = find(sonde_time >= lo & sonde_time <= hi, 1);
    if ~isempty(idx)
        th_prof = sonde_th(idx, :);
        h_prof  = sonde_h(idx, :) - elevation;
        if max(sonde_r(:))>5
        erar    = sonde_r(idx, :) / 100;   % RH fraction
        else
        erar    = sonde_r(idx, :);   % RH fraction
        end
        erau    = sonde_u(idx, :);
        erav    = sonde_v(idx, :);
    else
        K       = size(sonde_h,2);
        th_prof = nan(1,K);
        h_prof  = nan(1,K);
        erar    = nan(1,K);
        erau    = erar;
        erav    = erar;
    end
    mon_cal = mons(i);

    %-- surface inputs
    rh_i   = rh(i, :);
    u_i    = u_surf(i, :);
    v_i    = v_surf(i, :);
    ps_i   = ps(i, :);
    pr_i   = pr(i, :);
    t2_i   = t2(i, :);
    sh_i   = sh(i, :);
    lh_i   = lh(i, :);

    %-- call pbloutput_13 with theta-profile
    out13 = pbloutput_13( ...
        h_prof, th_prof, mon_cal, ...
        rh_i, u_i, v_i, ps_i, pr_i, t2_i, sh_i, lh_i);

    %-- call pbloutput3 with the same theta-profile
    out3 = pbloutput3( ...
        mon_cal, rh_i, u_i, v_i, ps_i, t2_i, sh_i, lh_i, ...
        erar, erau, erav, th_prof, h_prof);

    all13 = [all13; out13];
    all3  = [all3;  out3];
end

% transpose to features×samples
xx  = all13';
xx1 = all3';
end
