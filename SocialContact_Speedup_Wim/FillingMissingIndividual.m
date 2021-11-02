function Filled_individual_interval=FillingMissingIndividual(individual_interval,starttime,endtime)
%  individual_interval=individual_interval{1,41};
%   starttime='15-Nov-2019 12:00:00';%GMT TIME. Sweden time need to +2 hours
%   endtime='15-Nov-2019 12:01:59';

newTimes = [datetime(starttime):seconds(1):datetime(endtime)]';% Set the time using starttime and endtime. 
individual_interval.time=datetime(round((individual_interval.time)),'ConvertFrom','epochtime',"TicksPerSecond",1000,'Format','dd-MMM-yyyy HH:mm:ss');

time=individual_interval.time;
x=individual_interval.x;
y=individual_interval.y;

TT1 = timetable(time,x,y);
TT2 = retime(TT1,newTimes,'mean');% recustruct the timetable, from the starttime to endtime. With no blank at the front or back
%Find the first non-NAN value, fill the begining of missing data the same value
first_non_NaN_index_of_TT2x = find(~isnan(TT2.x), 1);
% [F_x,F] = fillmissing(TT2.x,'movmean',16);
% [F_y,F] = fillmissing(TT2.y,'movmean',16);
F_x(1:first_non_NaN_index_of_TT2x)=TT2.x(first_non_NaN_index_of_TT2x);
F_y(1:first_non_NaN_index_of_TT2x)=TT2.y(first_non_NaN_index_of_TT2x);
[F_x(first_non_NaN_index_of_TT2x:height(TT2)),F(first_non_NaN_index_of_TT2x:height(TT2))]= fillmissing(TT2.x(first_non_NaN_index_of_TT2x:height(TT2)),'makima','EndValues','previous');
[F_y(first_non_NaN_index_of_TT2x:height(TT2)),F(first_non_NaN_index_of_TT2x:height(TT2))] = fillmissing(TT2.y(first_non_NaN_index_of_TT2x:height(TT2)),'makima','EndValues','previous');
Filled_individual_interval = timetable(TT2.time,F_x',F_y');
Filled_individual_interval.Var3(:) = individual_interval.id(1);
Filled_individual_interval.Var4(:) = individual_interval.id1(1);
Filled_individual_interval=timetable2table(Filled_individual_interval);
Filled_individual_interval.Properties.VariableNames = {'time','x','y','id','id1'};
Filled_individual_interval= movevars(Filled_individual_interval, 'id', 'Before', 'time');
Filled_individual_interval= movevars(Filled_individual_interval, 'id1', 'Before', 'time');
Filled_individual_interval.x(Filled_individual_interval.x>3339)=2991;
Filled_individual_interval.y(Filled_individual_interval.y>8737)=7666;
Filled_individual_interval.y(Filled_individual_interval.y<969)=718;
