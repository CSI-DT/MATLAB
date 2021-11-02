function [MainAreaID,DryAreaID]=removeDryArea(indata,idlist)
Threshold=8000; %%%%%%%%%%%%%%%%%%%%%%%Threshold, mainbarn max_y=7666
for i=1:length(idlist)
    Individual_data{i}=getIndividual(indata,idlist(i));
    Mean_y{i}=0.5*(max(Individual_data{i}.y)+min(Individual_data{i}.y)); 
end
DryAreavalue=find(cell2mat(Mean_y)>Threshold);
MainAreavalue=find(cell2mat(Mean_y)<Threshold);
MainAreaID=idlist(MainAreavalue,:);
DryAreaID=idlist(DryAreavalue,:);