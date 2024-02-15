function finalPortfolioValue = raport(trainFile, testFile)

    normalizedTrainData = normalizeTable(trainFile);
    trainIndicatorsData = addIndicators(normalizedTrainData);
    normalizedTestData = normalizeTable(testFile);
    testIndicatorsData = addIndicators(normalizedTestData);

    initialBitcoin = 5; 
    initialUSD = 0;

    %training
    [optimizedParams, ~] = optimizeParams(trainIndicatorsData, initialBitcoin, initialUSD);

    timeDecayFactorEMA = optimizedParams(1);
    timeDecayFactorStoch = optimizedParams(2);
    weights = optimizedParams(3:5);

    optimisedIndicatorsTable = calculateStrategyIndicator(testIndicatorsData, weights, timeDecayFactorEMA, timeDecayFactorStoch);

    %testing
    Bitcoin = initialBitcoin;
    USD = initialUSD;
    for i = 1:height(optimisedIndicatorsTable)
        currentRow = optimisedIndicatorsTable(i, :);
        currentBitcoinPrice = currentRow.Close;

        % mymethod daily loop
        dailyStrategyIndicator = currentRow.StrategyIndicator;
        [sellUSD, sellBitcoin] = mymethod(dailyStrategyIndicator, USD, Bitcoin);

        USD = USD + sellBitcoin * currentBitcoinPrice;
        Bitcoin = Bitcoin - sellBitcoin;
        
        Bitcoin = Bitcoin + (sellUSD / currentBitcoinPrice);
        USD = USD - sellUSD;
        
        dateStr = datestr(currentRow.Date, 'dd-mm-yyyy');
        portfolioValueInBTC = Bitcoin + USD / currentBitcoinPrice;
        disp([dateStr ,' : ', num2str(portfolioValueInBTC)]);
    end

    finalPortfolioValue = portfolioValueInBTC;

    disp(['Final Portfolio Value in Bitcoin: ', num2str(finalPortfolioValue)]);

    dates = optimisedIndicatorsTable.Date;
closePrices = optimisedIndicatorsTable.Close;
buySignals = optimisedIndicatorsTable.StrategyIndicator > 0.5;
sellSignals = optimisedIndicatorsTable.StrategyIndicator < -0.5;

%Chart
figure; hold on;
plot(dates, closePrices, 'k', 'LineWidth', 1); 

buyDates = dates(buySignals);
buyPrices = closePrices(buySignals);
scatter(buyDates, buyPrices, 'red', 'filled');

sellDates = dates(sellSignals);
sellPrices = closePrices(sellSignals);
scatter(sellDates, sellPrices, 'green', 'filled');

title('Bitcoin Strategy');
xlabel('Date');
ylabel('Close Price');
legend('Close Price', 'Bid', 'Sell', 'Location', 'best');
grid on;
hold off;

saveas(gcf, 'strategia.jpg');
display(optimisedIndicatorsTable)
end