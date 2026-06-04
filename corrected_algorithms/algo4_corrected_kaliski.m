% =========================================================
% Algorithm 4: Corrected Constant-Time Algorithm Based on
% Kaliski's Method
% =========================================================

function r = algo4_corrected_kaliski(p, a, displayLog)
    u = p;  v = a;
    r = 0;  s = 1;
    k = 0;
    n   = ceil(log2(p));
    pi1 = (v > 0);

    if displayLog
        fprintf('\n    Constant_Kaliskis: p=%d, a=%d    \n', p, a);
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
            sigma  = delta + s;     % sigma = r
            s = 2 * s;
            u = floor(u / 2);
            r = sigma;              % r unchanged

        elseif pi1 && pi3
            branch = '[pi1,pi3]';
            delta  = s - r;
            sigma  = delta + r;     % sigma = s
            r = 2 * r;
            v = floor(v / 2);
            s = sigma;              % s unchanged

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

    % Post-loop correction
    % CORRECTION: condition changed from (r > 0) to (r < p)

    if displayLog
        fprintf('Post-loop: r = %d, p = %d\n', r, p);
    end

    if r < p
        delta = r - p;
        sigma = s + p;
        r = 2 * r;
        r = floor(r / 2);      % r effectively unchanged
        s = p;
        
        if displayLog
            fprintf('Post-loop branch: r < p --> r unchanged = %d\n', r);
        end

    else
        delta = r - p;
        sigma = s + p;
        r = 2 * delta;
        r = floor(r / 2);      % r = r - p
        s = p;
        
        if displayLog
            fprintf('Post-loop branch: r >= p --> r reduced = %d\n', r);
        end
    end

    % final result
    r = p - r;

    if displayLog
        fprintf('final r = %d\n', r);
    end
end
