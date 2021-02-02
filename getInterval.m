function individual_interval=getInterval(Individual_data, starttime, endtime)
%Function to extract data for a time interval given a certain individual
%Individual_data is the output from function getIndividual
%It can also be used to find all individual's data for the given time period

p_time_start=posixtime(datetime(starttime));
p_time_end=posixtime(datetime(endtime));

getrow=find(vpa(p_time_start)<=vpa((Individual_data.time/1000)) & vpa((Individual_data.time/1000))<=vpa(p_time_end));
individual_interval=Individual_data(getrow,:);



end

