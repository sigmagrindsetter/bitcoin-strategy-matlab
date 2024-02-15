function strategyIndicatorsTable = calculateStrategyIndicator(data, adjustedWeights, timeDecayFactorEMA, timeDecayFactorStoch)
    
    strategyIndicator = zeros(height(data), 1);

    for i = 2:height(data) % Start from the second day
        ema50Today = data.EMA50(i);
        ema50Yesterday = data.EMA50(i-1);
        closePriceToday = data.Close(i);
        closePriceYesterday = data.Close(i-1);
        stochKToday = data.KOscillator(i);
        stochKYesterday = data.KOscillator(i-1);
        stochDToday = data.DOscillator(i);
        stochDYesterday = data.DOscillator(i-1);
        
        % Calculate signals for the current day
        emaCrossingSignal = calculateEMACrossingSignal(ema50Today, closePriceToday, ema50Yesterday, closePriceYesterday, timeDecayFactorEMA);
        stochCrossingSignal = calculateStochCrossingSignal(stochKToday, stochDToday, stochKYesterday, stochDYesterday, timeDecayFactorStoch);
        DSignal = calculateDSignal(stochDToday);
        
        % Apply adjusted weights to signals
        weightEMA = adjustedWeights(1);
        weightStoch = adjustedWeights(2);
        weightD = adjustedWeights(3);
        
        % Calculate combined strategy signal for the current day
        strategyIndicator(i) = round(weightEMA * emaCrossingSignal + weightStoch * stochCrossingSignal + weightD * DSignal, 2);
    end

    % Create a table with dates and daily calculated strategy indicators
    strategyIndicatorsTable = table(data.Date, data.Close, strategyIndicator, 'VariableNames', {'Date', 'Close' 'StrategyIndicator'});
end