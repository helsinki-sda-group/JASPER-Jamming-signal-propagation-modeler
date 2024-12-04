JASPER-Jamming-signal-propagation-modeler

This is a ray-tracing simulator to model the GNSS receiver C/N0 and AGC outputs under jamming in urban areas. The model is based on Ublox F9P.

Steps:
1. Run ray_tracing.m to obtain the received jamming strengh matrix (strengthMatrix.mat) based on the city grid;
2. Processing strengthMatrix.mat using combination.m to generate the C/N0 and AGC outputs of F9P.
