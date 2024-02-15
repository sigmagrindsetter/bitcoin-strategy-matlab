function DSignal = calculateDSignal(stochD)
    DSignal = (stochD - 50) / 50; % Scale %D range to [-1, 1]
end