function [new_I, change_list] = hist_equalization(I, round)
    hist = make_histogram(I);

    [M, N, C] = size(I);
    
    % Menyiapkan change_list dengan 1 baris dan 256 kolom
    change_list = zeros(size(hist,2));

    % ITERASI UNTUK MENGISI CHANGE_LIST
    for j = 1 : size(hist, 2)
        if j == 1
            % Untuk indeks 1, bagi {rerata semua kolom pada indeks yang 
            % bersesuaian (j) pada histogram} dengan {ukuran citra}
            change_list(j) = mean(hist(:, j)) / (M*N);
        else
            % Indeks lainnya, tambahkan nilai pada indeks sebelumnya dengan {rerata 
            % semua kolom dengan indeks j pada histogram} dibagi {ukuran citra}
            change_list(j) = change_list(j - 1) + mean(hist(:, j)) / (M*N);

            % Mengalikan nilai pada indeks sebelumnya dengan 
            % nilai piksel maksimum yang mungkin, yaitu 255
            change_list(j - 1) = change_list(j - 1) * 255;

            % MEMBEDAKAN ANTARA HASIL PERKALIAN YANG DI-ROUND DAN TIDAK
                    % Jika perlu di-round (citra semula), diterapkan fungsi floor 
                    % ke nilai pada indeks sebelumnya di change_list.
            if round == 1
                change_list(j - 1) = floor(change_list(j - 1));
            end
            
            % Menerapkan perkalian dengan 255 untuk nilai pada indeks terakhir
            if j == size(hist, 2)
                change_list(j) = change_list(j) * 255;

                % Menerapkan fungsi floor (jika round==1) untuk nilai pada indeks terakhir
                if round == 1
                    change_list(j) = floor(change_list(j));
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
                new_I(i,j,k) = change_list(I(i,j,k)+1);
                
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
