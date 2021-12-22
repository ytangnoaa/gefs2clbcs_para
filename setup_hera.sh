module purge
module load intel/18.0.5.274  impi/2018.0.4
module load netcdf/4.7.0
module use -a /scratch2/NCEPDEV/nwprod/NCEPLIBS/modulefiles
module load bufr bufr_dumplist dumpjb w3nco w3emc g2c bacio ip ip2 jasper prod_util nemsio nemsiogfs
export NETCDF_LDFLAGS="-L$NETCDF/lib -lnetcdff -lnetcdf"
