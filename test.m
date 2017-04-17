clc;
load .\dataset\V23\V.mat;
load .\dataset\V23\V_seg.mat;
volume_index =23;%图像组数目
num=[122,291,164];
for kk=1:3
    slice_index =num(kk);
    %% Our_SVM
    %{
    addpath(genpath('./Our'));
    load ('./Our/OurModelSVM.mat');
    preds = segment_svm(V(:,:,slice_index), V_seg(:,:,slice_index), model_svm, D, params, scaleparams);%分割图像
    figure; visualize_segment(V(:,:,slice_index), preds==1);%可视化
    %}
    %% Our_RF
    %{
    addpath(genpath('./Our'));
    load ('./Our/OurModelRF.mat');
    preds = segment_rf(V(:,:,slice_index), V_seg(:,:,slice_index), model, D, params, scaleparams);%分割图像
    figure; visualize_segment(V(:,:,slice_index), preds==1);%可视化
    %}
    %% Kiros
    %{
    addpath(genpath('./Kiros'));
    load ('./Kiros/KirosModel.mat');
    preds = segment(V(:,:,slice_index), V_seg(:,:,slice_index), model, D, params, scaleparams);%分割图像
    preds(preds>0.5)=1;   preds(preds<0.5)=0;
    figure; visualize_segment(V(:,:,slice_index), preds==1);%可视化
    %}
    %% Threshold
    %{
    level=0.15;%设定阈值
    [preds,Img]=Threshold(V,V_seg,slice_index,level);
    figure;imshow(Img);%可视化
    %}
    %% Hessian
    %{
    addpath('.\Hessian_FrangiFilter');
    level=0.15;%设定阈值
    [preds,Img]=myHessian(V,V_seg,slice_index,level);
    figure;imshow(Img);%可视化
    %}
    %% RegionGrowing
    %{
    
    %{
    %以下三行只执行一次即可
    addpath('.\RegionGrowing');
    V1=bsxfun(@times,V,V_seg./255);
    preds0=regiongrowing(V1,28, [161,259,230]);%区域生长
    %}
    
    [preds,Img] = myRegionGrowing(V,preds0,slice_index);
    figure;imshow(Img);%可视化
    %}
    %% 指标计算
    a=load(['./dataset/Annotations/' num2str(volume_index) '_' num2str(slice_index-1) '.txt']);
    a(:,1)=a(:,1)+1;
    a(:,2)=a(:,2)+1;
    a(:,3)=[];
    TP(kk)=0;%TP
    FN(kk)=0;%FN
    FP(kk)=0;%FP
    TN(kk)=0;%TN
    n(kk)=size(a,1);%被标记的像素点数目
    for i=1:n(kk)
        temp1=a(i,1);% x轴坐标
        temp2=a(i,2);% y轴坐标
        temp3=a(i,3);% 像素点实际属性
        temp4=preds(temp2,temp1);% 像素点预测属性
        %TP
        if temp3==1 && temp4==1
            TP(kk)=TP(kk)+1;% 更新
        end
        %FN
        if temp3==1 && temp4==0
            FN(kk)=FN(kk)+1;% 更新
        end
        %FP
        if temp3==0 && temp4==1
            FP(kk)=FP(kk)+1;% 更新
        end
        %TN
        if temp3==0 && temp4==0
            TN(kk)=TN(kk)+1;% 更新
        end
    end
    Acc(kk)=(TP(kk)+TN(kk))/(TP(kk)+FN(kk)+TN(kk)+FP(kk));
    TPR(kk)=TP(kk)/(TP(kk)+FN(kk));
    FPR(kk)=FP(kk)/(FP(kk)+TN(kk));
    Precision(kk)=TP(kk)/(TP(kk)+FP(kk));
    Fscore(kk)=(2*Precision(kk)*TPR(kk))/(Precision(kk)+TPR(kk));
end

TP0=sum(TP);%TP总
FN0=sum(FN);%FN总
FP0=sum(FP);%FP总
TN0=sum(TN);%TN总
Acc0=(TP0+TN0)/(TP0+FN0+TN0+FP0);%Acc总
TPR0=TP0/(TP0+FN0);%TPR总
FPR0=FP0/(FP0+TN0);%FPR总
Precision0=TP0/(TP0+FP0);%Precision总
Fscore0=(2*Precision0*TPR0)/(Precision0+TPR0);%Fscore总
disp(['单张准确率：' num2str(Acc)])
disp(['单张TPR：' num2str(TPR)])
disp(['单张FPR：' num2str(FPR)])
disp(['单张Fscore：' num2str(Fscore)])
disp(['总准确率：' num2str(Acc0)])
disp(['总TPR：' num2str(TPR0)])
disp(['总FPR：' num2str(FPR0)])
disp(['总Fscore：' num2str(Fscore0)])
