# remove quotes
remove_quotes_from_vars() {
    text=$1
    IFS=' ' read -ra arr <<< "$text"
    result=""
    for i in "${arr[@]}"; do
        var="${i%%=*}"
        val="${i#*=}"
        # var=$(echo $i | cut -d= -f1)
        # val=$(echo $i | cut -d= -f2)
        if [[ $var == *"\""* ]]; then
            var="$(echo $var | sed 's/\"//g')"
        fi
        result+="$var$val "
    done
    echo $result
}

# get previous env variables
saved_vars=$(sed -n '/window.env = {/,/};/p' env.js | tr -d ',\n' | tr '\n' ' ' | tr -s ':' '=' | grep -oP '(?<=window.env = \{)(.*)(?=\})' | sed 's/ *= */=/g' )
saved_vars2=$(remove_quotes_from_vars "$saved_vars")

# get vars inserted in vars.txt

new_vars=$(grep "^REACT_APP_" vars.txt  )

new_env_vars=$(echo $saved_vars $new_vars | tr ' ' '\n' |  uniq | tr '\n' ' '  )


# execute command 

sleep 1

eval "$new_env_vars npx react-inject-env set -d ./ && rm -rf build"
