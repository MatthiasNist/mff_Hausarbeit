function gen_rnd = unif_random(decimal)
% minimalwertrestwert für w_4: 1- 1e-4
mean_unif = [0 0 0];
sw = 1;
tol = 1;
gen_rnd = zeros(50000, 3); % preallocation
while mean_unif(1) ~= 0.25|| mean_unif(2) ~= 0.25 || mean_unif(3) ~= 0.25...
        || any(sw) > 1 
    w_1 = unifrnd(0.17,0.33, 50000, 3);
    mean_unif(1) = round(mean(w_1(:,1)), decimal); 
    mean_unif(2) = round(mean(w_1(:,2)), decimal);
    mean_unif(3) = round(mean(w_1(:,3)), decimal);
    sw = sum(w_1, 2);
    tol = min(w_1(:)); % geringster Wert den letztlich w_4 dann annimmt
    max(sw)
end 
gen_rnd = w_1;
end