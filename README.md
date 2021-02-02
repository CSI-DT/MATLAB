# MATLAB code library for CSI-DT project
# Author: Keni Ren
# Permission is granted for project internal usage 


List

Basic
	readFAfile.m	FAdata=readFAfile(FAfile) % Read FA file 
	getIndividual.m	Individual_data=getIndividual(FAdata,tag_id) 
	getIndividualTag.m	Individual_data=getIndividualTag(FAdata,tag_string)
	getInterval.m	individual_interval=getInterval(Individual_data, starttime, endtime)
	dscatter.m	hAxes = dscatter(individual_interval, varargin)
