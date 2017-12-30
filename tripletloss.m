% tripletloss.m

function loss = tripletloss(anc, pos, neg, alpha, batch_size)
    loss.loss = 0;
    loss.diff = zeros(size(anc, 1), batch_size*3);
    lap = sum((anc-pos).^2, 1); % 1xn
    lan = sum((anc-neg).^2, 1);
    rloss = lap-lan+alpha; % 1xn
    ls = max(rloss, 0);
    loss.loss = sum(ls)./batch_size;
    
    loss.diff(:, 1:batch_size) = 2*(neg-pos);
    loss.diff(:, batch_size+1:2*batch_size) = -2*(anc-pos);
    loss.diff(:, 2*batch_size+1:end) = 2*(anc-neg);
    pick = ls < 0;
    loss.diff(pick, :) = 0;
    loss.diff = loss.diff./batch_size;
end