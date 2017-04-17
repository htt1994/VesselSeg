%% =============================训练阶段===================================
% 设置参数
set_params;
params.scansdir = '../dataset/Scans';%数据路径
params.masksdir = '../dataset/Lungmasks';%数据路径
params.annotsdir ='../dataset/Annotations';%数据路径

% 读取图像，标签值，高斯金字塔
disp('正在读取数据，实现高斯金字塔...')
ntv = 2; %读取几组图像用于训练
V = cell(ntv, 1);
A = cell(ntv, 1);%标签存储
Vlist = cell(ntv, 1);
Vs = [];
for i = 1:ntv
    I = load_vessel12(params, 20+i);
    A{i} = load(sprintf('%s/VESSEL12_%d_Annotations.csv', params.annotsdir, 20+i));
    V{i} = pyramid(I, params);
    Vlist{i} = imagelist(A{i}, params.numscales);
    Vs = [Vs; V{i}];
    clear I;
end

% 提取小块
disp('正在提取图像小块...');
patches = extract_patches(Vs, params);

%利用稀疏自编码器构造字典
disp('正在利用稀疏自编码器训练字典...')
D.mean = mean(patches);
D.codes=train(patches,params);

% 卷积运算
disp('正在图像卷积...')
L = cell(ntv, 1);
for i = 1:ntv
    L{i} = extract_features(V{i}(Vlist{i}), D, params);%只提取被标记层的图像特征
end

% 上采样
disp('正在上采样...')
for i = 1:ntv
    L{i} = upsample(L{i}, params.numscales, params.upsample);
end

% 提取标记点和对应标签值
disp('正在提取标记特征与标签...')
X = []; labels = [];
for i = 1:ntv
    [tr, tl] = convert(L{i}, A{i}, Vlist{i}(params.numscales:params.numscales:end)/params.numscales);
    X = [X; tr];
    labels = [labels; tl];
end

%% 随机森林训练
[X_scale,scaleparams]=standard_my(X);%归一化处理
model_rf = classRF_train(X_scale,labels,500,160);
% %分割测试
% slice_index =164;%图像层数，分别输入 121+1、290+1、163+1 
% disp('正在分割测试图像...')
% preds = segment_rf(V(:,:,slice_index), V_seg(:,:,slice_index), model, D, params, scaleparams);
% disp('正在可视化测试图像...')
% visualize_segment(V(:,:,slice_index), preds==1);


%% 支持向量机分类
disp('正在训练支持向量机分类...')
[X_scale,scaleparams]=standard_my(X);%归一化处理
% [bestacc,bestc,bestg]=SVMcgForClass(labels,X_scale);%网格寻参
% [bestacc,bestc,bestg]=SVMcgForClass(labels,X_scale,-8,1,-8,0,5,0.1,0.1);%网格寻参
% [bestCVaccuarcy,bestc,bestg] = psoSVMcgForClass(labels,X_scale)%粒子群寻参
% [bestCVaccuarcy,bestc,bestg] = gaSVMcgForClass(labels,X_scale)%遗传算法寻参
model_svm = svmtrain(labels,X_scale,'-c 1  -g 0.003  -v 10 -q');%十折交叉验证
model_svm = svmtrain(labels,X_scale,'-c 1 -g 0.003 -b 1  -q');%根据最佳参数值，输出分类模型

%% ===========================在新图像上实验=================================
%读取图像
volume_index =23;%图像组数目
disp('正在读取测试图像...')
[V, V_seg] = load_vessel12(params, volume_index);
%加噪声处理
% V=double(imnoise(uint8(V),'salt & pepper',0.02));%加椒盐噪声
% V=double(imnoise(uint8(V),'gaussian'));%加高斯噪声
% V=double(imnoise(uint8(V1),'poisson'));%加泊松噪声
% V=double(imnoise(uint8(V1),'speckle'));%加乘性噪声
% 显示污染的图像，需要更改上面代码中“V”为“V1”or“V2”
% subplot(1,2,1),imshow(uint8(V(:,:,200))),title('原图像')
% subplot(1,2,2),imshow(uint8(V1(:,:,200))),title('被椒盐噪声污染的图像')
% subplot(1,3,3),imshow(uint8(V2(:,:,200))),title('被高斯噪声污染的图像')
%分割图像
slice_index =164;%图像层数，分别输入 121+1、290+1、163+1 
disp('正在分割测试图像...')
preds = segment_svm(V(:,:,slice_index), V_seg(:,:,slice_index), model_svm, D, params, scaleparams);
disp('正在可视化测试图像...')
visualize_segment(V(:,:,slice_index), preds==1);

%% =============================准确率统计===================================
% load dec_values.mat;
% dec=reshape(dec_values(:,2),512,512);
% a=load(['E:/Strange/SRTP.10/codes/dataset/Annotations/' num2str(volume_index) '_' num2str(slice_index-1) '.txt']);
% a(:,1)=a(:,1)+1;
% a(:,2)=a(:,2)+1;
% a(:,3)=[];
% count=0;
% n=size(a,1);
% % labels0=[];
% % dec_values0=[];
% for i=1:n
%     temp1=a(i,1);
%     temp2=a(i,2);
%     temp3=a(i,3);
%     temp4=preds(temp2,temp1);
% %     labels0=[labels0;temp4];
% %     temp5=dec(temp2,temp1);
% %     dec_values0=[dec_values0;temp5];
%     if temp3==temp4
%         count=count+1;
%     end
% end
% acc = count / n  %准确率

%ROC曲线
% dec_values0;
% labels0;
% [XX,YY,THRE,AUC] = perfcurve(labels0,dec_values0,'1');
% AUC   %求AUC
% % YY1=smooth(YY,30);%光滑处理
% figure;
% plot(XX,YY,'*');%输出ROC曲线




