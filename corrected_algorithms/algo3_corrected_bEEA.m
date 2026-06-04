% =========================================================
% Algorithm 3: Corrected Constant-Time Binary Extended
% Euclidean Algorithm (bEEA) 
% =========================================================

function r = algo3_corrected_bEEA(p, a, M, displayLog)
    u = p;  v = a;
    r = 0;  s = M;
    k = 0;
    n   = ceil(log2(p));
    pi1 = (v > 0);

    if displayLog
        fprintf('\n    Constant_bEEA: p=%d, a=%d, M=%d    \n', p, a, M);
        fprintf('Init: u=%d, v=%d, r=%d, s=%d\n', u, v, r, s);
        fprintf('%-5s %-6s %-6s %-8s %-8s %-15s\n', ...
                'k', 'u', 'v', 'r', 's', 'Branch');
    end

    while k < 2*n
        pi2 =  (mod(u,2) == 0);
        pi3 = (~pi2) && (mod(v,2) == 0);
        pi4 = (~pi2) && (~pi3) && (u > v);
        pi5 = (~pi2) && (~pi3) && (~pi4);
        pi6 =  (r < 0);
        pi7 = (~pi6) && (r > p);
        pi8 = (~pi6) && (~pi7);

        if pi1 && pi2
            branch = '[pi1,pi2]';
            u = floor(u/2);
            if mod(r,2) == 0
                r = r/2;
            else
                r = floor((r+p)/2);
            end

        elseif pi1 && pi3
            branch = '[pi1,pi3]';
            v = v/2;
            if mod(s,2) == 0
                s = s/2;
            else
                s = floor((s+p)/2);
            end

        elseif pi1 && pi4
            branch = '[pi1,pi4]';
            dUV = u - v;
            dRS = r - s;
            u   = floor(dUV/2);
            if mod(dRS,2) == 0
                r = dRS/2;
            else
                r = floor((dRS+p)/2);
            end

        elseif pi1 && pi5
            branch = '[pi1,pi5]';
            dUV = v - u;
            dRS = s - r;
            v   = floor(dUV/2);
            if mod(dRS,2) == 0
                s = dRS/2;
            else
                s = floor((dRS+p)/2);
            end

        elseif ~pi1 && pi6
            branch = '[~pi1,pi6]';
            r = r + p;
            u = floor((u-v)/2);
            s = floor(s/2);

        elseif ~pi1 && pi7
            branch = '[~pi1,pi7]';
            r = r - p;
            u = floor((u-v)/2);
            s = floor(s/2);

        elseif ~pi1 && pi8
            branch = '[~pi1,pi8] DUMMY';
            % CORRECTION: r is frozen
            % Original: r = r - s  <-- corrupts result
            r = r;
            u = floor((u-v)/2);
            s = floor(s/2);
        end

        k   = k + 1;
        pi1 = (v > 0);

        if displayLog
            fprintf('%-5d %-6d %-6d %-8d %-8d %-15s\n', ...
                    k, u, v, r, s, branch);
        end
    end

    if displayLog
        fprintf('Final r = %d\n\n', r);
    end
end
