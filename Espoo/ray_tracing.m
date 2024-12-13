% Ray-tracing simulator to generate the jamming strengths at each
% monitoring receiver based on the city grid.
% Author(s):            Zhe Yan
% Affiliation           University of Helsinki, Finland
% Last changed date:    2023-10-17
% Email:                zheyan@seu.edu.cn
% v. Matlab 2023a

clear; close all force; clc;

grid_resol = 60;     % grid resolution
lat_dist = 320;      % size of the area in latitude
lon_dist = 550;      % size of the area in longitude
sam_inGrid = 1500;   % number of the randomly simulated samples in each grid
Re = 6378137;        % earth radius
f = waitbar(0,'Simulating...');
t_str = datestr(clock);

%% Area description
upper_left  = [60.217478, 24.800784];
lower_left  = [60.214227, 24.800355];
upper_right = [60.217115, 24.812114];
lower_right = [60.213864, 24.810701];
lat_appro = upper_left(1,1);
lat_start = lower_left(1,1);
lon_start = lower_left(1,2);

%% First method to get the distance
lat_err = (deg2rad(upper_left(1,1)) - deg2rad(lower_left(1,1))) * Re;
lon_err = (deg2rad(upper_right(1,2)) - deg2rad(upper_left(1,2))) * cos(deg2rad(lat_appro)) * Re;

%% Second method to get the distance
dist1 = getdistance(upper_left(1,1),upper_right(1,2),upper_left(1,1),upper_left(1,2));  % long
dist2 = getdistance(upper_left(1,1),upper_right(1,2),lower_left(1,1),upper_right(1,2)); % lati

%% Start
viewer = siteviewer("Buildings","espoo.osm","Basemap","topographic");
%viewer = siteviewer("Buildings","espoo.osm");

rx1 = rxsite("Name","Small cell receiver","Latitude",60.21666, "Longitude",24.80097, "AntennaHeight",2);
rx2 = rxsite("Name","Small cell receiver","Latitude",60.21735, "Longitude",24.80541, "AntennaHeight",2); 
rx3 = rxsite("Name","Small cell receiver","Latitude",60.21680, "Longitude",24.80969, "AntennaHeight",2); 
rx4 = rxsite("Name","Small cell receiver","Latitude",60.21564, "Longitude",24.81245, "AntennaHeight",2);
rx5 = rxsite("Name","Small cell receiver","Latitude",60.21385, "Longitude",24.80946, "AntennaHeight",2);
rx6 = rxsite("Name","Small cell receiver","Latitude",60.21406, "Longitude",24.80342, "AntennaHeight",2);
rx7 = rxsite("Name","Small cell receiver","Latitude",60.21507, "Longitude",24.80658, "AntennaHeight",2);
rx8 = rxsite("Name","Small cell receiver","Latitude",60.215793, "Longitude",24.802949, "AntennaHeight",2);
rx9 = rxsite("Name","Small cell receiver","Latitude",60.215381, "Longitude",24.809276, "AntennaHeight",2);

rtpm = propagationModel("raytracing","Method","sbr","MaxNumReflections",5,"BuildingsMaterial","concrete","TerrainMaterial","concrete");

%% Conculate the step
lat_step_num = floor(lat_dist/grid_resol);
lon_step_num = floor(lon_dist/grid_resol);
lat_step_in_rad = grid_resol / Re;
lon_step_in_rad = grid_resol / (Re*cosd(lat_appro));
lat_step_in_deg = rad2deg(lat_step_in_rad);
lon_step_in_deg = rad2deg(lon_step_in_rad);

%-----waitbar
total_num = lon_step_num*lat_step_num*sam_inGrid;
strengthMatrix = zeros(total_num,12)*NaN;

%% Starter point has the smaller value
for i = 1:lat_step_num
    for j = 1:lon_step_num
        gridNum = (i-1)*lon_step_num + j;
        lat1 = lat_start + (i-1)*lat_step_in_deg;
        lat2 = lat_start + i*lat_step_in_deg;
        lon1 = lon_start + (j-1)*lon_step_in_deg;
        lon2 = lon_start + j*lon_step_in_deg;

        if lat1 < lat2
            latAdd = lat1;
        else 
            latAdd = lat2;             
        end
        
        if lon1 < lon2 
            lonAdd = lon1;
        else 
            lonAdd = lon2;             
        end
        
        x1 = rand(1,sam_inGrid);
        x2 = rand(1,sam_inGrid);
        c1 = x1*abs(lat2-lat1) + latAdd;
        c2 = x2*abs(lon2-lon1) + lonAdd;
        
        for n = 1:sam_inGrid
            lat = c1(n);
            lon = c2(n);
        
            tx1 = txsite("Name","Small cell transmitter", "Latitude",lat, "Longitude",lon, "AntennaHeight",1,"TransmitterPower",1,"TransmitterFrequency",1575.42e6);
            % comment this part to accelerate simulation
            raytrace(tx1,rx1,rtpm)
            raytrace(tx1,rx2,rtpm)
            raytrace(tx1,rx3,rtpm)
            raytrace(tx1,rx4,rtpm)
            raytrace(tx1,rx5,rtpm)
            raytrace(tx1,rx6,rtpm)
            raytrace(tx1,rx7,rtpm)
            raytrace(tx1,rx8,rtpm)
            raytrace(tx1,rx9,rtpm)
            % end of comment
            ss1 = sigstrength(rx1,tx1,rtpm);
            ss2 = sigstrength(rx2,tx1,rtpm);
            ss3 = sigstrength(rx3,tx1,rtpm);
            ss4 = sigstrength(rx4,tx1,rtpm);
            ss5 = sigstrength(rx5,tx1,rtpm);
            ss6 = sigstrength(rx6,tx1,rtpm);
            ss7 = sigstrength(rx7,tx1,rtpm);
            ss8 = sigstrength(rx8,tx1,rtpm);
            ss9 = sigstrength(rx9,tx1,rtpm);
            ss1(isinf(ss1))=-230;
            ss2(isinf(ss2))=-230;
            ss3(isinf(ss3))=-230;
            ss4(isinf(ss4))=-230;
            ss5(isinf(ss5))=-230;
            ss6(isinf(ss6))=-230;
            ss7(isinf(ss7))=-230;
            ss8(isinf(ss8))=-230;
            ss9(isinf(ss9))=-230;
        
            index = n + (gridNum-1)*sam_inGrid;
            strengthMatrix(index,:) = [gridNum, lat, lon, ss1, ss2, ss3, ss4, ss5, ss6, ss7, ss8, ss9];
            clearMap(viewer)
            %-----waitbar
            str=['Simulating... ',num2str(100*index/total_num),'% ','Start at ',t_str];
            waitbar(index/total_num,f,str);
        end
    end
end
save('strengthMatrix.mat','strengthMatrix')
close(f)

