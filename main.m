close all
clear variables

data_dir = './data';
out_dir = './results';

source = imread('./data/source_01.jpg');
mask = imread('./data/mask_01.jpg');
target = imread('./data/target_01.jpg');

offset = [ 210 10 ];

source = im2double(source);
mask = round(im2double(mask));
target = im2double(target);

% Interactive mask
mask = getmask(source);
[source, mask, target] = fiximages(source, mask, target, offset);

output = imblend(source, mask, target);

figure();
imshow(output);
% imwrite(output,sprintf('%s/result_%02d.jpg',out_dir,i),'jpg','Quality',95);