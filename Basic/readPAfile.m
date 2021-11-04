function inall=readPAfile(PAfile)
%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 10);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["PA", "id", "id1", "timeStart","timeEnd", "x", "y", "z","activityType","distance"];
opts.VariableTypes = ["categorical", "double", "string", "double","double", "double", "double", "double","double","double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "id1", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["PA", "id1"], "EmptyFieldRule", "auto");

% Import the data
inall = readtable(PAfile, opts);


start1=datetime(round(min(inall(:,4).timeStart')),'ConvertFrom','epochtime',"TicksPerSecond",1000,'Format','dd-MMM-yyyy HH:mm:ss');
end1=datetime(round(max(inall(:,5).timeEnd')),'ConvertFrom','epochtime',"TicksPerSecond",1000,'Format','dd-MMM-yyyy HH:mm:ss');
X=sprintf('The data starts at:%s and end at: %s',start1,end1);
disp(X);

%% Clear temporary variables
clear opts
end