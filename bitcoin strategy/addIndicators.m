function bitcoinIndicators = addIndicators(data)

    numericColumns = {'High', 'Low', 'Open', 'Close'};
    for col = numericColumns
        if iscell(data.(col{1}))
            data.(col{1}) = str2double(strrep(data.(col{1}), ',', '.'));
        else
            data.(col{1}) = double(data.(col{1}));
        end
    end

    closePrices = data.Close;
    
    % Calculate the 50-day Exponential Moving Average (EMA50)
    ema50 = movavg(closePrices, 'exponential', 50);
    % Calculate the 5-day Stochastic Oscillator (SO5)
    stoch = stochosc(data.High, data.Low, closePrices, 5, 3);
    % Extract %K and %D from the stoch matrix
    stochK = stoch(:, 1); % %K values
    stochD = stoch(:, 2); % %D values
    % Round the calculated indicators to two decimal places
    ema50 = round(ema50, 2);
    stochK = round(stochK, 2);
    stochD = round(stochD, 2);

    % Create a new table with EMA50, %K, and %D alongside original data
    bitcoinIndicators = addvars(data, ema50, stochK, stochD, 'After', 'Close', 'NewVariableNames', {'EMA50', 'KOscillator', 'DOscillator'});
end