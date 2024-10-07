function negative()
    nama = input('Masukkan nama bmp: ', 's');
    if exist([nama, '.bmp'], 'file') == 0
        error('Tidak ada file dengan nama tersebut');
    end
    
    I = imread([nama, '.bmp']);
    figure; imshow(I); title('Citra Masukan');
    figure; imhist(I); title('Histogram Citra Masukan');
    
    neg = negative_transform(I);
    figure; imshow(neg); title('Citra Negatif');
    figure; imhist(neg); title('Histogram Citra Negatif');
end



function [neg] = negative_transform(I)
    [M, N, C] = size(I);
    
    % Menyiapkan matriks citra keluaran seukuran I
    neg = zeros(M, N, C);

    % Iterasi setiap nilai pada semua channel matriks I untuk
    % mengganti nilai tersebut dengan rumus di bawah ini.
    % Hasil diletakkan dalam neg
    for i = 1 : M
        for j = 1 : N
            for k = 1 : C
                neg(i,j,k) = 255 - I(i,j,k);
            end
        end
    end
    
    neg = uint8(neg);
end