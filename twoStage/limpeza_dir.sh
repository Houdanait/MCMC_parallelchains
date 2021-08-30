echo "LIMPANDO OS DIRETORIOS"
rm -f in/init_sta*.in error/*;
for a in select_fields/field_v*.dat; do rm -f $a; done
rm -f select_fields/field_v*;
for a in select_prod/prod_D*.dat; do rm -f $a; done
rm -f select_prod/prod_D*;
rm -f reject_fields/*;
rm -f reject_prod/*;
rm -f *.o out/*.dat;
for a in select_thetas/theta_v*.dat; do rm -f $a; done
rm -f select_thetas/theta_v*;
rm -rf ../twophaseflow/exp0*;
rm -rf ../twophaseflow/exp1*;
rm -f  ../twophaseflow/output*.out;
rm -f  ../twophaseflow/*.mat;
rm -f  ../twophaseflow/octave-workspace;
rm -rf ../simuladorRigido/exp0*;
rm -rf ../simuladorRigido/exp1*;
rm -f  ../simuladorRigido/output*.out;
rm -rf ./simuladorRigido/exp0*;
rm -rf ./simuladorRigido/exp1*;
rm -f  ./simuladorRigido/output*.out;
rm -rf ../gera_KL/FORTRAN_KL3D/in0*;
rm -rf ../gera_KL/FORTRAN_KL3D_2/in0*;
rm -rf ../gera_KL/FORTRAN_KL3D_3/in0*;
rm -rf ../gera_KL/FORTRAN_RW/in0*;
rm -rf ../gera_KL/FORTRAN_KL3D/output_0*;
rm -rf ../gera_KL/FORTRAN_KL3D_2/output_0*;
rm -rf ../gera_KL/FORTRAN_KL3D_3/output_0*;
rm -rf ../gera_KL/FORTRAN_RW/output_0*;
rm -rf ../gera_KL/FORTRAN_KL3D/out/theta0*;
rm -rf ../gera_KL/FORTRAN_KL3D/out/thetanew0*;
rm -rf ../gera_KL/FORTRAN_KL3D_2/out/theta0*;
rm -rf ../gera_KL/FORTRAN_KL3D_2/out/thetanew0*;
rm -rf ../gera_KL/FORTRAN_RW/out/theta0*;
rm -rf ../gera_KL/FORTRAN_RW/out/thetanew0*;
rm -rf ../gera_KL/MVN/in0*;
rm -rf ../gera_KL/MVN/out/theta0*;
rm -rf ../gera_KL/MVN/out/thetanew0*;
rm -rf ../blackbox/exp0*;
rm -rf ../blackbox/exp1*;
rm -rf ../blackbox/exp2*;
rm -rf ../blackbox/exp3*;
rm -rf ../blackbox/exp4*;
rm -rf ../blackbox/exp5*;
rm -rf ../blackbox/exp6*;
rm -rf ../blackbox/exp7*;
rm -rf ../blackbox/exp8*;
rm -rf ../blackbox/exp9*;
rm -rf ../blackbox/output*.out;
rm -rf ./upscaling/output*.out;
rm -rf ./upscaling/in0*;


