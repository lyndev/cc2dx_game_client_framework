echo "********************************************************"
echo "tcopy pb to client res/pb            "
echo "********************************************************"
del ..\..\simulator\win32\res\pb\*.* /S /Q
xcopy ..\pb ..\..\simulator\win32\res\pb /E /I /Y