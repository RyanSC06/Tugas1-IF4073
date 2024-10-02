nama = input('Masukkan nama bmp: ', 's');
if exist([nama, '.bmp'], 'file') == 0
    error('Tidak ada file dengan nama tersebut');
end

I = imread([nama, '.bmp']);
[M, N] = size(I);

a = input('Masukkan a: ');
b = input('Masukkan b: ');

bright = zeros(M, N);
for i = 1 : M
    for j = 1 : N
        bright(i,j) = a * I(i,j) + b;
        
        if bright(i,j) > 255
            bright(i,j) = 255;
        elseif bright(i,j) < 0
            bright(i,j) = 0;
        end
    end
end

bright = uint8(bright);

figure; imshow(I); title('Citra Masukan');
figure; imhist(I); title('Histogram Citra Masukan');
figure; imshow(bright); title('Citra Brightened');
figure; imhist(bright); title('Histogram Citra Brightened')