function [sellUSD, sellBitcoin] = mymethod(dailyStrategyIndicator, currentUSD, currentBitcoin)
    sellUSD = 0;
    sellBitcoin = 0;
    riskFactor = 1; 

    if dailyStrategyIndicator < -0.5
        sellBitcoin = -riskFactor * dailyStrategyIndicator * currentBitcoin;
        sellBitcoin = min(sellBitcoin, currentBitcoin); 
    elseif dailyStrategyIndicator > 0.5
        sellUSD = riskFactor * dailyStrategyIndicator * currentUSD;
        sellUSD = min(sellUSD, currentUSD); 
    end
end