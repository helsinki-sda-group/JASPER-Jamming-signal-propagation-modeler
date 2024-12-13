% Generate the C/N0 and AGC of the monitors with jamming
% Author(s):            Zhe Yan
% Affiliation           University of Helsinki, Finland
% Last changed date:    2023-5-3
% Email:                zheyan@seu.edu.cn

clear; close all; clc;

load strengthMatrix.mat;
output = strengthMatrix;
[row, col] = size(output);

%% SVN 05
a0 =       26.68;
a1 =       10.44;
b1 =        17.6;
a2 =       1.788;
b2 =     0.07276;
a3 =       3.265;
b3 =      0.2327;
a4 =       0.744;
b4 =      -1.519;
w  =     0.04764;

CNeff_05 = zeros(row, col);
for i = 1:row
    CNeff_05(i,1:3) = output(i,1:3);
    for j = 4:col
        x = output(i,j);
        if(x<-200)
           CNeff_05(i,j) = 44;
        else
            CNeff_05(i,j) = a0 + a1*cos(x*w) + b1*sin(x*w) +... 
                            a2*cos(2*x*w) + b2*sin(2*x*w) + a3*cos(3*x*w) + b3*sin(3*x*w) +... 
                            a4*cos(4*x*w) + b4*sin(4*x*w);
        end
    end
end

%% SVN 23
a0 =       26.26;
a1 =        2.53;
b1 =       18.95;
a2 =      0.3733;
b2 =     -0.3472;
a3 =       0.121;
b3 =       2.138;
w  =     0.04197;

CNeff_23 = zeros(row, col);
for i = 1:row
    CNeff_23(i,1:3) = output(i,1:3);
    for j = 4:col
        x = output(i,j);
        if(x<-200)
           CNeff_23(i,j) = 43;
        else
            CNeff_23(i,j) = a0 + a1*cos(x*w) + b1*sin(x*w) + a2*cos(2*x*w) + b2*sin(2*x*w) + a3*cos(3*x*w) + b3*sin(3*x*w);
        end
    end
end

%% SVN 29
a0 =        20.1;
a1 =      -4.584;
b1 =       24.98;
a2 =       -3.16;
b2 =       6.818;
a3 =       1.201;
b3 =       7.555;
a4 =       2.358;
b4 =       1.765;
w  =     0.04331;

CNeff_29 = zeros(row, col);
for i = 1:row
    CNeff_29(i,1:3) = output(i,1:3);
    for j = 4:col
        x = output(i,j);
        if(x<-200)
           CNeff_29(i,j) = 43;
        else
            CNeff_29(i,j) = a0 + a1*cos(x*w) + b1*sin(x*w) +... 
                            a2*cos(2*x*w) + b2*sin(2*x*w) + a3*cos(3*x*w) + b3*sin(3*x*w) +... 
                            a4*cos(4*x*w) + b4*sin(4*x*w);
        end
    end
end

%% AGC
a0 = 3.3518e+03;
a1 = 2.0240e+03;
b1 = 2.1511e+03;
a2 =   340.8675;
b2 =   -95.3136;
a3 =   321.8784;
b3 =  -161.5942;
a4 =   -50.3259;
b4 =  -224.1211;
w  =     0.0488;

AGC_fitting = zeros(row, col);
for i = 1:row
    AGC_fitting(i,1:3) = output(i,1:3);
    for j = 4:col
        x = output(i,j);
        if(x<-120)
           AGC_fitting(i,j) = 5967;
        elseif(x>-60)
            AGC_fitting(i,j) = 702;
        else
            AGC_fitting(i,j) = a0 + a1*cos(x*w) + b1*sin(x*w) +... 
                               a2*cos(2*x*w) + b2*sin(2*x*w) + a3*cos(3*x*w) + b3*sin(3*x*w) +... 
                               a4*cos(4*x*w) + b4*sin(4*x*w);
        end
    end
end

CNeff_multi2 = [CNeff_05, CNeff_23(:,4:end)];
CNeff_multi3 = [CNeff_05, CNeff_23(:,4:end), CNeff_29(:,4:end)];
CNeff_multi2_AGC = [CNeff_05, CNeff_23(:,4:end), AGC_fitting(:,4:end)];
CNeff_multi3_AGC = [CNeff_05, CNeff_23(:,4:end), CNeff_29(:,4:end), AGC_fitting(:,4:end)];

save('CNeff_05.mat','CNeff_05');
save('CNeff_23.mat','CNeff_23');
save('CNeff_29.mat','CNeff_29');
save('CNeff_multi2.mat','CNeff_multi2');
save('CNeff_multi3.mat','CNeff_multi3');
save('AGC_fitting.mat','AGC_fitting');
save('CNeff_multi2_AGC.mat','CNeff_multi2_AGC');
save('CNeff_multi3_AGC.mat','CNeff_multi3_AGC');

