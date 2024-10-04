nama1 = input('Masukkan nama bmp semula: ', 's');
if exist([nama1, '.bmp'], 'file') == 0
    error('Tidak ada file dengan nama tersebut');
end

nama2 = input('Masukkan nama bmp acuan: ', 's');
if exist([nama2, '.bmp'], 'file') == 0
    error('Tidak ada file dengan nama tersebut');
end

I1 = imread([nama1, '.bmp']);
figure; imshow(I1); title('Citra Semula');
I2 = imread([nama2, '.bmp']);
figure; imshow(I2); title('Citra Acuan');

[new_I1, change1] = equalize_histogram(I1, 1);
[new_I2, change2] = equalize_histogram(I2, 0);

final_change = zeros(size(change1, 1), size(change1, 2));
for k = 1 : size(change1, 1)
    for j = 1 : size(change1, 2)
        minimum = 255;
        idx = 0;
        for l = 1 : size(change2, 2)
            if abs(change1(k,j)-change2(k,l)) < minimum
                minimum = change1(k,j)-change2(k,l);
                idx = l;
            end
        end
        
        final_change(k,j) = idx;
    end
end

[M, N, C] = size(new_I1);
final_I = zeros(M, N, C);

for k = 1 : C
    for i = 1 : M
        for j = 1 : N
            final_I(i,j,k) = final_change(k, new_I1(i,j,k)+1);
        end
    end
end

final_I = uint8(final_I);
figure; imshow(final_I);
hist = make_histogram(final_I, 1);



function [new_I, change_list] = equalize_histogram(I, round)
    hist = make_histogram(I, 0);
    [M, N, C] = size(I);
    
    change_list = zeros(C, size(hist,2));
    for k = 1 : size(hist,1)
        for j = 1 : size(hist,2)
            if j == 1
                change_list(k,j) = hist(k,j) / (M*N);
            else
                change_list(k,j) = change_list(k,j-1) + (hist(k,j) / (M*N));
                
                if round == 1
                    change_list(k,j-1) = floor(change_list(k,j-1) * 255);
                else
                    change_list(k,j-1) = change_list(k,j-1) * 255;
                end
    
                if round == 1 && j == size(hist,2)
                    change_list(k,j) = floor(change_list(k,j) * 255);
                elseif round == 0 && j == size(hist,2)
                    change_list(k,j) = change_list(k,j) * 255;
                end
            end
        end
    end
    
    new_I = zeros(M, N, C);
    
    for k = 1 : C
        for i = 1 : M
            for j = 1 : N
                new_I(i,j,k) = change_list(k, I(i,j,k)+1);
    
                if new_I(i,j,k) > 255
                    new_I(i,j,k) = 255;
                elseif new_I(i,j,k) < 0
                    new_I(i,j,k) = 0;
                end
            end
        end
    end
    
    new_I = uint8(new_I);
end



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

    % Membuat histogram secara manual
    for k = 1 : C
        figure; disp = bar(0:255, hist(k, :));
        
        if out == 0
            title(sprintf('Histogram Citra Masukan, Channel %d', k));
        elseif out == 1
            title(sprintf('Histogram Citra Akhir, Channel %d', k));
        end
    end
end