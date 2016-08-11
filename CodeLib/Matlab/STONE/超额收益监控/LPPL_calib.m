

% INPUT: m, omega, tc�������ޣ��Լ�ԭʼ����
% OUTPUT: ���Ż��Ľ� �Լ���С����ʮ��·�����������ٷ��Ļ���


function [sol,min_sqr_err_ten_paths]  = LPPL_calib(m_lower,m_upper,omega_lower,omega_upper,tc_lower,tc_upper, idx_series,algorithm_sel)
    min_sqr_err_ten_paths = ones(10,8)*10;
    sol = ones(8,1); %[tc,m,omega,A,B,C1,C2,squared_error]
    sol(8) = 1000000;
    if algorithm_sel == 1%������ٷ����м���  
        [sol,min_sqr_err_ten_paths] = LPPL_calib_brute_force(sol,min_sqr_err_ten_paths, m_lower,m_upper,omega_lower,omega_upper,tc_lower,tc_upper, idx_series);
    else if algorithm_sel == 2   %����fmincon�����������
            [sol,min_sqr_err_ten_paths]  = LPPL_calib_fmincon(sol,m_lower,m_upper,omega_lower,omega_upper,tc_lower,tc_upper, idx_series);
        else
            msgbox('Ŀǰ��Ϸ���ֻ����ٷ���fmincon����','��Ϣ��ʾ');
        end
    end
  
end


function [sol,min_sqr_err_ten_paths]  = LPPL_calib_fmincon(sol,m_lower,m_upper,omega_lower,omega_upper,tc_lower,tc_upper, idx_series)

   [x, ~] = fmincon(@(x)LPPL_squared_error_compute_fmincon(x, idx_series), [(tc_lower ...
            + tc_upper) / 2, (m_lower + m_upper) / 2, (omega_lower + ...
            omega_upper) / 2], [], [], [], [], [tc_lower, m_lower,...
            omega_lower], [tc_upper, m_upper, omega_upper]);
        
    sol(1) = round(x(1)); % tc
    sol(2) = x(2); % m
    sol(3) = x(3); % omega

    [sol(4),sol(5),sol(6),sol(7),y] = LPPL_get_linear_param(idx_series, sol(1), sol(2), sol(3));
    sol(8) = sum((y - log(idx_series)).^2);
    min_sqr_err_ten_paths = 0; % fmincon�޷��ṩ����Ϣ
end



% ����ٷ������
function [sol,min_sqr_err_ten_paths] = LPPL_calib_brute_force(sol,min_sqr_err_ten_paths,m_lower,m_upper,omega_lower,omega_upper,tc_lower,tc_upper, idx_series)

for m = m_lower:0.01:m_upper
        for omega = omega_lower:0.1:omega_upper
            for tc = tc_lower: 1: tc_upper
                %[ squared_error, A, B, C1, C2 ] = LPPL_squared_error_compute(IndexSeries(:,4), tc, m, omega);
                [ squared_error, A, B, C1, C2 ] = LPPL_squared_error_compute(idx_series, tc, m, omega);
                sol_temp = [tc,m,omega,A,B,C1,C2,squared_error];
                if(sol(8) > squared_error)
                    sol = sol_temp;
                end
                min_sqr_err_ten_paths = LPPL_compare_and_insert_into_matrix(sol_temp,min_sqr_err_ten_paths); 
             end
        end
end
end


