function [final_I] = hist_specification(I1, I2)
    % final_I = imhistmatch(I1, I2);
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
    [new_I1, change1] = hist_equalization(I1, 1);
    [~, change2] = hist_equalization(I2, 0);

    % MEMBUAT MATRIKS PERUBAHAN AKHIR (INVERS)
    % Menyiapkan matriks kosong seukuran change1
    final_change = zeros(size(change1, 1));

    % Iterasi setiap nilai pada setiap channel di change1 untuk melihat
    % nilai pada indeks mana di change2, channel yang sama, yang paling
    % mendekati nilai di change1 tersebut. Taruh hasil di final_change
    for j = 1 : size(change1, 1)
        minimum = 255;
        idx = 0;
        for l = 1 : size(change2, 1)
            currDist = abs(change1(j) - change2(l));
            if currDist < minimum
                minimum = currDist;
                idx = l;
            end
        end

        final_change(j) = idx;
    end

    % Iterasi new_I1 untuk mengganti setiap nilai pixel dengan nilai 
    % final_change(channel, pixel). Hasil diletakkan di final_I
    [M, N, C] = size(new_I1);
    final_I = zeros(M, N, C);

    for k = 1 : C
        for i = 1 : M
            for j = 1 : N
                final_I(i,j,k) = final_change(new_I1(i,j,k)+1);
            end
        end
    end

    final_I = uint8(final_I);
end
