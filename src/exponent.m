function exponent()    
    nama = input('Masukkan nama bmp: ', 's');
    if exist([nama, '.bmp'], 'file') == 0
        error('Tidak ada file dengan nama tersebut');
    end
    
    I = imread([nama, '.bmp']);
    c = input('Masukkan c: ');
    gamma = input('Masukkan gamma: ');

    figure; imshow(I); title('Citra Masukan');
    figure; imhist(I); title('Histogram Citra Masukan');
    
    expo = exponent_transform(I, c, gamma);
    figure; imshow(expo); title('Citra Transformasi Pangkat');
    figure; imhist(expo); title('Histogram Citra Transformasi Pangkat');
end



function [expo] = exponent_transform(I, c, gamma)
    [M, N, C] = size(I);

    % Menyiapkan matriks citra keluaran seukuran I
    expo = zeros(M, N, C);
    
    % Iterasi setiap nilai pada semua channel matriks I untuk
    % mengganti nilai tersebut dengan rumus di bawah ini.
    % Hasil diletakkan dalam expo
    for i = 1 : M
        for j = 1 : N
            for k = 1 : C
                expo(i,j,k) = c * (double(I(i,j,k)) ^ gamma);
                
                % OPERASI CLIPPING
                % Nilai pixel yang lebih dari 255 diubah jadi 255
                if expo(i,j,k) > 255
                    expo(i,j,k) = 255;
                % Nilai pixel yang kurang dari 0 diubah jadi 0
                elseif expo(i,j,k) < 0
                    expo(i,j,k) = 0;
                end
            end
        end
    end
    
    expo = uint8(expo);
end