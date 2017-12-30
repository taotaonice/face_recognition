% process_input.m

function inputs = process_input(dataset, batch_size)
    inputs = zeros(batch_size*3, 224, 224, 3);
    for ii = 1:batch_size
        pick = randi(length(dataset), 1);
        d_pick = pick;
        while d_pick == pick
            d_pick = randi(length(dataset), 1);
        end
        data = dataset(pick);
        rdp = randperm(data.num, 2);
        inputs(ii, :, :, :) = data_argu(read_img(data.pic(rdp(1)).path));
        inputs(ii+1*batch_size, :, :, :) = data_argu(read_img(data.pic(rdp(2)).path));
        data = dataset(d_pick);
        rdp = randi(data.num, 1);
        inputs(ii+2*batch_size, :, :, :) = data_argu(read_img(data.pic(rdp).path));
    end
    % permute RGB to BGR
    inputs = inputs(:, :, :, [3, 2, 1]);
    % permute H W
    inputs = permute(inputs, [3, 2, 4, 1]);
end