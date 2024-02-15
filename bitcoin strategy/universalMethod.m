function [newUSD, newBitcoin] = universalMethod(dailyStrategyIndicator, currentUSD, currentBitcoin, currentBitcoinPrice)

    newUSD = currentUSD;
    newBitcoin = currentBitcoin;
    
    %trading decisions based on the daily strategy indicator
    riskFactor = 1;
    if dailyStrategyIndicator < -0.5
        % Sell Bitcoin 
        sellBitcoinAmount = -riskFactor * dailyStrategyIndicator * currentBitcoin;
        % Don't sell more Bitcoin than currently owned
        sellBitcoinAmount = min(sellBitcoinAmount, currentBitcoin);
        newUSD = currentUSD + sellBitcoinAmount * currentBitcoinPrice;
        newBitcoin = currentBitcoin - sellBitcoinAmount;
    elseif dailyStrategyIndicator > 0.5
        % Buy Bitcoin 
        buyUSDAmount = riskFactor * dailyStrategyIndicator * currentUSD;
        % Don't spend more USD than currently owned
        buyUSDAmount = min(buyUSDAmount, currentUSD);
        newBitcoin = currentBitcoin + buyUSDAmount / currentBitcoinPrice;
        newUSD = currentUSD - buyUSDAmount;
    end
    
end