function func_exec_clean() {
    flutter clean
    flutter packages get
}

function xcconfig() {
    xcconfigs=(`find ./.ios -name Debug.xcconfig`)
    if [[ ${#xcconfigs[@]} != 0 ]]; then
        xcconfig=${xcconfigs[0]}
        echo "\nENABLE_BITCODE = NO;">>$xcconfig
    fi
}

function func_podfile_source() {
    podfiles=(`find . -name Podfile`)
    if [[ ${#podfiles[@]} != 0 ]]; then
    podfile="$(dirname "${podfiles[0]}")/Podfile"
    echo "=========$podfile"
    # 增加容错
    sed -i '' "s/platform.*/platform :ios, '11.0'/g" $podfile
    # add source
    sed -i '' "/platform/ {a\ 
    source 'https://github.com/CocoaPods/Specs.git'\\
    source 'http://gitlab.qima-inc.com/AppLib/RenRenPodspecs.git'\\
    source 'http://gitlab.qima-inc.com/guang-app-lib/cocoaPodsSepcs'\\
    source 'git@gitlab.qima-inc.com:guang-app-lib/dynamicCocoaPodsSpecs.git'\\
    source 'git@gitlab.qima-inc.com:guang-app-lib/staticCocoaPodsSpecs.git'\\
    source 'git@gitlab.qima-inc.com:wsc_ios/WSCPodSpecs.git'
            }" $podfile

    fi
}
