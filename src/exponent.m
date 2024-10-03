nama = input('Masukkan nama bmp: ', 's');
if exist([nama, '.bmp'], 'file') == 0
    error('Tidak ada file dengan nama tersebut');
end

I = imread([nama, '.bmp']);
[M, N, C] = size(I);

c = input('Masukkan c: ');
gamma = input('Masukkan gamma: ');

expo = zeros(M, N, C);
for i = 1 : M
    for j = 1 : N
        for k = 1 : C
            expo(i,j,k) = c * (double(I(i,j,k)) ^ gamma);
        
            if expo(i,j,k) > 255
                expo(i,j,k) = 255;
            elseif expo(i,j,k) < 0
                expo(i,j,k) = 0;
            end
        end
    end
end

expo = uint8(expo);

figure; imshow(I); title('Citra Masukan');
figure; imhist(I); title('Histogram Citra Masukan');
figure; imshow(expo); title('Citra Transformasi Pangkat');
figure; imhist(expo); title('Histogram Citra Transformasi Pangkat')