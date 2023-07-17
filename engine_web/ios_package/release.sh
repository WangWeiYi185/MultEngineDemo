#!/bin/bash
. ./ios_package/common_func.sh
#echo "参数解析 arg[0] $0"
#$0 : 在用sh 或者 ./执行脚本时，指的是脚本名，用source或.执行时，永运是bash，这也反应了sh 或者 ./执行脚本的原理和source的方式是不同的.
echo "$0"

workpath=$(pwd)
if [ -n "$0" ] && [ "$0" != "/bin/bash" ]; then
# cdn发布模式
flutter pub remove integration_test
#fvm flutter pub run build_runner build --delete-conflicting-outputs
func_exec_clean
func_podfile_source
flutter build ios-framework --no-profile
flutter pub add integration_test --dev --sdk flutter
else 
func_podfile_source
flutter build ios-framework --no-profile --target=lib/main_dev.dart 
fi

cd ./build/ios/framework
#遍历提取debug的x86并合并到release中
for dir in ./Debug/*.xcframework
do
    if test -d $dir 
    then
        filename=${dir##*/}
        framework_name=${filename/xc/}
        simulatorPath="ios-arm64_x86_64-simulator"
        if test $filename = "guang_flutter_framework.xcframework"
        then
            simulatorPath="ios-x86_64-simulator"
        fi
        rm -r ./Release/${filename}/${simulatorPath}/${framework_name}
        cp -R ${dir}/${simulatorPath}/${framework_name} ./Release/${filename}/${simulatorPath}/${framework_name}
    fi
done

#copy debug模式下的字节码和snapshot文件
cp ./Debug/App.xcframework/ios-arm64_x86_64-simulator/App.framework/flutter_assets/isolate_snapshot_data ./Release/App.xcframework/ios-arm64_x86_64-simulator/App.framework/flutter_assets/isolate_snapshot_data
cp ./Debug/App.xcframework/ios-arm64_x86_64-simulator/App.framework/flutter_assets/kernel_blob.bin ./Release/App.xcframework/ios-arm64_x86_64-simulator/App.framework/flutter_assets/kernel_blob.bin
cp ./Debug/App.xcframework/ios-arm64_x86_64-simulator/App.framework/flutter_assets/vm_snapshot_data ./Release/App.xcframework/ios-arm64_x86_64-simulator/App.framework/flutter_assets/vm_snapshot_data


cd $workpath
rm -r ./ios_source/frameworks/*
cp -R ./build/ios/framework/Release/ ./ios_source/frameworks
fmdbPath=./ios_source/frameworks/FMDB.xcframework
if test -d $fmdbPath
then
    rm -r $fmdbPath
fi

#mmkvPath=./ios_source/frameworks/MMKV.xcframework
#mmkvCorePath=./ios_source/frameworks/MMKVCore.xcframework
#if test -d $mmkvPath
#then
#    rm -r $mmkvPath
#    rm -r $mmkvCorePath
#fi

#创建压缩包并上传到cdn
#if [ -n "$0" ] && [ "$0" != "/bin/bash" ]; then
#
#    integrationTestPath=./ios_source/frameworks/integration_test.xcframework
#    if test -d $integrationTestPath
#    then
#        rm -r $integrationTestPath
#    fi
#
#    rm -r ./ios_source/frameworks/Flutter.xcframework
#    echo 'upload'
#    cd ./ios_source/
#    cp ../assets/json/main.routes.json ./assets
#    currentTimeStamp=$(date +%s)
#    tar --exclude=*.tar.bz2 -jcvf flutterModule.tar.bz2 .
#    superman-cdn /guangshop/flutter/build/module/${currentTimeStamp} flutterModule.tar.bz2
#    rm flutterModule.tar.bz2
#
#    cd $workpath
#    # 更新spec
#    sed -i '' "s/[0-9]\{10\}/${currentTimeStamp}/g" './guangshop_flutter_module.podspec'
#fi
