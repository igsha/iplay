which http xmllint ag fzy openssl jq > /dev/null || return 1

rootname(){ ag --nocolor -o '.*:?//[^/]+' <<< "$1"; }
parse_http(){ http "$1" | xmllint --html --xpath "$2" - 2>/dev/null; }
parse_array(){ ag -o "$1:\s*\[\K[^\]]+" | tr ',' '\n'; }

moonwalk()
(
    set -e

    __url=`parse_http "$1" "string(//*[contains(@src,'moonwalk')]/@src)"`
    [[ ! -z "$__url" ]] || return 1
    __season=`http --follow "$__url" "Referer:$1" | parse_array seasons | fzy --prompt="Choose season: "`
    __episode=`http --follow "$__url" "Referer:$1" "season==$__season" | parse_array episodes | fzy --prompt="Choose episode: "`

    __page=`http --follow "$__url" "Referer:$1" "season==$__season" "episode==$__episode"`
    __ref=`ag -o "ref:\s*['\"]\K[^'\"]+" <<< "$__page"`
    __partner_id=`ag -o "partner_id:\s*\K\d+" <<< "$__page"`
    __domain_id=`ag -o "domain_id:\s*\K\d+" <<< "$__page"`
    __video_token=`ag -o "video_token:\s*['\"]\K[^'\"]+" <<< "$__page"`
    __host=`ag -o "\bhost:\s*['\"]\K[^'\"]+" <<< "$__page"`
    __port=`ag -o "port:\s*\K\d+" <<< "$__page"`
    __proto=`ag -o "proto:\s*['\"]\K[^'\"]+" <<< "$__page"`

    __key=9186a0bae4afec34c323aecb7754b7c848e016188eb8b5be677d54d3e70f9cbd
    __iv=2ea2116c80fae4e90c1e2b2b765fcc45
    __user_agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) QtWebEngine/5.12.0 Chrome/69.0.3497.128 Safari/537.36"

    __json="{\"a\":$__partner_id,\"b\":$__domain_id,\"c\":false,\"e\":\"$__video_token\",\"f\":\"$__user_agent\"}"
    __q=`openssl enc -aes-256-cbc -base64 -A -iv $__iv -K $__key <<< "$__json"`

    http POST "$__proto$__host:$__port/vs" "ref=$__ref" "q=$__q" "User-Agent:$__user_agent" | jq -r .m3u8
)

ralode()
(
    set -e

    __json=`http "$1" | ag -o "RalodePlayer.init\(\K{.*}(?=\))"`
    [[ ! -z "$__json" ]] || return 1
    __json=`sed -e '1s/^/[/' -e '$s/$/]/' <<< "$__json"` # on separate line to force error
    __name=`jq -r '.[0] | .[] | .name' <<< "$__json" | fzy --prompt="Select a dubber: "` || return 1

    declare -A __items
    eval $(jq -r '.[0] | .[] | select(.name == "'"$__name"'") | .items[] | "__items[\"" + .sname + "\"]=" + (.scode | capture("src=(?<a>\"[^\"]+\")") | .a)' <<< "$__json")

    __episode=`printf "%s\n" "${!__items[@]}" | sort -V | tac | fzy --prompt="Select an episode: "` || return 1
    parse_http "$(rootname "$1")${__items["$__episode"]}" "string(//iframe/@src)" | sed 's@^//@http://@'
)

export extractors=(moonwalk ralode)
