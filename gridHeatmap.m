function Heatmap=gridHeatmap(individual_interval, grid)
%gridHeatmap creates a heatmap plot coloured by density.
%The barn will be divided grid-by-grid areas 

points=[individual_interval.x individual_interval.y];
minvals =0;
minvals =[0 0];
maxvals =[3340 8738];%Size of the Ladugaarden_Barn

rangevals = maxvals - minvals;
xidx = 1 + round((points(:,1) - minvals(1)) ./ rangevals(1) * (grid-1));
yidx = 1 + round((points(:,2) - minvals(2)) ./ rangevals(2) * (grid-1));
density = accumarray([yidx, xidx], 1, [grid,grid]);  %note y is rows, x is cols

imagesc(density, 'xdata', [minvals(1), maxvals(1)], 'ydata', [minvals(2), maxvals(2)]);
end