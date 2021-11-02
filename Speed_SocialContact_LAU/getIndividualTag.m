function indataID1=getIndividualTag(indata,id1)

SpecialID_row=find(indata.id1==id1);
indataID1=indata(SpecialID_row,:);



end