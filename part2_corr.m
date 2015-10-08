%% Korrelationsmatrix 

% saving vector of companies' names
names_vec = dax_comp_ret_disc.Properties.VariableNames

%correlation matrix of all companies, pairwise:
corr_matrix = corrcoef(table2array(dax_comp_ret_disc),'rows','pairwise')

% => upper triangle-matrix already includes all correlation-coefficients:
corr_matrix_up = triu(corr_matrix)

% collapsing columns of upper triangle-matrix column by column in vector:
corr_vec = corr_matrix_up(corr_matrix_up~=1 & corr_matrix_up~=0)

%test:
length(corr_vec) % = 435 = 30*(29/2) (s. Angabe)

%% plotting histogramm:

n_bins = 20;

hist(corr_vec, n_bins)

% labeling of plot
xlabel('correlation')
ylabel('density')
title('Histogramm of correlation concerning returns of DAX-30s')

hold on

%% displaying pair of highest estimated correlation-coefficient:

% finding the index of the highest correaltion in corr_matrix_up
max_corr = max(corr_vec)
[max_row_index, max_col_index] = find((corr_matrix_up == max_corr))

% test:
corr_matrix_up(max_row_index, max_col_index) == max_corr % TRUE

% displaying the ticker symbols of highest correaltion in histogramm:
max_corr_disp = text(max_corr-0.05, 5, [names_vec(max_row_index), ...
    'gegen', names_vec(max_col_index)], 'interpreter', 'none')
max_corr_disp(1).Color = 'blue';
max_corr_disp(1).FontSize = 7;
