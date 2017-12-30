% train.m
% Author: Taotao
% Time: 20171226

clear;close all;clc
dbstop if error
caffe.reset_all
caffe.set_mode_gpu
caffe.set_device(0)
rng('shuffle')

load('facedata.mat')

solver = caffe.Solver('./models/ressolver.prototxt');
solver.net.copy_from('./models/ResNet.caffemodel');
% solver.net.copy_from('tmp.caffemodel');

max_iter = 1000000;
lr_rate = 0.00003;
batch_size = 5;
gamma = 0.000;
power = 0.75;
alpha = 100;
display = 10;

figure(1);
hold on
for ii = 1:max_iter
    inputs = process_input(dataset, batch_size);
    solver.net.forward({inputs});
    feat = solver.net.blobs('ip1').get_data();
    % feat = reshape(feat, [], batch_size, 3);
    anc = feat(:, 1:batch_size);
    pos = feat(:, batch_size+1:2*batch_size);
    neg = feat(:, 2*batch_size+1:end);
    loss = tripletloss(anc, pos, neg, alpha, batch_size);
    if mod(ii, display) == 0
        fprintf('%d / %d loss:%g\n', ii, max_iter, loss.loss);
        plot(ii, loss.loss, 'rx');
        pause(0.00001)
    end
    %diff = reshape(loss.diff, [], 3*batch_size);
    solver.net.blobs('ip1').set_diff(loss.diff);
    solver.net.backward_prefilled()
    rate_now = lr_rate*(1+ii*gamma).^(-power);
    solver.update(single(rate_now));
end