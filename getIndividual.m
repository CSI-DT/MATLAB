function indataID1=getIndividual(indata,id1)
%Get the individual data in the table
%id1 is from the 2nd column in FA data 

SpecialID_row=find(indata.id==id1);
indataID1=indata(SpecialID_row,:);

end