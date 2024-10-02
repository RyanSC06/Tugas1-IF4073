nama = input('Masukkan nama bmp: ', 's');
if exist([nama, '.bmp'], 'file') == 0
    error('Tidak ada file dengan nama tersebut');
end

I = imread([nama, '.bmp']);
[M, N] = size(I);

c = input('Masukkan c: ');

log_transformed = zeros(M, N);
for i = 1 : M
    for j = 1 : N
        log_transformed(i,j) = c * log10(double(1 + I(i,j)));
    end
end

log_transformed = uint8(log_transformed);

figure; imshow(I); title('Citra Masukan');
figure; imhist(I); title('Histogram Citra Masukan');
figure; imshow(log_transformed); title('Citra Transformasi Log');
figure; imhist(log_transformed); title('Histogram Citra Transformasi Log')