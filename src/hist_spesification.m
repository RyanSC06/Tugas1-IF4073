function hist_spesification()
    nama1 = input('Masukkan nama bmp semula: ', 's');
    if exist([nama1, '.bmp'], 'file') == 0
        error('Tidak ada file dengan nama tersebut');
    end
    
    nama2 = input('Masukkan nama bmp acuan: ', 's');
    if exist([nama2, '.bmp'], 'file') == 0
        error('Tidak ada file dengan nama tersebut');
    end
    
    I1 = imread([nama1, '.bmp']);
    figure; imshow(I1); title('Citra Semula');
    I2 = imread([nama2, '.bmp']);
    figure; imshow(I2); title('Citra Acuan');
    
    final_I = specify_histogram(I1, I2);
    figure; imshow(final_I); title('Citra Akhir');
    hist = make_histogram(final_I, "Akhir");
end



function [final_I] = specify_histogram(I1, I2)
    % MENYAMAKAN JUMLAH CHANNEL (DIMENSI)
        % I1 = Citra semula
        % I2 = Citra acuan
    % Kasus citra semula berdimensi lebih rendah daripada citra acuan
    if size(I1,3) < size(I2,3)
        [M, N, ~] = size(I1);
        temp_I1 = zeros(M, N, 3);
        
        % Satu-satunya channel, ditumpuk 3x
        for i = 1 : M
            for j = 1 : N
                for k = 1 : 3
                    temp_I1(i, j, k) = I1(i, j, 1);
                end
            end
        end
        I1 = temp_I1;
    
    % Kasus citra acuan berdimensi lebih rendah daripada citra semula
    elseif size(I1,3) > size(I2,3)
        [M, N, ~] = size(I2);
        temp_I2 = zeros(M, N, 3);
        
        % Satu-satunya channel, ditumpuk 3x
        for i = 1 : M
            for j = 1 : N
                for k = 1 : 3
                    temp_I2(i, j, k) = I2(i, j, 1);
                end
            end
        end
        I2 = temp_I2;
    end
    
    % PERATAAN HISTOGRAM UNTUK KEDUA CITRA
        % change1 adalah sebuah larik yang menunjukkan nilai pixel pada I1 harus 
        % diubah menjadi berapa agar menghasilkan citra yang histogramnya merata
    [new_I1, change1] = equalize_histogram(I1, 1);
    [~, change2] = equalize_histogram(I2, 0);
    
    % MEMBUAT MATRIKS PERUBAHAN AKHIR (INVERS)
    % Menyiapkan matriks kosong seukuran change1
    final_change = zeros(size(change1, 1), size(change1, 2));
    
    % Iterasi setiap nilai pada setiap channel di change1 untuk melihat
    % nilai pada indeks mana di change2, channel yang sama, yang paling
    % mendekati nilai di change1 tersebut. Taruh hasil di final_change
    for k = 1 : size(change1, 1)
        for j = 1 : size(change1, 2)
            minimum = 255;
            idx = 0;
            for l = 1 : size(change2, 2)
                if abs(change1(k,j)-change2(k,l)) < minimum
                    minimum = change1(k,j)-change2(k,l);
                    idx = l;
                end
            end
            
            final_change(k,j) = idx;
        end
    end
    
    % Iterasi new_I1 untuk mengganti setiap nilai pixel dengan nilai 
    % final_change(channel, pixel). Hasil diletakkan di final_I
    [M, N, C] = size(new_I1);
    final_I = zeros(M, N, C);
    
    for k = 1 : C
        for i = 1 : M
            for j = 1 : N
                final_I(i,j,k) = final_change(k, new_I1(i,j,k)+1);
            end
        end
    end
    
    final_I = uint8(final_I);
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