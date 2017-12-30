% read_img.m

function img = read_img(path)
    img = imread(path);
    img = (double(img)./255.0-0.5)*2;
    img = imresize(img, [224, 224]);
    if size(img, 3) == 1
        img = repmat(img, 1, 1, 3); 
    end
end