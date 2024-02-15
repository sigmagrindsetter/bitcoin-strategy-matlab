function [optimalParams, negFinalPortfolioValue] = optimizeParams(indicatorsFile, initialBitcoin, initialUSD)
    % Objective function that calculates the negative final portfolio value
    function negFinalPortfolioValue = optimizationObjective(x)
        timeDecayFactorEMA = x(1);
        timeDecayFactorStoch = x(2);
        weights = x(3:5); 
      
        
        finalPortfolioValue = portfolioCalculator(indicatorsFile, initialBitcoin, initialUSD, weights, timeDecayFactorEMA, timeDecayFactorStoch);
        negFinalPortfolioValue = -finalPortfolioValue; % We minimize this in the optimization
    end

    % Define bounds for the parameters
    lb = [0, 0, 0, 0, 0]; % Lower bounds for time decay factors and weights
    ub = [1, 1, 1, 1, 1]; % Upper bounds for time decay factors and weights


    % Equality constraint to ensure weights sum to 1
    Aeq = [0, 0, 1, 1, 1];
    beq = 1;

    % Adjusted optimization using Genetic Algorithm
options = optimoptions('ga', 'Display', 'iter','MaxTime', 180);
[optimalParams, negFinalPortfolioValue] = ga(@optimizationObjective, 5, [], [], Aeq, beq, lb, ub, [], options);

    % Display the optimal parameters
    disp('Optimal time decay factors and weights:');
    disp(optimalParams);
end