nama = input('Masukkan nama bmp: ', 's');
if exist([nama, '.bmp'], 'file') == 0
    error('Tidak ada file dengan nama tersebut');
end

I = imread([nama, '.bmp']);
[M, N, C] = size(I);

negative = zeros(M, N, C);
for i = 1 : M
    for j = 1 : N
        for k = 1 : C
            negative(i,j,k) = 255 - I(i,j,k);
        end
    end
end

negative = uint8(negative);

figure; imshow(I); title('Citra Masukan');
figure; imhist(I); title('Histogram Citra Masukan');
figure; imshow(negative); title('Citra Negatif');
figure; imhist(negative); title('Histogram Citra Negatif')