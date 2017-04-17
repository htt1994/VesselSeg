function [preds,Img]=myHessian(V,V_seg,slice_index,level)
Options.FrangiScaleRange=[0.9 3]; % The range of sigmas used, default [1 8]
Options.FrangiScaleRatio=0.5; % Step size between sigmas, default 2
Options.BlackWhite=false; % Detect black ridges (default) set to true, for white ridges set to false.
Options.FrangiBetaOne =1.5;% Frangi correction constant, default 0.5
Options.FrangiBetaTwo =12;% Frangi correction constant, default 15
I0=V(:,:,slice_index);
mask=V_seg(:,:,slice_index);
I=bsxfun(@times,I0,mask./255);%分割肺实质
I=FrangiFilter2D(I,Options);%血管增强
I=Normalize(I);
% subplot(1,2,1);imshow(uint8(I0));
% level=0.15;%阈值设定
preds=double(im2bw(uint8(I),level));%阈值分割
%显示阈值方法分割的图像
Img=imoverlay(uint8(I0),preds, [255/255 0/255 221/255]);
% subplot(1,2,2);imshow(Img);
end