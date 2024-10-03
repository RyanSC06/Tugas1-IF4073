nama = input('Masukkan nama bmp: ', 's');
if exist([nama, '.bmp'], 'file') == 0
    error('Tidak ada file dengan nama tersebut');
end

I = imread([nama, '.bmp']);
hist = make_histogram(I);

% Perbandingan dengan hasil library
for k = 1 : size(hist,1)
    figure; imhist(I(:, :, k));
    title(sprintf('Histogram Library untuk Channel %d', k));
end



function [hist] = make_histogram(I)
    [M, N, C] = size(I);

    if C == 1
        % Hanya ada 1 channel; citra grayscale
        hist = zeros(1, 256);
    elseif C == 3
        % Ada 3 channel; citra berwarna
        hist = zeros(3, 256);
    end
    
    
    for k = 1 : C
        for i = 1 : M
            for j = 1 : N
                hist(k, (I(i,j,k) + 1)) = hist(k, (I(i,j,k) + 1)) + 1;
            end
        end
    end

    % Membuat histogram secara manual
    for k = 1 : C
        figure; disp = bar(0:255, hist(k, :));
        title(sprintf('Histogram Manual untuk Channel %d', k));
    end
end