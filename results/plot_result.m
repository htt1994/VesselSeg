clear;clc;

%乘性噪声
Var=0:0.05:0.5;
res=load('result_speckle.txt');   % sp-acc(svm)
% res=load('Fspeckle.txt');         % sp-F-score(svm)
% res=load('FspeckleRF.txt');       % sp-F-score(rf)

%高斯噪声
% Var=0:0.005:0.03;
% res=load('result_gaussian.txt');  % ga-acc(svm)
% res=load('Fgaussian.txt');        % ga-F-score(svm)
% res=load('FgaussianRF.txt');      % ga-F-score(rf)

Ours  = res(:,1);
Kiros = res(:,2);
Threshold = res(:,3);
Hessian = res(:,4);
RegionGrowing = res(:,5);
plot(Var,Ours,'kd-',Var,Kiros,'ro-',Var,Threshold,'b.-',Var,Hessian,'gs-',Var,RegionGrowing,'yh-');
legend('本文方法','Kiros','Threshold ','Hessian','RegionGrowing')
xlabel('Var');
ylabel('F-score');
% ylabel('Acc');

% print('-r500','-djpeg',[sprintf('%02d',2)])%保存图片