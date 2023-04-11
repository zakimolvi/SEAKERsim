function Y = diffSEAKER(t, y, flag, k)
%k = [CTL_growth_constant, CTL_death, target_growth, CTL_kill_rate, carrying_capacity, k];

Y(1) = k(1)*y(1)*(1-y(1)/k(4)) - k(5)*y(1);
Y(2) = k(2)*y(2)*(1-y(2)/k(4)) - (y(1))*exp(-t*k(3)) - k(5)*y(2);
Y=Y'
end
