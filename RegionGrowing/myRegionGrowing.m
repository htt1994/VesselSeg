function [preds,Img]=myRegionGrowing(V,preds0,slice_index)
preds=1- preds0(:,:,slice_index);
Img=imoverlay(uint8(V(:,:,slice_index)),preds, [255/255 0/255 221/255]);
end
