JASPER-Jamming-signal-propagation-modeler

This is a ray-tracing simulator to model the GNSS receiver C/N0 and AGC outputs under jamming in urban areas. The model is based on Ublox F9P.

Steps:
1. Run ray_tracing.m to obtain the received jamming strengh matrix (strengthMatrix.mat) based on the city grid;
2. Processing strengthMatrix.mat using combination.m to generate the C/N0 and AGC outputs of F9P.

Published in:

[1] Zhe Yan, Outi Savolainen, Xinhua Tang, Laura Ruotsalainen, "Simultaneous Classification and Searching Method for Jammer Localization in Urban Areas Using KNN-GSA and Ray-Tracing," Proceedings of the 37th International Technical Meeting of the Satellite Division of The Institute of Navigation (ION GNSS+ 2024), Baltimore, Maryland, September 2024, pp. 3361-3374. https://doi.org/10.33012/2024.19767

Cite the aticles:

@inproceedings{yan2024_ION,
  title={Simultaneous Classification and Searching Method for Jammer Localization in Urban Areas Using {KNN-GSA} and Ray-Tracing},
  author={Yan, Zhe and Savolainen, Outi and Tang, Xinhua and Ruotsalainen, Laura},
  booktitle={Proceedings of the 37th International Technical Meeting of the Satellite Division of The Institute of Navigation (ION GNSS+ 2024)},
  pages={3361-3374},
  address={Baltimore, Maryland},
  month={Septemper},
  year={2024}
  doi={10.33012/2024.19767}
}
