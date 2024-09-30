TARGET  = gefs2lbc_para

OBJECTS = gefs2lbc_para.f90

NETCDF_LIB = -L$(NETCDF)/lib -lnetcdff -lnetcdf

FC         = mpiifort

F_FLAGS    = -O -FR -assume byterec

W3NCO_LIB4 = /scratch2/NCEPDEV/nwprod/NCEPLIBS/compilers/intel/19.0.4.243/lib/libw3nco_v2.0.7_4.a
 
LIBRARIES = $(NETCDF_LIB) $(NEMSIO_LIB) $(BACIO_LIB4) $(W3EMC_LIB4) $(W3NCO_LIB4) \
	-L$(I_MPI_ROOT)/lib

INCLUDES = -I$(NETCDF)/include -I$(NEMSIO_INC) -I$(I_MPI_ROOT)/intel64/include

$(TARGET): $(OBJECTS)
	$(FC) $(F_FLAGS) -o $@ $(INCLUDES) $(OBJECTS) $(LIBRARIES)

clean:
	rm -f *.mod  
install:        
	-cp -p $(TARGET)  ../../exec/.
clobber: clean
	rm -f $(TARGET) 
