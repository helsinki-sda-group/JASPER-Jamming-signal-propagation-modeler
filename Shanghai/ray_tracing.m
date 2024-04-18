% Ray-tracing simulator to generate the jamming strengths at each
% monitoring receiver based on the city grid.
% Author(s):            Zhe Yan
% Affiliation           University of Helsinki, Finland
% Last changed date:    2023-10-27
% Email:                zhe.yan@helinski.fi
% v. Matlab 2023a

clear; close all force; clc;

grid_resol = 130;     % grid resolution
lat_dist = 790;       % size of the area in latitude
lon_dist = 1040;      % size of the area in longitude
sam_inGrid = 1500;    % number of the randomly simulated samples in each grid
Re = 6378137;         % earth radius
f = waitbar(0,'Simulating...');
t_str = datestr(clock);

%% Area description
upper_left  = [31.2434250, 121.4934666];
lower_left  = [31.2363000, 121.4934666];
upper_right = [31.2434250, 121.5041555];
lower_right = [31.2363000, 121.5041555];
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
viewer = siteviewer("Buildings","shanghai.osm","Basemap","topographic");
%viewer = siteviewer("Buildings","shanghai.osm");

rx1 = rxsite("Name","Small cell receiver","Latitude",31.2418166, "Longitude",121.4951944, "AntennaHeight",2);
rx2 = rxsite("Name","Small cell receiver","Latitude",31.2412038, "Longitude",121.4946000, "AntennaHeight",2); 
rx3 = rxsite("Name","Small cell receiver","Latitude",31.2393888, "Longitude",121.4958000, "AntennaHeight",2); 
rx4 = rxsite("Name","Small cell receiver","Latitude",31.2411611, "Longitude",121.4971250, "AntennaHeight",2);
rx5 = rxsite("Name","Small cell receiver","Latitude",31.2386027, "Longitude",121.4987888, "AntennaHeight",2);
rx6 = rxsite("Name","Small cell receiver","Latitude",31.2368794, "Longitude",121.4956433, "AntennaHeight",2);
rx7 = rxsite("Name","Small cell receiver","Latitude",31.2379777, "Longitude",121.5004972, "AntennaHeight",2);
rx8 = rxsite("Name","Small cell receiver","Latitude",31.2372138, "Longitude",121.5029500, "AntennaHeight",2);
rx9 = rxsite("Name","Small cell receiver","Latitude",31.2388916, "Longitude",121.5023811, "AntennaHeight",2);
rx10 = rxsite("Name","Small cell receiver","Latitude",31.2413000, "Longitude",121.5044055, "AntennaHeight",2);
rx11 = rxsite("Name","Small cell receiver","Latitude",31.2428583, "Longitude",121.5020777, "AntennaHeight",2);
rx12 = rxsite("Name","Small cell receiver","Latitude",31.2424111, "Longitude",121.4974900, "AntennaHeight",2);

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
strengthMatrix = zeros(total_num,15)*NaN;

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
            raytrace(tx1,rx10,rtpm)
            raytrace(tx1,rx11,rtpm)
            raytrace(tx1,rx12,rtpm)
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
            ss10 = sigstrength(rx10,tx1,rtpm);
            ss11 = sigstrength(rx11,tx1,rtpm);
            ss12 = sigstrength(rx12,tx1,rtpm);
            ss1(isinf(ss1))=-230;
            ss2(isinf(ss2))=-230;
            ss3(isinf(ss3))=-230;
            ss4(isinf(ss4))=-230;
            ss5(isinf(ss5))=-230;
            ss6(isinf(ss6))=-230;
            ss7(isinf(ss7))=-230;
            ss8(isinf(ss8))=-230;
            ss9(isinf(ss9))=-230;
            ss10(isinf(ss10))=-230;
            ss11(isinf(ss11))=-230;
            ss12(isinf(ss12))=-230;
        
            index = n + (gridNum-1)*sam_inGrid;
            strengthMatrix(index,:) = [gridNum,lat,lon,ss1,ss2,ss3,ss4,ss5,ss6,ss7,ss8,ss9,ss10,ss11,ss12];
            clearMap(viewer)
            %-----waitbar
            str=['Simulating... ',num2str(100*index/total_num),'% ','Start at ',t_str];
            waitbar(index/total_num,f,str);
        end
    end
end
save('strengthMatrix.mat','strengthMatrix')
close(f)

