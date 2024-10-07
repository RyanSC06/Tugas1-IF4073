%function negative()
%    nama = input('Masukkan nama bmp: ', 's');
%    if exist([nama, '.bmp'], 'file') == 0
%        error('Tidak ada file dengan nama tersebut');
%    end
%    
%    I = imread([nama, '.bmp']);
%    figure; imshow(I); title('Citra Masukan');
%    figure; imhist(I); title('Histogram Citra Masukan');
%    
%    neg = negative_transform(I);
%    figure; imshow(neg); title('Citra Negatif');
%    figure; imhist(neg); title('Histogram Citra Negatif');
%end



function [neg] = negative(I)
    % Mengganti nilai pada setiap pixel dengan rumus di bawah ini
    neg = 255 - I;
    neg = uint8(neg);
end