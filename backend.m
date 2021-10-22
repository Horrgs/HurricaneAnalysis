hurricane_data = readtable('filtered.csv');
hurricane_data = hurricane_data(:,2:end);
raw_dates = string(hurricane_data.date);
exp = '(^\d{4}(?=(\d{2})*$)|\d{2})';
dates_reg = regexp(raw_dates, exp, 'match');
dates = {};

for i=1:length(dates_reg)
    data = dates_reg{i};
    year = data(1);
    month = data(2);
    day = data(3);
    
    date = sprintf('%s/%s/%s', year, month, day);
    dates(end+1,:) = {date};
end

hurricane_data.date = datetime(dates, 'InputFormat', 'yyy/MM/dd');

test_year = get_hurricane_data_for_year(hurricane_data, 1980);



%classify major hurricanes
major_rows = hurricane_data.maximum_sustained_wind_knots >= 96;
hurricane_data(major_rows, {'status_of_system'}) = {'M'}; %classification for major hurricane

get_hurricane_data(hurricane_data);

function data=get_hurricane_data_for_year(hurricane_data, year)
    filter_exp = hurricane_data.date.Year == year;
    data = hurricane_data(filter_exp,:);
    
end


function data=get_hurricane_data(hurricane_data)
    [redund_val, unique_years] = findgroups(hurricane_data.date.Year);
    for year=1:length(unique_years)
        
        %storm data - includes non-hurricanes

        filter_exp = hurricane_data.date.Year == unique_years(year);
        year_data = hurricane_data(filter_exp,:);
        all_storms = calculate_storm_season_stats(year_data);

        
        
        %HURRICANE DATA - first one, last one, #, # of maj hurricanes,
        %freq, freq of major hurricanes
        
        hurricane_filter =  strcmpi(year_data.status_of_system, 'HU') | strcmpi(year_data.status_of_system, 'M');
        
        hurricane_year_data = year_data(hurricane_filter,:);
        hurricanes = calculate_storm_season_stats(hurricane_year_data);

        %will need to filter out storms from storms that got upgraded to
        %hurricanes or major hurricanes, and likewise major hurricanes from
        %hurricanes.
       
        
        
    end
end


function statistics=calculate_storm_season_stats(season_data)
        [rows, cols] = size(season_data); %get size of data input
        if rows == 0 %there's no data coming to us!
            statistics = {};
            return
        end
        [red_val, storm_id] = findgroups(season_data.id); %finds number of storms or hurricanes in season (depending data passed)
        
        max_storms = red_val(end); %number of storms or hurricanes in the given year.
        
        %diagnose
        season_data(1, {'date'})
       
        
        % get first storm/hurricane
        %get the early storms while avoiding a late running tropical season (e.g. carry over from 2020-2021)
        first_filter = (season_data.date.Month > 1 & season_data.date.Month < 10);
        length(first_filter)
        early_set = season_data(first_filter,:); %get early storms
        [rows, cols] = size(early_set);
        if rows > 1
            early_set = season_data(first_filter,:); %get early storms
            first_storm = early_set(1,:); %get first storm of season
        else
            
            first_storm = season_data(1,:);
        end
            
        
        last_storm = season_data(end,:); %get last storm of season
        
        %get length of hurricane season
        season_len_raw = last_storm.date - first_storm.date;
        time_duration = time2num(season_len_raw, 'days'); %get length of season in days
        
        %presentable hurricane season length
        season_len = caldiff([first_storm.date; last_storm.date]);

        %get frequency of storms/hurricanes
        storm_freq = 1 / (max_storms / time_duration);
        
        %return data
        statistics = {'First Occurance', 'Last Occurance', 'Number of Occurances', 'Season Length', 'Frequency'; 
            first_storm.date, last_storm.date, max_storms, season_len, storm_freq};
end 
