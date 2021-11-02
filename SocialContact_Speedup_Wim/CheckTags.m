%%%%%%%CheckTags%%%%%%%%%%%%%%%%
%Checking tags from whole day FA data
%Find the activeID, still ID, moving ID. Also can find IDs missing a lot of data 
%ActiveID: Unique IDs show up in the data
%BadID: IDs has a lot of data missing. Trheshold is 0.3 means 70% of whole day signal is missing
%GoodID: Remove BadID from activeID.
%StillID: IDs didn't move much.Moving_Threshold  900 means the individual didn't move more than 9 meters along Y axis
%MovingID: Remove the still ID from GoodID

function [activeID, BadID,StillID, MovingID]=CheckTags(indata)
%activeID = unique(indata.id);
[activeID,ia,ic] = unique(indata.id);
a_counts = accumarray(ic,1);
activeID_counts = [activeID, a_counts];
Totaltime=24*60*60;
Threshold=Totaltime*0.3; %%%%%%%%%%%%%%%%%%%%%%%Threshold
Lowvalue=find(activeID_counts(:,2)<Threshold);
BadID=(activeID_counts(Lowvalue,:));
BadID(:,3)=(Totaltime-BadID(:,2))/Totaltime;
GoodID=setdiff(activeID,BadID(:,1));
for i=1:length(activeID)
    Individual_data{i}=getIndividual(indata,activeID(i));
    x_move{i}=max(Individual_data{i}.y)-min(Individual_data{i}.y);
end

x_move=cell2mat(x_move);
activeID_move=[activeID, x_move'];
Moving_Threshold=1800;%How much move along y axis, 500=5m
MoveLowvalue=find(activeID_move(:,2)<Moving_Threshold);
StillID=(activeID_move(MoveLowvalue,:));

%MovingID=setdiff(activeID,StillID);
MovingID=setdiff(GoodID,StillID);

