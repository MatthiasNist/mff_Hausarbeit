function gen_rnd = unif_random(decimal)
% minimalwertrestwert für w_4: 1- 1e-4
mean_unif_aft_del = [0 0 0];
mean_unif_bev_del = [0 0 0];
mean_unif = [0 0 0];
sw = 1;
tol = 1;
size_del = 50000
gen_rnd = []
%gen_rnd = zeros(50000, 3); %preallocation
while mean_unif_aft_del(1) ~= 0.25|| mean_unif_aft_del(2) ~= 0.25 || mean_unif_aft_del(3) ~= 0.25...
        || size_del > 0 %any(sw) > 1 - tol
    w_1 = unifrnd(0,0.5, size_del, 3);
    mean_unif_bef_del(1) = round(mean(w_1(:,1)), decimal); 
    mean_unif_bef_del(2) = round(mean(w_1(:,2)), decimal);
    mean_unif_bef_del(3) = round(mean(w_1(:,3)), decimal);
    sw = sum(w_1, 2);
    size_del = size(w_1(sw > 1, :), 1) % zu löschende Zeilen, da > 1
    w_1(sw > 1, :) = []
    size_akt = size(w_1, 1)
    %tol = min(w_1(:)); % geringster Wert den letztlich w_4 dann annimmt
    %max(sw)
    mean_unif_aft_del(1) = round(mean(w_1(:,1)), decimal); 
    mean_unif_aft_del(2) = round(mean(w_1(:,2)), decimal);
    mean_unif_aft_del(3) = round(mean(w_1(:,3)), decimal);
    test = mean_unif_bef_del/mean_unif_aft_del
    w_1 = w_1 * test
    mean_unif(1) = round(mean(w_1(:,1)), decimal); 
    mean_unif(2) = round(mean(w_1(:,2)), decimal);
    mean_unif(3) = round(mean(w_1(:,3)), decimal);
    gen_rnd = [gen_rnd; w_1]
end 
gen_rnd = w_1;
end

