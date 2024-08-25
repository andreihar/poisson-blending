function output = imblend(source, mask, target)

[height, width, channels] = size(target);
output = zeros(height, width, channels);

% for each channel
for c = 1:channels
    % S = sparse(i,j,v) generates a sparse matrix S from the triplets i, j, and v such that S(i(k),j(k)) = v(k). The max(i)-by-max(j) output matrix has space allotted for length(v) nonzero elements.
	% vectors for pixel + 4 neighbours, 5 total
    i = zeros(height * width * 5, 1);
    j = zeros(height * width * 5, 1);
    v = zeros(height * width * 5, 1);
    b = zeros(height * width, 1);
    index = 1;

	% loop over each pixel
    for y = 1:height
        for x = 1:width
			% 2d pix to 1d index
            pixelIndex = sub2ind([height, width], y, x);

			% blend source & targer images
            if mask(y, x) == 1
				% calculate indices of pixel and four neighbours
				indices = [pixelIndex, sub2ind([height, width], max(y-1, 1), x), ...
						sub2ind([height, width], min(y+1, height), x), ...
						sub2ind([height, width], y, max(x-1, 1)), ...
						sub2ind([height, width], y, min(x+1, width))];

				% fill for the sparse matrix
				i(index:index+4) = ones(1, 5) * indices(1);
				j(index:index+4) = indices;
				v(index:index+4) = [4, -1, -1, -1, -1];

				% calculate b using Laplacian of source
				b(pixelIndex) = 4*source(y, x, c) - source(max(y-1, 1), x, c) - ...
								source(min(y+1, height), x, c) - source(y, max(x-1, 1), c) - ...
								source(y, min(x+1, width), c);
                
				index = index + 5;
            else % copy targer
                i(index) = pixelIndex;
                j(index) = pixelIndex;
                v(index) = 1;
                index = index + 1;

                b(pixelIndex) = target(y, x, c);
            end
        end
    end

	% construct matrix & solve
    A = sparse(i(1:index-1), j(1:index-1), v(1:index-1), height*width, height*width);
    x = A \ b;
    output(:, :, c) = reshape(x, [height, width]);
end