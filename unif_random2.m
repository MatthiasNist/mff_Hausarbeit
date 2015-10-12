function gen_rnd = unif_random2()
% Input:  none
% Output: 50000x3-matrix: 50000 simulations of 3 weights 
sum_unif = 2;
gen_rnd = zeros(50000, 3); % preallocation
for ii = 1:50000
while sum_unif > 1  
    gen_rnd(ii, :) = unifrnd(0.01,1, 3, 1);
    sum_unif = sum(gen_rnd(ii, :), 2);
end
sum_unif = 2; % to enter the while-loop again...
disp(['simulation ' num2str(ii) ' von 50000 fertig']);
end
adj_vec = [0.25, 0.25, 0.25]./(mean(gen_rnd,1)) % for adjusting the means
gen_rnd = [gen_rnd(:,1)*adj_vec(1), gen_rnd(:,2)*adj_vec(2), ...
    gen_rnd(:,3)*adj_vec(3)] %adjusting of the means
end