#!/bin/ksh -xa

PDY=20230717
cyc=00

gefscyc=00
let tstepdiff=$cyc-$gefscyc

ORIGDIR=/scratch2/NCEPDEV/stmp3/Youhua.Tang/aqm.20230717t00z-input
if [ ! -s gefs-input-${PDY}t$cyc ]; then
 ln -s /scratch1/NCEPDEV/stmp4/Patrick.C.Campbell/GEFS_Aerosol/20230717/00 gefs-input-${PDY}t$cyc
fi
if [ ! -s gefs-input-${PDY}t$cyc/gfs.t${gefscyc}z.atmf000.nemsio ]; then
 echo "can not find gefs-input-${PDY}t$cyc/gfs.t${gefscyc}z.atmf000.nemsio"
 exit 1
fi

if [ ! -s $ORIGDIR/aqm.t${cyc}z.gfs_bndy.tile7.f000.nc ]; then
 echo " no original LBC file $ORIGDIR/aqm.t${cyc}z.gfs_bndy.tile7.f000.nc "
 exit 1
fi
if [ ! -s INPUT-C1144 ]; then
mkdir -p INPUT-C1144
fi
cp -p $ORIGDIR/aqm.t${cyc}z.gfs_bndy.tile7.f???.nc INPUT-C1144/
# 6 hours
NUMTS=2

cat > gefs2lbc-nemsio.ini <<EOF
&control
 tstepdiff=$tstepdiff
 dtstep=6 
 bndname='aothrj','aecj','aorgcj','asoil','numacc','numcor'
 mofile='gefs-input-${PDY}t$cyc/gfs.t${gefscyc}z.atmf','.nemsio'
 lbcfile='INPUT-C1144/aqm.t${cyc}z.gfs_bndy.tile7.f','.nc'
 inblend=10
 topofile='../C1144-LBC/C1144_oro_data.tile7.halo4.nc'
&end

Species converting Factor
# Gocart ug/m3 to regional ug/m3
'dust1'    2  ## 0.2-2um diameter: assuming mean diameter is 0.3 um (volume= 0.01414x10^-18 m3) and density is 2.6x10^3 kg/m3 or 2.6x10^12 ug/m3.so 1 particle = 0.036x10^-6 ug
'aothrj'  1.0   'numacc' 27205909.
'dust2'    4  ## 2-4um
'aothrj'  0.45    'numacc'  330882.  'asoil'  0.55   'numcor'  50607.
'dust3'    2  ## 4-6um
'asoil'   1.0   'numcor' 11501.
'dust4'    2   ## 6-12um
'asoil'  0.7586   'numcor' 1437.
'bc1'      2     # kg/kg
'aecj'     1.0   'numacc' 6775815.
'bc2'  2     # kg/kg
'aecj'     1.0   'numacc' 6775815.
'oc1'  2     # kg/kg OC -> organic matter
'aorgcj'    1.0   'numacc' 6775815.
'oc2'  2
'aorgcj'  1.0   'numacc' 6775815.
EOF

export  SALLOC_ACCOUNT=fv3-cam
export  SBATCH_ACCOUNT=fv3-cam
export  SLURM_QOS=debug

srun --time=30:00 -n $NUMTS gefs2lbc_para
