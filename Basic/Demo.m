%%%GEA CowView System FA Data Reader and Plotting Example
%Keni Ren 2020-06-20

clear all
close all
clc

%% Importing Data
data=readFAfile('D:\work\SLU\PA\Data\FA_20191115T000000UTC.csv');

%%Define the Individual and time
ID=2421875;%id, 2nd column from FA data
starttime='15-Nov-2019 10:00:00';%GMT TIME. Sweden time need to +2 hours
endtime='15-Nov-2019 10:30:00';

Individual_data=getIndividual(data,ID); %Get the individual's data in the table
individual_interval=getInterval(Individual_data, starttime, endtime);%Get the individual's data during the specific period

%% Plot the movement

im_map=imread('Ladugaarden_Barn.jpg');
barn_w=3340;
barn_l=8738;

%%%%%%%%%%%%%%%%%%%Plot where has the individual been%%%%%%%%%%%%%%%%%%%%%%
figure(1);hold on
imagesc([0 barn_w], [0 barn_l], flipud(im_map));%whole barn
scatter(individual_interval.x, individual_interval.y,'.','blue');
set(gca,'ydir','normal');
axis image
hold off


% %%%%%%%%%%%%%%%%%%motion scatter individual trajectory%%%%%%%%%%%%%%%%%%%%%%
% % It will take a while to plot the trajectory, So I comment it for now. :)
% 
% figure(2);hold on
% imagesc([0 barn_w], [0 barn_l], flipud(im_map));%whole barn
% set(gca,'ydir','normal');
% axis image
% for n=1:1:height(individual_interval)
%       scatter(individual_interval.x(n),individual_interval.y(n),'.');drawnow
% end
% hold off
% 

%% Heatmaps
%%%%%%%%%%%%%%%%%% Heatmap plot coloured by density%%%%%%%%%%%%%%%%%%%%
%NOTE: gridHeatmap function is configured for Ladugaarden's size. 

figure(3);
grid=20;%The barn will be divided grid-by-grid areas 
gridHeatmap(individual_interval,grid);
colormap summer
colorbar
set(gca,'ydir','normal')
axis image

%%%%%%%%%%%%Scatterplots with smoothed densities%%%%%%%%%%%%%%%%%%%%%%
%NOTE: dscatter function is configured for Ladugaarden's size. 
figure(4);
dscatter(individual_interval,'plottype', 'image');
colormap jet
colorbar
set(gca,'ydir','normal');
axis image

%% Try motion direction

figure(5)

for n=2:height(individual_interval)
    velocity (n,:)=([individual_interval.x(n),individual_interval.y(n)]-[individual_interval.x(n-1),individual_interval.y(n-1)])/(individual_interval(2,:).time-individual_interval(1,:).time/1000);
    
end

position_x=individual_interval.x;
position_y=individual_interval.y;
u = gradient(position_x);
v = gradient(position_y);
%scale=0;
q=quiver(position_x,position_y,u,v)



