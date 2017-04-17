function [data_scale,ps] = scaleForSVM(data,ymin,ymax)
%%
if nargin < 3
    ymin = 0;
    ymax = 1;
end
if nargin < 2
    test_data = data;
end
%%
[mdata,ndata] = size(data);
[data_scale,ps] = mapminmax(data',ymin,ymax);
data_scale = data_scale';
data_scale = data_scale(1:mdata,:);
