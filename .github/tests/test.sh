#!/bin/bash

# --- 1. KOMPILERING & FÖRBEREDELSER ---

# Om vi skickar in "compile" som argument, testa bara att bygga
if [ "$1" == "compile" ]; then
    make program > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Pass: Program compiled"
        exit 0
    else
        echo "Fail: Compile failed"
        exit 1
    fi
fi

# Se till att programmet är byggt inför körning
if [ ! -f "./main.out" ]; then
    make program > /dev/null 2>&1
fi

echo "Running tests..."

# --- 2. KÖR PROGRAMMET (Dina data) ---
input_data=$(echo -e "adam 8 8 8 8 8 8 8 8 8 8 8 8 8\neve 7 9 7 9 8 6 10 8 7 8 9 8 7\nbob 5 6 5 6 5 6 5 6 5 6 5 6 7\nDave 7 7 7 7 7 7 7 6 6 6 6 6 6\nCharlie 9 9 9 9 9 9 7 7 10 10 10 10 10")

result=$(echo "$input_data" | ./main.out)
exit_code=$?

# Läs in resultatet i array
readarray -t values <<< "$result"
array_length=${#values[@]}

# Hämta värden 
best_name=$(echo "${values[0]}" | xargs)
need_help1=$(echo "${values[1]}" | xargs)
need_help2=$(echo "${values[2]}" | xargs)

# --- 3. TESTLOGIK ---

test_mode=$1 

if [ -z "$test_mode" ]; then
    test_mode="all"
fi

error=0

# -- Test: Exit Code --
if [[ "$test_mode" == "all" ]]; then
    if [ $exit_code -eq 0 ]; then
        echo "Pass: Program exited zero"
    else
        echo "Fail: Program did not exit zero"
        error=1
    fi
fi

# -- Test: Videofil --
if [[ "$test_mode" == "all" || "$test_mode" == "check_video" ]]; then
    if [ -f "videoprov.mp4" ]; then
        echo "Pass: Filen 'videoprov.mp4' hittades."
    else
        echo "Fail: Filen 'videoprov.mp4' saknas i roten."
        # Om vi inte kör "all", avsluta direkt. Annars sätt error-flaggan.
        if [ "$test_mode" != "all" ]; then exit 1; fi
        error=1
    fi
fi

# -- Test: Antal rader --
if [[ "$test_mode" == "all" ]]; then
    if [ "$array_length" == "3" ]; then
        echo "Pass: Expected '3' names and got $array_length names"
    else
        echo "Expected '3' names but got: $array_length names"
        error=1
    fi
fi

# -- Test: Charlie (Logik) --
if [[ "$test_mode" == "all" || "$test_mode" == "logic_best" ]]; then
    if [ "${best_name,,}" == "charlie" ]; then
        echo "Pass: Rätt person (Charlie) hittad."
    else
        echo "Fail: Expected 'Charlie' (ignoring case) but got: $best_name"
        if [ "$test_mode" != "all" ]; then exit 1; fi
        error=1
    fi
fi

# -- Test: Charlie (Format) --
if [[ "$test_mode" == "all" || "$test_mode" == "format_best" ]]; then
    if [ "$best_name" == "Charlie" ]; then
        echo "Pass: Stavning 'Charlie' är korrekt."
    else
        echo "Fail: Expected 'Charlie' but got: $best_name"
        if [ "$test_mode" != "all" ]; then exit 1; fi
        error=1
    fi
fi

# -- Test: Under medel (Logik) --
if [[ "$test_mode" == "all" || "$test_mode" == "logic_below" ]]; then
    if [ "${need_help1,,}" == "bob" ] && [ "${need_help2,,}" == "dave" ]; then
        echo "Pass: Rätt personer (Bob och Dave) hittade."
    else
        echo "Fail: Expected 'Bob' and 'Dave' but got: $need_help1, $need_help2"
        if [ "$test_mode" != "all" ]; then exit 1; fi
        error=1
    fi
fi

# -- Test: Under medel (Format) --
if [[ "$test_mode" == "all" || "$test_mode" == "format_below" ]]; then
    if [ "$need_help1" == "Bob" ] && [ "$need_help2" == "Dave" ]; then
        echo "Pass: Stavning på Bob och Dave är korrekt."
    else
        echo "Fail: Expected 'Bob' and 'Dave' but got: $need_help1, $need_help2"
        if [ "$test_mode" != "all" ]; then exit 1; fi
        error=1
    fi
fi

# Slutresultat för "all" mode
if [[ "$test_mode" == "all" ]]; then
    if [ $error -eq 0 ]; then
        echo
        echo "All tests passed."
        exit 0
    else
        echo
        echo "Some tests failed."
        exit 1
    fi
fi

exit 0
