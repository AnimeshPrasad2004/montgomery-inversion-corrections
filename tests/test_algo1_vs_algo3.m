% =========================================================
% Test: Original Algorithm 1 (buggy) vs
%       Corrected Algorithm 3
% Shows that Algorithm 1 produces incorrect results while
% Algorithm 3 produces correct results for all inputs.
% =========================================================

clear; clc;

p = 19;
% Other Prime Numbers to try:- 17, 97, 101, 1009, 10007, 10009, 10037, 10169, 70039, 70199, 100019
%debugLog prints the values of variables u, v, s, and r at each iteration for a specific input p and a.
% put debugLog = true (for prime numbers like 19, 97)
% put debugLog = false (for large prime numbers)

n = ceil(log2(p));
R = mod(2^n, p);
M = mod(R, p);   % Forward Montgomery inverse

fprintf('==========================================\n');
fprintf('Comparing Algorithm 1 (Original) vs \n');
fprintf('         Algorithm 3 (Corrected)\n');
fprintf('Prime p = %d\n', p);
fprintf('==========================================\n\n');

fail_orig  = 0;   % mismatches in original algorithm
fail_corr  = 0;   % mismatches in corrected algorithm

for a = 1 : p-1
    expected    = ground_truth_bEEA(p, a, M);
    result_orig = algo1_original_bEEA(p, a, M, false);
    result_corr = algo3_corrected_bEEA(p, a, M, false);

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
fprintf('Algorithm 1 (Original) mismatches : %d / %d\n', fail_orig, p-1);
fprintf('Algorithm 3 (Corrected) mismatches: %d / %d\n', fail_corr, p-1);
fprintf('==========================================\n');


% FUNCTIONS

function result = ground_truth_bEEA(p, a, M)
    [G, x, ~] = gcd(a, p);
    if G ~= 1
        error('Modular inverse does not exist for a=%d, p=%d', a, p);
    end
    x      = mod(x, p);
    result = mod(x * M, p);
end

function s = status_str(match)
    if match
        s = 'PASS';
    else
        s = 'FAIL';
    end
end
