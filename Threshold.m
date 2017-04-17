function [preds,Img]=Threshold(V,V_seg,slice_index,level)
   I0=V(:,:,slice_index);
   mask=V_seg(:,:,slice_index);
   I=bsxfun(@times,I0,mask./255);%分割肺实质
   preds=double(im2bw(uint8(I),level));%阈值分割
   Img=imoverlay(uint8(I0),preds, [255/255 0/255 221/255]);
end