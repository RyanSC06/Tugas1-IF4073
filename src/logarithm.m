%function log()
%    nama = input('Masukkan nama bmp: ', 's');
%    if exist([nama, '.bmp'], 'file') == 0
%        error('Tidak ada file dengan nama tersebut');
%    end
%    
%    I = imread([nama, '.bmp']);
%    c = input('Masukkan c: ');
%
%    log_transformed = log_transform(I, c);
%    
%    figure; imshow(I); title('Citra Masukan');
%    figure; imhist(I); title('Histogram Citra Masukan');
%
%    figure; imshow(log_transformed); title('Citra Transformasi Log');
%    figure; imhist(log_transformed); title('Histogram Citra Transformasi Log');
%end



function [log_transformed] = logarithm(I, c)
    % Mengganti nilai setiap pixel dengan rumus di bawah ini
    % Hasil diletakkan dalam log_transformed
    log_transformed = c * log10(double(1 + I));
    log_transformed = uint8(log_transformed);
end