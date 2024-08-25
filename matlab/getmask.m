function mask = getmask(img)
    h = figure;
    imshow(img);
    hold on;
    title({'Left mouse button picks points.', 'Right mouse button picks last point.'});

    x = [];
    y = [];
    but = 1;
    while but == 1
        [xi, yi, but] = ginput(1);
        if but == 1
            x = [x; xi];
            y = [y; yi];
            plot(x, y, 'ro-');
        end
    end
    mask = repmat(poly2mask([x; x(1)], [y; y(1)], size(img, 1), size(img, 2)), [1, 1, 3]);
    hold off;
    close(h);
    drawnow;
end