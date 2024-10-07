function histogram()
    nama = input('Masukkan nama bmp: ', 's');
    if exist([nama, '.bmp'], 'file') == 0
        error('Tidak ada file dengan nama tersebut');
    end
    
    I = imread([nama, '.bmp']);
    hist = make_histogram(I, "(Manual)");
    
    % Perbandingan dengan hasil library
    for k = 1 : size(hist,1)
        figure; imhist(I(:, :, k));
        title(sprintf('Histogram Citra (Library), Channel %d', k));
    end
end



function [hist] = make_histogram(I, customTitle)
    [M, N, C] = size(I);
    
    % Menyiapkan matriks seukuran channel x #pixel_level
    hist = zeros(C, 256);
    
    % Iterasi setiap nilai pixel pada I kemudian nilai pada hist pada
    % channel yang sesuai, pada indeks sesuai dengan nilai pixel I yang
    % sedang disorot, ditambahkan dengan 1
    for k = 1 : C
        for i = 1 : M
            for j = 1 : N
                hist(k, (I(i,j,k) + 1)) = hist(k, (I(i,j,k) + 1)) + 1;
            end
        end
    end
    
    colorCode = ['r', 'g', 'b'];

    % Membuat histogram secara manual
    for k = 1 : C
        if C == 1
            figure; bar(0:255, hist(k, :), 'FaceColor', 'k');
        else
            figure; bar(0:255, hist(k, :), 'FaceColor', colorCode(k));
        end

        title(sprintf('Histogram Citra %s, Channel %d', customTitle, k));
    end
end