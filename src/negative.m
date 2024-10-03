nama = input('Masukkan nama bmp: ', 's');
if exist([nama, '.bmp'], 'file') == 0
    error('Tidak ada file dengan nama tersebut');
end

I = imread([nama, '.bmp']);
[M, N, C] = size(I);

neg = zeros(M, N, C);
for i = 1 : M
    for j = 1 : N
        for k = 1 : C
            neg(i,j,k) = 255 - I(i,j,k);
        end
    end
end

neg = uint8(neg);

figure; imshow(I); title('Citra Masukan');
figure; imhist(I); title('Histogram Citra Masukan');
figure; imshow(neg); title('Citra Negatif');
figure; imhist(neg); title('Histogram Citra Negatif')