% =========================================================
% Algorithm 2: Original Constant-Time Algorithm Based on
% Kaliski's Method from Sava & Ko [1]
%
% Reference:
% Sava, E., Ko, C.K.: Montgomery inversion.
% Journal of Cryptographic Engineering 8, 201-210 (2018)
% https://doi.org/10.1007/s13389-017-0161-x
% =========================================================

function r = algo2_original_kaliski(p, a, displayLog)
    u = p;  v = a;
    r = 0;  s = 1;
    k = 0;
    n   = ceil(log2(p));
    pi1 = (v > 0);

    if displayLog
        fprintf('\n    Original_Kaliski: p=%d, a=%d    \n', p, a);
        fprintf('Init: u=%d, v=%d, r=%d, s=%d\n', u, v, r, s);
        fprintf('%-5s %-6s %-6s %-8s %-8s %-15s\n', ...
                'k', 'u', 'v', 'r', 's', 'Branch');
    end

    while k < 2*n
        pi2 =  (mod(u,2) == 0);
        pi3 = (~pi2) && (mod(v,2) == 0);
        pi4 = (~pi2) && (~pi3) && (u > v);
        pi5 = (~pi2) && (~pi3) && (~pi4);
        pi6 =  (r > p);
        pi7 = (~pi6);

        if pi1 && pi2
            branch = '[pi1,pi2]';
            delta  = r - s;
            sigma  = delta + s;
            s = 2 * s;
            u = floor(u / 2);
            r = sigma;

        elseif pi1 && pi3
            branch = '[pi1,pi3]';
            delta  = s - r;
            sigma  = delta + r;
            r = 2 * r;
            v = floor(v / 2);
            s = sigma;

        elseif pi1 && pi4
            branch = '[pi1,pi4]';
            delta  = u - v;
            sigma  = r + s;
            s = 2 * s;
            u = floor(delta / 2);
            r = sigma;

        elseif pi1 && pi5
            branch = '[pi1,pi5]';
            delta  = v - u;
            sigma  = r + s;
            r = 2 * r;
            v = floor(delta / 2);
            s = sigma;

        elseif ~pi1 && pi6
            branch = '[~pi1,pi6]';
            delta  = r - p;
            sigma  = s + p;
            r = 2 * delta;
            sigma  = floor(sigma / 2);
            s = sigma;

        elseif ~pi1 && pi7
            branch = '[~pi1,pi7]';
            delta  = r - p;
            sigma  = s + p;
            r = 2 * r;
            sigma  = floor(sigma / 2);
            s = sigma;
        end

        k   = k + 1;
        pi1 = (v > 0);

        if displayLog
            fprintf('%-5d %-6d %-6d %-8d %-8d %-15s\n', ...
                    k, u, v, r, s, branch);
        end
    end

    % Post-loop: BUG is here
    % (r > 0) is always true since r >= 0 throughout,
    % so the else branch never executes.
    % Correct condition should be (r >= p).
    if displayLog
        fprintf('Post-loop: r = %d, p = %d\n', r, p);
    end

    if r > 0    
        delta = r - p;
        sigma = s + p;
        r = 2 * delta;
        r = floor(r / 2);
        s = p;
        if displayLog
            fprintf('Post-loop branch: r > 0 (BUG) --> r = %d\n', r);
        end
    else
        delta = r - p;
        sigma = s + p;
        r = 2 * r;
        r = floor(r / 2);
        s = p;
        if displayLog
            fprintf('Post-loop branch: else --> r = %d\n', r);
        end
    end

    r = p - r;

    if displayLog
        fprintf('Final r = %d\n\n', r);
    end
end
