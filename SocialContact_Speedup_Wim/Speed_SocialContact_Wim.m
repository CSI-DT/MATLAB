%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Speed up version of social contact code 
%
%    FOR DUTCH FARM
%
%    run check tag, remove cows in Dry cow area, filling the missing data, then check the social contact.
%    Seperate the contacts belong to different areas as the keycow posion,
%    set the minimum contact duration threshold in each area.
%    Output: 
%       Group file to save the left/right group IDlist for swedish farm
%       Filled_individual_interval file to save the filling data result
%       result File to save the 'ContactTable','Real_Contact_List_cubic','Real_Contact_List_feed','Real_Contact_List_wholebarn'
%       ContactTable save the tag id, total duration time  and how many cows she had interaction from the whole barn, cubic, feed and alley.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
clc
tic

%% Input

data=readFAfile('E:\Work\Data\wim\FA_20201017T000000UTC');

%IDlist=RightGroup;
starttime='17-Oct-2020 00:00:00';   %GMT TIME. Sweden time need to +2 hours
endtime='17-Oct-2020 23:59:59';
Total_time=seconds(datetime(endtime)-datetime(starttime))+1;

DistThreshold=250;                  %Distance Threshold
realContactThreshold=600;           %Real contact Threshold, 600=10min
load('matrix_area3.mat')            %Area defination



filledIndividualIinterval_FileName='Filled_individual_interval_20201017_WIM.mat';
resultFileName='ContactResult_20201017_WIM.mat';


%% Check tags, divide group
[activeID, BadID,StillID, MovingID]=CheckTags(data);
[MainAreaID,DryAreaID]=removeDryArea(data,MovingID);

IDlist=MainAreaID;

%% Filling missing data
% %%%%%%%%%Fill the missing data for all individuals

for idxID=1:length(IDlist)
    
Individual_data{idxID}=getIndividual(data,IDlist(idxID));
individual_interval{idxID}=getInterval(Individual_data{idxID}, starttime, endtime);
if isempty(individual_interval{idxID})==1
    continue
end
Filled_individual_interval{idxID}=FillingMissingIndividual(individual_interval{idxID},starttime,endtime);
end

save(filledIndividualIinterval_FileName,'Filled_individual_interval');

%load('Filled_individual_interval_20200915.mat');

clear Individual_data 
clear individual_interval
clear data

%% Distance matrix

Pair = nchoosek(1:1:length(IDlist),2);      % find all combinations
P1=zeros(Total_time,2);
P2=zeros(Total_time,2);
P1x=zeros(Total_time,1);
P1y=zeros(Total_time,1);
P2x=zeros(Total_time,1);
P2y=zeros(Total_time,1);
Distance=zeros(Total_time,1);
for idxPairs = 1:length(Pair)
 P1= [Filled_individual_interval{Pair(idxPairs,1)}.x,Filled_individual_interval{Pair(idxPairs,1)}.y];
 P2=[Filled_individual_interval{Pair(idxPairs,2)}.x,Filled_individual_interval{Pair(idxPairs,2)}.y];
 
 P1x(:,idxPairs)=Filled_individual_interval{Pair(idxPairs,1)}.x;
 P1y(:,idxPairs)=Filled_individual_interval{Pair(idxPairs,1)}.y;
 P2x(:,idxPairs)=Filled_individual_interval{Pair(idxPairs,2)}.x;
 P2y(:,idxPairs)=Filled_individual_interval{Pair(idxPairs,2)}.y;
 Distance(:,idxPairs) =sqrt(sum((P1(1:Total_time,:)-P2(1:Total_time,:)).^2,2));
end

[timeframe,PairIdx,v]=find((Distance<=DistThreshold)==1);   %%%%%%%Call Distance Threshold

position1x=P1x(Distance<=DistThreshold);
position1y=P1y(Distance<=DistThreshold);
position2x=P2x(Distance<=DistThreshold);
position2y=P2y(Distance<=DistThreshold);
distanceP1P2=Distance(Distance<=DistThreshold);

%% Summary ContactPair
varNames = {'timeFrameNum','time','pairIdx','pair','Pair_First','Pair_Second','Distance'};
ContactPair=table(timeframe,Filled_individual_interval{1,1}.time(timeframe), PairIdx,Pair(PairIdx,:),[Pair(PairIdx,1),IDlist(Pair(PairIdx,1)),position1x,position1y],[Pair(PairIdx,2),IDlist(Pair(PairIdx,2)),position2x,position2y],distanceP1P2,'VariableNames',varNames);

%% Get Keycow contact tables
 
for idxPairs=1:length(Pair)
contactPairTable=ContactPair(min(find(ContactPair.pairIdx == idxPairs)):max(find(ContactPair.pairIdx == idxPairs)),:);

if(height(contactPairTable)<=1)
    continue
end
    
Keycow{contactPairTable.pair(1,1),contactPairTable.pair(1,2)}=contactPairTable;
Keycow{contactPairTable.pair(1,2),contactPairTable.pair(1,1)}=contactPairTable;
end

%% Put key cow info to Pair First, seprate areas as keycow position
%%%%%Whole barn contact means contact in cubic+feed+alley

for idIdx=1:length(IDlist)
    KeycowContact{idIdx}=cat(1,Keycow{idIdx,:});
    KeycowContactOrdered{1,idIdx}=KeycowContact{idIdx};
    KeycowContactOrdered{1,idIdx}.Pair_First(find(KeycowContact{1,idIdx}.Pair_First(:,1)~=idIdx),:)=KeycowContact{1,idIdx}.Pair_Second(find(KeycowContact{1,idIdx}.Pair_First(:,1)~=idIdx),:);
    KeycowContactOrdered{1,idIdx}.Pair_Second(find(KeycowContact{1,idIdx}.Pair_First(:,1)~=idIdx),:)=KeycowContact{1,idIdx}.Pair_First(find(KeycowContact{1,idIdx}.Pair_First(:,1)~=idIdx),:);
    for i=1:25      % call Area defination, seprate areas as keycow position
        KeycowContactOrdered{1,idIdx}.Area(find((KeycowContactOrdered{1,idIdx}.Pair_First(:,3) >= a(i,1))& (KeycowContactOrdered{1,idIdx}.Pair_First(:,3) <= a(i,2)) &(KeycowContactOrdered{1,idIdx}.Pair_First(:,4) >= a(i,3)) & (KeycowContactOrdered{1,idIdx}.Pair_First(:,4) <= a(i,4))))=i;
    end
    Real_Contact_List_wholebarn{1,idIdx}=KeycowContactOrdered{1,idIdx}(find(KeycowContactOrdered{1,idIdx}.Area>=1),:);
    Real_Contact_List_cubic{1,idIdx}=KeycowContactOrdered{1,idIdx}(find(KeycowContactOrdered{1,idIdx}.Area>=15 & KeycowContactOrdered{1,idIdx}.Area<=25),:);
    Real_Contact_List_feed{1,idIdx}=KeycowContactOrdered{1,idIdx}(find(KeycowContactOrdered{1,idIdx}.Area>=1 & KeycowContactOrdered{1,idIdx}.Area<=14),:);
   
    Contact_List_wholebarn=Real_Contact_List_wholebarn;
    Contact_List_cubic=Real_Contact_List_cubic;
    Contact_List_feed= Real_Contact_List_feed;
 
end
%% Real contact threshold for each area.

for idIdx=1:length(IDlist)
    uniquenum_wholebarn=unique(Real_Contact_List_wholebarn{1,idIdx}.pairIdx);
    uniquenum_cubic=unique(Real_Contact_List_cubic{1,idIdx}.pairIdx);
    uniquenum_feed=unique(Real_Contact_List_feed{1,idIdx}.pairIdx);
  
        for idxPairs=1:length(uniquenum_wholebarn)
            if sum(Real_Contact_List_wholebarn{1,idIdx}.pairIdx==uniquenum_wholebarn(idxPairs))<=realContactThreshold
            Real_Contact_List_wholebarn{1,idIdx}(ismember(Real_Contact_List_wholebarn{1,idIdx}.pairIdx,uniquenum_wholebarn(idxPairs)),:)=[];
            end
        end
        for idxPairs=1:length(uniquenum_cubic)
            if sum(Real_Contact_List_cubic{1,idIdx}.pairIdx==uniquenum_cubic(idxPairs))<=realContactThreshold
            Real_Contact_List_cubic{1,idIdx}(ismember(Real_Contact_List_cubic{1,idIdx}.pairIdx,uniquenum_cubic(idxPairs)),:)=[];
            end
        end
        
        for idxPairs=1:length(uniquenum_feed)
            if sum(Real_Contact_List_feed{1,idIdx}.pairIdx==uniquenum_feed(idxPairs))<=realContactThreshold
            Real_Contact_List_feed{1,idIdx}(ismember(Real_Contact_List_feed{1,idIdx}.pairIdx,uniquenum_feed(idxPairs)),:)=[];
            end
        end
        

end

%% Summary the result

for idxID=1:length(IDlist)
% For each individual, each day, total duration time  and how many cows she had interaction from the whole barn.
Real_Contact_List_wholebarn_duration(idxID)=height(Real_Contact_List_wholebarn{1,idxID});
Real_Contact_List_wholebarn_NumFriends(idxID)=length(unique(Real_Contact_List_wholebarn{1,idxID}.Pair_Second(:,1)));

% For each individual, each day, duration time and how many cows she had interaction when she in cubic areas.
Real_Contact_List_cubic_duration(idxID)=height(Real_Contact_List_cubic{1,idxID});
Real_Contact_List_cubic_NumFriends(idxID)=length(unique(Real_Contact_List_cubic{1,idxID}.Pair_Second(:,1)));

% For each individual, each day, duration time  and how many cows she had interaction when she in feeding.
Real_Contact_List_feed_duration(idxID)=height(Real_Contact_List_feed{1,idxID});
Real_Contact_List_feed_NumFriends(idxID)=length(unique(Real_Contact_List_feed{1,idxID}.Pair_Second(:,1)));


ID1List(idxID,1)=Filled_individual_interval{idxID}.id1(1);      %% Change ID to ID1
end


varNamesContactTable = {'id1','Whole Duration','Whole numFriends','Cubic Duration','Cubic numFriends','Feed Duration','Feed numFriends'};
ContactTable=table(ID1List,Real_Contact_List_wholebarn_duration',Real_Contact_List_wholebarn_NumFriends',Real_Contact_List_cubic_duration',Real_Contact_List_cubic_NumFriends',Real_Contact_List_feed_duration',Real_Contact_List_feed_NumFriends','VariableNames',varNamesContactTable);

save(resultFileName,'ContactTable','Real_Contact_List_cubic','Real_Contact_List_feed','Real_Contact_List_wholebarn','-v7.3','-nocompression');

toc
