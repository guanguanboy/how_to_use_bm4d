clear all;close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% modifiable parameters
sigma             = 11;      % noise standard deviation given as percentage of the
                             % maximum intensity of the signal, must be in [0,100]
distribution      = 'Gauss'; % noise distribution
                             %  'Gauss' --> Gaussian distribution
                             %  'Rice ' --> Rician Distribution
profile           = 'mp';    % BM4D parameter profile
                             %  'lc' --> low complexity
                             %  'np' --> normal profile
                             %  'mp' --> modified profile
                             % The modified profile is default in BM4D. For 
                             % details refer to the 2013 TIP paper.
do_wiener         = 1;       % Wiener filtering
                             %  1 --> enable Wiener filtering
                             %  0 --> disable Wiener filtering
verbose           = 1;       % verbose mode

estimate_sigma    = 0;       % enable sigma estimation
save_mat          = 0;       % save result to matlab .mat file
variable_noise    = 0;       % enable spatially varying noise
noise_factor      = 3;       % spatially varying noise range: [sigma, noise_factor*sigma]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       MODIFY BELOW THIS POINT ONLY IF YOU KNOW WHAT YOU ARE DOING       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% check parameters
if sigma<=0
	error('Invalid "sigma" parameter: sigma must be greater than zero');
end
if noise_factor<=0
    error('Invalid "noise_factor" parameter: noise_factor must be greater than zero.');
end
estimate_sigma = estimate_sigma>0 || variable_noise>0;

%加载数据
%hsi = 'test/notebook_1ms.mat';
%hsi = 'test/zao_1ms.mat';
hsi = 'test/coffeebox_1ms.mat';
load(hsi); %加载hsi之后会产生两个变量lowlight和label
size(lowlight)
%执行去噪算法
disp('Denoising started');
%[pred_img, sigma_est] = bm4d(lowlight, distribution, (~estimate_sigma)*sigma, profile, do_wiener, verbose);
[pred_img, sigma_est] = bm4d(lowlight, distribution);
%计算预测值
% objective result
ind = lowlight>0;
PSNR = 10*log10(1/mean((label(ind)-pred_img(ind)).^2));
SSIM = ssim_index3d(label*255,pred_img*255,[1 1 1],ind);
fprintf('hsi name: %s', hsi)
fprintf('Denoising completed: PSNR %.2fdB / SSIM %.2f \n', PSNR, SSIM)

% plot historgram of the estimated standard deviation
if estimate_sigma
    helper.visualizeEstMap( label, sigma_est, eta );
end

% show cross-sections
helper.visualizeXsect( label, lowlight, pred_img );
