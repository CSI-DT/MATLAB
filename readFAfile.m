
function inall=readFAfile(FAfile)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% readFAfile: read GEA CowView system FA files
% Description: Read in the FA files, Setup the Import Options and import 
% the data, specify the column names to "FA","id", "id1", "time", "x", "y", "z". 
% Print out the file's start time and end time.
% Useage: inall=readFAfile(FAfile);
% Athor: Keni Ren
% Example: data=readFAfile('.\Data\FA_20200915T000000UTC');

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 7);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["FA", "id", "id1", "time", "x", "y", "z"];
opts.VariableTypes = ["categorical", "double", "string", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "id1", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["FA", "id1"], "EmptyFieldRule", "auto");

% Import the data
inall = readtable(FAfile, opts);


start1=datetime(round(min(inall(:,4).time')),'ConvertFrom','epochtime',"TicksPerSecond",1000,'Format','dd-MMM-yyyy HH:mm:ss');
end1=datetime(round(max(inall(:,4).time')),'ConvertFrom','epochtime',"TicksPerSecond",1000,'Format','dd-MMM-yyyy HH:mm:ss');
X=sprintf('The data starts at:%s and end at: %s',start1,end1);
disp(X);

%% Clear temporary variables
clear opts
end