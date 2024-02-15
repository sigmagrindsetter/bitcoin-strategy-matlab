function bitcoinConverted = normalizeTable(data)
    % Check if the data has ',' as decimal separator and ';' as field separator
    if contains(data(1,:), ';')
        % If ';' is detected, assume European CSV format with ',' as decimal separator
        opts = detectImportOptions(data, 'Delimiter', ';');
        data = readtable(data, opts);
        % Convert ',' to '.' in numeric columns and convert to double
        numericColumns = {'Open', 'High', 'Low', 'Close'};
        for col = numericColumns
            if iscell(data.(col{1}))
                data.(col{1}) = strrep(data.(col{1}), ',', '.'); % Replace ',' with '.'
                data.(col{1}) = str2double(data.(col{1})); % Convert to double
            end
        end
    else
        % If ',' as field separator, assume U.S. CSV format with '.' as decimal separator
        data = readtable(data);
    end
    
    % Convert 'Date' column to datetime format
    if ~isdatetime(data.Date)
        try
            data.Date = datetime(data.Date, 'InputFormat', 'MM/dd/yyyy', 'Format', 'yyyy-MM-dd');
        catch
            try
                data.Date = datetime(data.Date, 'InputFormat', 'yyyy-MM-dd', 'Format', 'yyyy-MM-dd');
            catch
                error('Cannot convert Date column to datetime format. Check the format of your Date data.');
            end
        end
    end

    % Sort the table by date 
    data = sortrows(data, 'Date');

    bitcoinConverted = data;
end