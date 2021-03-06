#!/bin/bash

# -a compiles slides and handout

while getopts :a: option
do
    case "${option}"
    in
        a) compileall=${OPTARG};;
        \?)
            echo "Invalid option: -$OPTARG"
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument."
            exit 1
            ;;
    esac
done

if [ ! -z ${compileall+x} ]; then
    if [ $compileall != "0" ] && [ $compileall != "1" ]; then
        echo "compileall set incorrectly (should be 0 or 1)"
        exit 1
    fi
else
    compileall="0"
fi

R -e "rmarkdown::render('AdVisSlides.Rmd')"

if [ $compileall == "1" ]; then
    pdfannotextractor AdVisSlides.pdf
    compile="\def\filename{AdVisSlides.pdf} \input{handout.tex}"
    pdflatex $compile
    mv handout.pdf AdVisHandout.pdf
    rm *.pax *.aux *.log
fi

