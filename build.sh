#!/bin/bash
if [ ! -f packages/FAKE/tools/FAKE.exe ]; then
  mono .nuget/NuGet.exe install FAKE -OutputDirectory packages -ExcludeVersion
fi
#workaround assembly resolution issues in build.fsx
export FSHARPI=`which fsharpi`
cat - > fsharpi <<"EOF"
#!/bin/bash
libdir=$PWD/packages/FAKE/tools/
$FSHARPI --lib:$libdir $@
EOF
chmod +x fsharpi
#return build.fsx exit code
mono packages/FAKE/tools/FAKE.exe build.fsx $@
e=$?
rm fsharpi
exit $e
