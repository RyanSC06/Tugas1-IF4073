function hist_equalization()
    nama = input('Masukkan nama bmp: ', 's');
    if exist([nama, '.bmp'], 'file') == 0
        error('Tidak ada file dengan nama tersebut');
    end
    
    I = imread([nama, '.bmp']);
    figure; imshow(I); title('Citra Masukan');
    
    [new_I, ~] = equalize_histogram(I, 1);
    figure; imshow(new_I); title('Citra Histogram Diratakan');
    hist = make_histogram(new_I, "Histogram Diratakan");
end



function [new_I, change_list] = equalize_histogram(I, round)
    if (round == 0)
        hist = make_histogram(I, "Acuan");
    else
        hist = make_histogram(I, "Semula");
    end

    [M, N, C] = size(I);
    
    % Menyiapkan change_list untuk untuk semua channel
    change_list = zeros(C, size(hist,2));

    % Iterasi 
    for k = 1 : size(hist,1)
        for j = 1 : size(hist,2)
            if j == 1
                % Untuk indeks 1, bagi {nilai yang bersesuaian pada histogram} dengan {ukuran citra}
                change_list(k,j) = hist(k,j) / (M*N);
            else
                % Indeks lainnya, tambahkan nilai pada indeks sebelumnya dengan {nilai pada histogram,
                % yang bersesuaian dengan indeks saat ini} dibagi {ukuran citra}
                change_list(k,j) = change_list(k,j-1) + (hist(k,j) / (M*N));
                
                % MEMBEDAKAN ANTARA HASIL PERKALIAN YANG DI-ROUND DAN TIDAK
                    % Jika perlu di-round (citra semula), diterapkan fungsi floor 
                    % ke: hasil perkalian nilai pada indeks sebelumnya dengan 255.
                if round == 1
                    change_list(k,j-1) = floor(change_list(k,j-1) * 255);
                else
                    change_list(k,j-1) = change_list(k,j-1) * 255;
                end
                
                % Menerapkan fungsi floor (jika round==1) untuk nilai pada indeks terakhir
                if round == 1 && j == size(hist,2)
                    change_list(k,j) = floor(change_list(k,j) * 255);
                elseif round == 0 && j == size(hist,2)
                    change_list(k,j) = change_list(k,j) * 255;
                end
            end
        end
    end
    

    % MEMBUAT CITRA YANG HISTOGRAMNYA DIRATAKAN
    % Menyiapkan matriks kosong sesuai dengan ukuran I
    new_I = zeros(M, N, C);
    
    % Mengganti setiap nilai pixel pada I dengan di change_list di channel 
    % yang sesuai, pada indeks sesuai dengan nilai pixel tersebut
    for k = 1 : C
        for i = 1 : M
            for j = 1 : N
                new_I(i,j,k) = change_list(k, I(i,j,k)+1);
                
                % OPERASI CLIPPING
                % Nilai pixel yang lebih dari 255 diubah jadi 255
                if new_I(i,j,k) > 255
                    new_I(i,j,k) = 255;
                % Nilai pixel yang kurang dari 0 diubah jadi 0
                elseif new_I(i,j,k) < 0
                    new_I(i,j,k) = 0;
                end
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