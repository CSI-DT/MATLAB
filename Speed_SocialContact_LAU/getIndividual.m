function indataID1=getIndividual(indata,id1)

SpecialID_row=find(indata.id==id1);
indataID1=indata(SpecialID_row,:);



end