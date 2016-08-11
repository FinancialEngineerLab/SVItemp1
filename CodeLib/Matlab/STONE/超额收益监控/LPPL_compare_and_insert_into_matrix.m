% INPUT
% x= [tc,m,omega,A,B,C1,C2,squared_error]

function data_matrix = LPPL_compare_and_insert_into_matrix(x, data_matrix)
    
    data_matrix_temp = data_matrix;
    if size(x,2) ~= size(data_matrix,2) 
        error('LPPL_compare_and_insert_into_matrix:����������ά�Ⱥ�ԭʼ���󲻷�')
    end
    sqr_err_list = data_matrix(:,8);
    insert_index =size(find(sqr_err_list < x(8),1));
    if insert_index(1) == 0  %�������Ԫ����С
        for i = 1: size(data_matrix,1)-1
            data_matrix_temp(i+1,:) = data_matrix(i,:); 
        end   
        data_matrix =data_matrix_temp;
        data_matrix(1,:) = x;   
    elseif insert_index(1) < 8 
        data_matrix(insert_index(1)+1,:) = x;   
    end
end