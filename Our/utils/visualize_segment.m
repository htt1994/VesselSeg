function seg = visualize_segment(im, yhat)

    % Compute an image overlay of the annotated pixels
    seg = imoverlay(uint8(im), yhat, [255/255 0/255 221/255]);

    % Visualize the original and segmented image side by side
%% 三张
%     subplot(1,3,1); imshow(uint8(im));
%     subplot(1,3,2); imshow(seg);
%     subplot(1,3,3); imshow(yhat, []) ;
%% 两张
%       subplot(1,2,1); 
% imshow(uint8(im));
%       subplot(1,2,2); 
imshow(seg);
