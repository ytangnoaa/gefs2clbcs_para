# gefs2clbcs_para

This repository contains the source code for extracting the aerosol boundary condtion from NOAA GEFS Aerosol Component to RRFS-CMAQ regional domain.
The GEFS input history files are in NEMSIO format, and outputted RRFS-CMAQ CLBC (chemical lateral boundary condition) files are in NetCDF format.
This is a parallel version with one task per time step. 
