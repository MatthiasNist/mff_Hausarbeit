function gen_rnd = unif_random(tol)
while (m_1 || m_2 || m_3 ~= (0.25 + tol)) || sw > (1 - tol)
    w_1 = unifrnd(0,0.5, 50000, 1);
    w_2 = unifrnd(0,0.5, 50000, 1);
    w_3 = unifrnd(0,0.5, 50000, 1);
    m_1 = mean(w_1);
    m_2 = mean(w_2);
    m_3 = mean(w_3);
    sw = m_1 + m_2 + m_3;
end 
gen_rnd = [w_1; w_2; w_3;]
end