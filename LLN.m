clear
close all

% Initialization
ntrials = 100;
nflips = 30;
EH = nflips*(0.5); % Expected Value of Binomial Distribution
num_H = zeros(1,ntrials);

% Main Loop
for t = 1:ntrials
    totalH = 0;
    for n = 1:nflips
        if(rand < 0.5)
            totalH = totalH + 1;
        end
    end
    num_H(t) = totalH; % Total number of Heads for trial t
end

avg_H = sum(num_H)/ntrials;
diff_H = abs(EH - avg_H);

disp('Sample Average Number of Heads:')
disp(avg_H)

disp('Expected Number of Heads:')
disp(EH)

disp('Difference Between Expected Value and Sample Average:')
disp(diff_H)