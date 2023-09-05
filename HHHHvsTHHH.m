% Let Heads = 1, Tails = 0

% Initialization
ntrials = 10000;
i1111 = zeros(1,ntrials);
i0111 = zeros(1,ntrials);
for t = 1:ntrials
    u = (rand < 0.5); v = (rand < 0.5); w = (rand < 0.5); x = (rand < 0.5); i = 4;
    if(u && v && w && x)
        i1111(t) = i;
    end
    if(~u && v && w && x)
        i0111(t) = i;
    end
    while(i1111(t) == 0)||(i0111(t) == 0)
        u = v; v = w; w = x; x = (rand < 0.5); i = i + 1;
        if(u && v && w && x) && (i1111(t) == 0) % Stops at first HHT
            i1111(t) = i;
        end % if
        if(~u && v && w && x) && (i0111(t) == 0) % Stops at first HTT
            i0111(t) = i;
        end % if
    end % while
end % for
i1111avg = sum(i1111)/ntrials;
i0111avg = sum(i0111)/ntrials;
p1111 = sum(i1111 < i0111)/ntrials;

disp('Probability that HHHH comes before THHH')
disp(p1111)

disp('Probability that THHH comes before HHHH')
disp(1-p1111)