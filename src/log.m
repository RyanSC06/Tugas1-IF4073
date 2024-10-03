nama = input('Masukkan nama bmp: ', 's');
if exist([nama, '.bmp'], 'file') == 0
    error('Tidak ada file dengan nama tersebut');
end

I = imread([nama, '.bmp']);
[M, N, C] = size(I);

c = input('Masukkan c: ');

log_transformed = zeros(M, N, C);
for i = 1 : M
    for j = 1 : N
        for k = 1 : C
            log_transformed(i,j,k) = c * log10(double(1 + I(i,j,k)));

            if log_transformed(i,j,k) > 255
                log_transformed(i,j,k) = 255;
            elseif log_transformed(i,j,k) < 0
                log_transformed(i,j,k) = 0;
            end
        end
    end
end

log_transformed = uint8(log_transformed);

figure; imshow(I); title('Citra Masukan');
figure; imhist(I); title('Histogram Citra Masukan');
figure; imshow(log_transformed); title('Citra Transformasi Log');
figure; imhist(log_transformed); title('Histogram Citra Transformasi Log')