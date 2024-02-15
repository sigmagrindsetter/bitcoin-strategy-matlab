function emaCrossingSignal = calculateEMACrossingSignal(ema50Today, closePriceToday, ema50Yesterday, closePriceYesterday, timeDecayFactorEMA)
    % Calculate EMA50 and Close crossing signals for today
    emaCrossingToday = sign(ema50Today - closePriceToday); % -1 for EMA20 below Close, 1 for EMA20 above Close
    emaCrossingYesterday = sign(ema50Yesterday - closePriceYesterday);
    
    % time decay after crossing signal
    if emaCrossingToday ~= emaCrossingYesterday
        emaCrossingSignal = timeDecayFactorEMA * emaCrossingToday;
    else
        emaCrossingSignal = emaCrossingToday;
    end
end