%% =============================训练阶段===================================
% 设置参数
set_params;
params.upsample = [512 512];
params.scansdir = '..\dataset\Scans';
params.masksdir = '..\dataset\Lungmasks';
params.annotsdir ='..\dataset\Annotations';

%特征学习 
[D, X, labels] = run_vessel12(params);%已更改为加载21、22两组图像

%logistic分类器训练
n_folds = 10;
[model, scaleparams] = learn_classifier(X, labels, n_folds);

%% =============================对新图象分割===================================
volume_index = 23;%组数目
[V, V_seg] = load_vessel12(params, volume_index);
slice_index =164;%层数目，分别输入 121+1、290+1、163+1 
preds = segment(V(:,:,slice_index), V_seg(:,:,slice_index), model, D, params, scaleparams);
preds(preds>0.5)=1;
preds(preds<0.5)=0;
visualize_segment(V(:,:,slice_index), preds>0.5);%结果可视化