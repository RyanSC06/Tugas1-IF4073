function log()
    nama = input('Masukkan nama bmp: ', 's');
    if exist([nama, '.bmp'], 'file') == 0
        error('Tidak ada file dengan nama tersebut');
    end
    
    I = imread([nama, '.bmp']);
    c = input('Masukkan c: ');

    log_transformed = log_transform(I, c);
    
    figure; imshow(I); title('Citra Masukan');
    figure; imhist(I); title('Histogram Citra Masukan');

    figure; imshow(log_transformed); title('Citra Transformasi Log');
    figure; imhist(log_transformed); title('Histogram Citra Transformasi Log');
end



function [log_transformed] = log_transform(I, c)
    [M, N, C] = size(I);

    % Menyiapkan matriks citra keluaran seukuran I
    log_transformed = zeros(M, N, C);

    % Iterasi setiap nilai pada semua channel matriks I untuk
    % mengganti nilai tersebut dengan rumus di bawah ini.
    % Hasil diletakkan dalam log_transformed
    for i = 1 : M
        for j = 1 : N
            for k = 1 : C
                log_transformed(i,j,k) = c * log10(double(1 + I(i,j,k)));
                
                % OPERASI CLIPPING
                % Nilai pixel yang lebih dari 255 diubah jadi 255
                if log_transformed(i,j,k) > 255
                    log_transformed(i,j,k) = 255;
                % Nilai pixel yang kurang dari 0 diubah jadi 0
                elseif log_transformed(i,j,k) < 0
                    log_transformed(i,j,k) = 0;
                end
            end
        end
    end
    
    log_transformed = uint8(log_transformed);
end