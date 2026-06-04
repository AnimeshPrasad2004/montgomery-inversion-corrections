% =========================================================
% Test: Original Algorithm 2 (buggy) vs
%       Corrected Algorithm 4
% Shows that Algorithm 2 produces incorrect results while
% Algorithm 4 produces correct results for all inputs.
% =========================================================

clear; clc;

p = 17;
% Other Prime Numbers to try:- 10007,10009,10037,10169,70199,70039
n = ceil(log2(p));
R = mod(2^n, p);

fprintf('==========================================\n');
fprintf('Comparing Algorithm 2 (Original) vs \n');
fprintf('         Algorithm 4 (Corrected)\n');
fprintf('Prime p = %d\n', p);
fprintf('==========================================\n\n');

fail_orig = 0;
fail_corr = 0;

for a = 1 : p-1
    expected    = ground_truth_kaliski(p, a);
    result_orig = algo2_original_kaliski(p, a, false);
    result_corr = algo4_corrected_kaliski(p, a, false);

    match_orig = (result_orig == expected);
    match_corr = (result_corr == expected);

    if ~match_orig
        fail_orig = fail_orig + 1;
    end
    if ~match_corr
        fail_corr = fail_corr + 1;
    end

    fprintf('a = %d | Orig = %d | Corr = %d | Expected = %d | Orig:%s | Corr:%s\n', ...
        a, result_orig, result_corr, expected, ...
        status_str(match_orig), status_str(match_corr));
end

fprintf('\n==========================================\n');
fprintf('SUMMARY\n');
fprintf('==========================================\n');
fprintf('Algorithm 2 (Original) mismatches : %d / %d\n', fail_orig, p-1);
fprintf('Algorithm 4 (Corrected) mismatches: %d / %d\n', fail_corr, p-1);
fprintf('==========================================\n');


% FUNCTIONS

function result = ground_truth_kaliski(p, a)
    [G, X, ~] = gcd(a, p);
    if G ~= 1
        error('Inverse does not exist for a=%d, p=%d', a, p);
    end
    n      = ceil(log2(p));
    R      = mod(2^n, p);
    result = mod(X * R^2, p);
end

function s = status_str(match)
    if match
        s = 'PASS';
    else
        s = 'FAIL';
    end
end
