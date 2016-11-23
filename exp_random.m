function gen_rnd = exp_random(decimal)
% minimalwertrestwert für w_4: 1- 1e-4
mean_exp = [0 0 0];
sw = zeros(50000, 1);
gen_rnd = zeros(50000, 3); % preallocation
while mean_exp(1) ~= 0.25|| mean_exp(2) ~= 0.25 || mean_exp(3) ~= 0.25...
        || any(sw) > 1 
    w_1 = exprnd(0.254, 50000, 3); % mean: 0.2493
    w_1(w_1 > 1) = 1;
    mean_exp(1) = round(mean(w_1(:,1)), decimal); 
    mean_exp(2) = round(mean(w_1(:,2)), decimal);
    mean_exp(3) = round(mean(w_1(:,3)), decimal);
    sw = sum(w_1, 2);
    mean_exp
end 
gen_rnd = w_1;
end