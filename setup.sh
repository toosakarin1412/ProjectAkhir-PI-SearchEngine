#!/bin/bash

# Help
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo " -h, --help      Display this help message"
    echo " -i, --install   SERVICE Install service"
    echo " -s, --stop      SERVICE Stop running service"
    echo " -in, --index    SERCIVE make index"
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
    make index -C index_c
    make query -C index_c
    if [ $? -ne 0 ]; then
        echo "The command failed with exit status $?"
        exit 1
    else
        echo "=================================================="
        echo "Compiled Index-C Complete"
        echo "=================================================="
    fi
}

index_c(){
    cd index_c
    echo "../data" | ./indexdb
    cd ..
    
    echo "=================================================="
    echo "Index with Index-C Complete"
    echo "=================================================="
}

run_solr(){
    echo "=================================================="
    echo "Running Apache Nutch + Solr"
    echo "=================================================="
    cd solr
    bin/solr start -force
    cd ..
    echo "=================================================="
    echo "Running Apache Nutch + Solr Complete"
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
    echo "Stopping Apache Nutch + Solr Complete"
    echo "=================================================="
}

index_solr(){
    echo "=================================================="
    echo "Running Index Apache Nutch + Solr"
    echo "=================================================="
    echo "Clean index..."
    solr/bin/post -c indexing -type text/xml -out yes -d $'<delete><query>*:*</query></delete>'
    echo "making new index..."
    python3 solr_input.py
    echo "=================================================="
    echo "Apache Nutch + Solr Index Complete"
    echo "=================================================="
}

index_swish(){
    echo "=================================================="
    echo "Running Index Swish-E"
    echo "=================================================="
    cd swish-e
    swish-e -c config.conf
    cd ..
    echo "=================================================="
    echo "Swish-E Index Complete"
    echo "=================================================="
}

handle_options() {
    while [ $# -gt 0 ]; do
        case $1 in
            -h | --help)
                usage
                exit 0
            ;;
            -in | --index)
                if ! has_argument $@; then
                    echo "Input not valid." >&2
                    usage
                    exit 1
                fi
                
                arg=$(extract_argument $@)
                
                if [[ "$arg" == "C" ]];
                then
                    index_c;
                elif [[ "$arg" == "nutch" ]];
                then
                    index_solr;
                elif [[ "$arg" == "swish" ]];
                then
                    index_swish;
                elif [[ "$arg" == "all" ]];
                then
                    index_c;
                    index_solr;
                    index_swish;
                fi
                
                shift
            ;;
            -i | --install)
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
            -sw | --stopword)
                if ! has_argument $@; then
                    echo "Input not valid." >&2
                    usage
                    exit 1
                fi
                
                arg=$(extract_argument $@)
                echo "=================================================="
                echo "Copying Stopword"
                echo "=================================================="
                echo "Copying to Index-C"
                cp $arg index_c/stoplist
                echo "Copying to Swish-E"
                cp $arg swish-e/stopwords.txt
                echo "=================================================="
                echo "Complete Copying Stopword"
                echo "=================================================="
                
                shift
            ;;
            -r | --restart)
                if ! has_argument $@; then
                    echo "Input not valid." >&2
                    usage
                    exit 1
                fi
                
                arg=$(extract_argument $@)
                
                if [[ "$arg" == "nutch" ]];
                then
                    stop_solr;
                    run_solr;
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