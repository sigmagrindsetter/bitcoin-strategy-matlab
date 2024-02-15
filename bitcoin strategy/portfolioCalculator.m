function finalPortfolioValue = portfolioCalculator(indicatorsFile, initialBitcoin, initialUSD, weights, timeDecayFactorEMA, timeDecayFactorStoch)

    strategyIndicatorsTable = calculateStrategyIndicator(indicatorsFile, weights, timeDecayFactorEMA, timeDecayFactorStoch);
    
    Bitcoin = initialBitcoin;
    USD = initialUSD;
    
    % Iterate the strategy indicators table
    for i = 1:height(strategyIndicatorsTable)
        %strategy indicator for the current day
        dailyIndicator = strategyIndicatorsTable.StrategyIndicator(i);
        
        %current day's Bitcoin price for trading decisions
        currentBitcoinPrice = strategyIndicatorsTable.Close(i);
        
        %trading decisions for the current day using the daily strategy indicator
        [newUSD, newBitcoin] = universalMethod(dailyIndicator, USD, Bitcoin, currentBitcoinPrice);
        
        USD = newUSD;
        Bitcoin = newBitcoin;
    end

    finalBitcoinPrice = strategyIndicatorsTable.Close(end);
    finalPortfolioValue = Bitcoin + USD / finalBitcoinPrice;

    disp(['Training Portfolio Value in Bitcoin: ', num2str(finalPortfolioValue)]);
end