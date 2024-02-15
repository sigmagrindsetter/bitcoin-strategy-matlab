function stochCrossingSignal = calculateStochCrossingSignal(stochKToday, stochDToday, stochKYesterday, stochDYesterday, timeDecayFactorStoch)
    % Calculate Stochastic Oscillator crossing signal for today
    stochCrossingToday = sign(stochKToday - stochDToday); % -1 for %K below %D, 1 for %K above %D
    stochCrossingYesterday = sign(stochKYesterday - stochDYesterday);
    
    % time decay to crossing signal
    if stochCrossingToday ~= stochCrossingYesterday
        stochCrossingSignal = timeDecayFactorStoch * stochCrossingToday;
    else
        stochCrossingSignal = stochCrossingToday;
    end
end