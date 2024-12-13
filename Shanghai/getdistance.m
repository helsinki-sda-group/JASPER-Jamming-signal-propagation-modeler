% Calculate the distance between two points given latitude and longitude
% Author(s):            Zhe Yan
% Affiliation           University of Helsinki, Finland
% Last changed date:    2023-5-3
% Email:                zheyan@seu.edu.cn

function [dist] = getdistance(latA, lonA, latB, lonB)
ra = 6378140;
rb = 6356755;
flatten = (ra-rb)/ra; % 1/298.257

radLatA = deg2rad(latA);
radLonA = deg2rad(lonA);
radLatB = deg2rad(latB);
radLonB = deg2rad(lonB);

pA = atan(rb / ra * tan(radLatA));
pB = atan(rb / ra * tan(radLatB));
x = acos(sin(pA)*sin(pB) + cos(pA)*cos(pB)*cos(radLonA-radLonB));
c1 = (sin(x)-x) * ((sin(pA)+sin(pB))^2)/(cos(x/2)^2);
c2 = (sin(x)+x) * ((sin(pA)-sin(pB))^2)/(sin(x/2)^2);
dr = flatten/8 * (c1-c2);
distance = ra*(x+dr);
% dist = round(distance);
dist = distance;
