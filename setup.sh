compile_c(){
    echo "=================================================="
    echo "Making C Index..."
    echo "=================================================="
    make -C index_c
    if [ $? -ne 0 ]; then
        echo "The command failed with exit status $?"
        exit 1
    else
        echo "=================================================="
        echo "Compiled Index-C succeeded"
        echo "=================================================="
    fi
}

index_c(){
    cd index_c
    echo "../data" | ./indexdb
    cd ..
    
    echo "=================================================="
    echo "Index with Index-C succeeded"
    echo "=================================================="
}

while getopts i:r: flag
do
    case "${flag}" in
        i) install=${OPTARG};;
        r) run=${OPTARG};;
    esac
done

compile_c
index_c