function contrast_stretching()
    nama = input('Masukkan nama bmp: ', 's');
    if exist([nama, '.bmp'], 'file') == 0
        error('Tidak ada file dengan nama tersebut');
    end
    
    I = imread([nama, '.bmp']);
    figure; imshow(I); title('Citra Masukan');
    
    new_I = stretch_contrast(I);
    figure; imshow(new_I);
    title('Citra Kontras Diregangkan');
    hist = make_histogram(new_I, "Kontras Diregangkan");
end



function [new_I] = stretch_contrast(I)
    % Membuat histogram dari I
    hist = make_histogram(I, "Masukan");

    % Mempersiapkan matriks citra keluaran seukuran I
    [M, N, C] = size(I);
    new_I = zeros(M, N, C);
    
    % ITERASI CHANNEL
    for k = 1 : C
        % Menemukan nilai pixel maksimum dan minimum
        % di setiap channel, yang jumlahnya != 0
        minValue = 0;
        maxValue = 0;
    
        for j = 1 : size(hist,2)
            if hist(k,j) > 0
                minValue = j-1;
                break;
            end
        end
    
        for j = size(hist,2) : -1 : 1
            if hist(k,j) > 0
                maxValue = j-1;
                break;
            end
        end
        
        % Iterasi baris dan kolom untuk mengganti nilai pada I
        % dengan nilai yang didapat dari rumus di bawah ini
        % Hasil disimpan di new_I
        for i = 1 : M
            for j = 1 : N
                new_I(i,j,k) = 255 * (double(I(i,j,k)) - minValue) / (maxValue - minValue);
            end
        end
    end

    new_I = uint8(new_I);
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