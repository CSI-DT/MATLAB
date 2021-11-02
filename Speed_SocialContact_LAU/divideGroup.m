function [LeftGroup,RightGroup]= divideGroup(data,IDlist,starttime,endtime)
%Divide group for swedish farm.
newStarttime=append(datestr(datetime(starttime)),' ','10:00:00');
newEndtime=append(datestr(datetime(starttime)),' ','14:00:00');
for ID=1:length(IDlist)
    
Individual_data{ID}=getIndividual(data,IDlist(ID));
individual_interval{ID}=getInterval(Individual_data{ID}, newStarttime, newEndtime);
if mean(individual_interval{ID}.x)<1670 %left side 0.5*3340
   Group(ID)=1;
end
if mean(individual_interval{ID}.x)>1670 %right side
    Group(ID)=2;
end
    end
    
    LeftGroup=IDlist(find(Group==1));
    RightGroup=IDlist(find(Group==2));