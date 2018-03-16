SET z_levels=6
cd

FOR /R ../../maps/ %%f IN (*.dmm) DO (
  echo java -jar MapPatcher.jar -clean %%f.backup %%f %%f >> out.txt
)
