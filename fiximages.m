function [source, mask, target] = fiximages(source, mask, target, offset)
    [tar_tblr, src_tblr] = bounds(source, target, offset);
    
    new_mask = zeros(size(target));
    new_src = zeros(size(target));
    
    new_mask(tar_tblr(1):tar_tblr(2), tar_tblr(3):tar_tblr(4), :) = mask(src_tblr(1):src_tblr(2), src_tblr(3):src_tblr(4), :);
    new_src(tar_tblr(1):tar_tblr(2), tar_tblr(3):tar_tblr(4), :) = source(src_tblr(1):src_tblr(2), src_tblr(3):src_tblr(4), :);
    
    source = new_src;
    mask = new_mask;
end

function [tar_tblr, src_tblr] = bounds(source, target, offset)
    src_sz = size(source);
    tar_sz = size(target);

    tar_tblr = [
        max(1, min(tar_sz(1), offset(1) + 1)),
        max(1, min(tar_sz(1), offset(1) + src_sz(1))),
        max(1, min(tar_sz(2), offset(2) + 1)),
        max(1, min(tar_sz(2), offset(2) + src_sz(2)))
    ];

    src_tblr = [
        max(1, min(src_sz(1), 1 - min(0, offset(1)))),
        max(1, min(src_sz(1), tar_sz(1) - max(0, offset(1)))),
        max(1, min(src_sz(2), 1 - min(0, offset(2)))),
        max(1, min(src_sz(2), tar_sz(2) - max(0, offset(2))))
    ];
end