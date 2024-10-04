nama = input('Masukkan nama bmp: ', 's');
if exist([nama, '.bmp'], 'file') == 0
    error('Tidak ada file dengan nama tersebut');
end

I = imread([nama, '.bmp']);
[M, N, C] = size(I);

figure; imshow(I); title('Citra Masukan');
hist = make_histogram(I);

freq_list = zeros(C, size(hist,2));
for k = 1 : size(hist,1)
    for j = 1 : size(hist,2)
        if j == 1
            freq_list(k,j) = hist(k,j) / (M*N);
        else
            freq_list(k,j) = freq_list(k,j-1) + (hist(k,j) / (M*N));
        end
    end
end

new_I = zeros(M, N, C);

for k = 1 : C
    for i = 1 : M
        for j = 1 : N
            new_I(i,j,k) = round(freq_list(k, I(i,j,k)+1) * 255);

            if new_I(i,j,k) > 255
                new_I(i,j,k) = 255;
            elseif new_I(i,j,k) < 0
                new_I(i,j,k) = 0;
            end
        end
    end
end

new_I = uint8(new_I);
figure; imshow(new_I); title('Citra Histogram Diratakan')
hist = make_histogram(new_I);



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