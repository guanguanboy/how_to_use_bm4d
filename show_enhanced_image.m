clear all;close all;

%enhanced_hsi = 'result/1.mat';
%origin_hsi = 'test/coffeebox_1ms.mat';

%enhanced_hsi = 'result/2.mat';
%origin_hsi = 'test/zao_1ms.mat';

enhanced_hsi = 'result/3.mat';
origin_hsi = 'test/notebook_1ms.mat';

load(enhanced_hsi);
load(origin_hsi);
pred_img = enhanced;
% show cross-sections
helper.visualizeXsect( label, lowlight, pred_img );