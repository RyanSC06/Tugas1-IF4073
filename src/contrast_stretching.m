nama = input('Masukkan nama bmp: ', 's');
if exist([nama, '.bmp'], 'file') == 0
    error('Tidak ada file dengan nama tersebut');
end

I = imread([nama, '.bmp']);
[M, N, C] = size(I);

figure; imshow(I); title('Citra Masukan');
hist = make_histogram(I, 0);

new_I = zeros(M, N, C);

for k = 1 : C
    minValue = 0;
    maxValue = 0;

    for j = 1 : size(hist,2)
        if hist(k,j) > 0
            minValue = j-1;
            break;
        end
    end

    for j = size(hist,2) : -1 : 1
        if hist(k,j) > 0
            maxValue = j-1;
            break;
        end
    end

    for i = 1 : M
        for j = 1 : N
            new_I(i,j,k) = 255 * (double(I(i,j,k)) - minValue) / (maxValue - minValue);
        end
    end
end

new_I = uint8(new_I);
figure; imshow(new_I);
title('Citra Kontras Diregangkan');
hist = make_histogram(new_I, 1);




function [hist] = make_histogram(I, out)
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

    % Membuat histogram
    for k = 1 : C
        figure; disp = bar(0:255, hist(k, :));
        
        if out == 0
            title(sprintf('Histogram Citra Masukan, Channel %d', k));
        elseif out == 1
            title(sprintf('Histogram Citra Kontras Diregangkan, Channel %d', k));
        end
    end
end