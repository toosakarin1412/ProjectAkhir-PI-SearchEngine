#!/bin/bash

# Help
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo " -h, --help      Display this help message"
    echo " -i, --install   SERVICE Install service"
    echo " -s, --stop      SERVICE Stop running service"
}

has_argument() {
    [[ ("$1" == *=* && -n ${1#*=}) || ( ! -z "$2" && "$2" != -*)  ]];
}

extract_argument() {
    echo "${2:-${1#*=}}"
}

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

run_solr(){
    echo "=================================================="
    echo "Running Apache Nutch + Solr"
    echo "=================================================="
    cd solr
    bin/solr start
    cd ..
    echo "=================================================="
    echo "Running Apache Nutch + Solr Succeeded"
    echo "=================================================="
}

stop_solr(){
    echo "=================================================="
    echo "Stopping Apache Nutch + Solr"
    echo "=================================================="
    cd solr
    bin/solr stop
    cd ..
    echo "=================================================="
    echo "Stopping Apache Nutch + Solr Succeeded"
    echo "=================================================="
}

index_solr(){
    echo "=================================================="
    echo "Running Index Apache Nutch + Solr"
    echo "=================================================="
    echo "Clean index..."
    solr/bin/post -c indexing -type text/xml -out yes -d $'<delete><query>*:*</query></delete>'
    echo "making new index..."
    python solr_input.py
    echo "=================================================="
    echo "Apache Nutch + Solr Index Succeeded"
    echo "=================================================="
}

handle_options() {
    while [ $# -gt 0 ]; do
        case $1 in
            -h | --help)
                usage
                exit 0
            ;;
            -i | --install*)
                if ! has_argument $@; then
                    echo "Input not valid." >&2
                    usage
                    exit 1
                fi
                
                arg=$(extract_argument $@)
                
                if [[ "$arg" == "C" ]];
                then
                    compile_c;
                    index_c;
                elif [[ "$arg" == "nutch" ]];
                then
                    run_solr;
                    sleep 2
                    index_solr;
                fi
                
                shift
            ;;
            -s | --stop)
                if ! has_argument $@; then
                    echo "Input not valid." >&2
                    usage
                    exit 1
                fi
                
                arg=$(extract_argument $@)
                
                if [[ "$arg" == "nutch" ]];
                then
                    stop_solr;
                fi
                
                shift
            ;;
            *)
                echo "Invalid option: $1" >&2
                usage
                exit 1
            ;;
        esac
        shift
    done
}

# Main script execution
handle_options "$@"