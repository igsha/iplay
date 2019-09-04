which http xmllint ag fzy openssl jq > /dev/null || return 1

rootname(){ ag --nocolor -o '.*:?//[^/]+' <<< "$1"; }
parse_xml() { xmllint --html --xpath "$1" - 2>/dev/null; }
parse_request(){ http --follow "$1" | parse_xml "$2"; }
parse_array(){ ag -o "$1:\s*\[\K[^\]]+" | tr ',' '\n'; }
unquote(){ ag -o "=['\"]\K[^'\"]+"; }
path_prefix(){ sed -e "s@^//@http://@" -e "s@^/@`rootname $1`/@"; }

# $1 - original url, $2 - url of iframe
moonwalk()
(
    set -e

    __season=`http --follow "$2" "Referer:$1" | parse_array seasons | fzy --prompt="Choose season: "`
    __episode=`http --follow "$2" "Referer:$1" "season==$__season" | parse_array episodes | fzy --prompt="Choose episode: "`

    __page=`http --follow "$2" "Referer:$1" "season==$__season" "episode==$__episode"`
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

pre_ralode()
(
    set -e
    http "$1" | ag -o "RalodePlayer.init\(\K{.*}(?=\))"
)

# $1 - original url, $2 - result of pre_ralode
ralode()
(
    set -e

    __json=`sed -e '1s/^/[/' -e '$s/$/]/' <<< "$2"` # on separate line to force error
    __name=`jq -r '.[0] | .[] | .name' <<< "$__json" | fzy --prompt="Select a dubber: "` || return 1

    declare -A __items
    eval $(jq -r '.[0] | .[] | select(.name == "'"$__name"'") | .items[] | "__items[\"" + .sname + "\"]=" + (.scode | capture("src=(?<a>\"[^\"]+\")") | .a)' <<< "$__json")

    __episode=`printf "%s\n" "${!__items[@]}" | sort -V | tac | fzy --prompt="Select an episode: "` || return 1
    parse_request "$(rootname "$1")${__items["$__episode"]}" "string(//iframe/@src)" | path_prefix "$1"
)

pre_jwplayer()
(
    set -e
    http --follow "$1" "referer:$1" | parse_xml "string(//iframe/@src)"
)

# $1 - original url, $2 - result of pre_jwplayer
jwplayer()
(
    set -e

    __root=`rootname "$2"`
    __domain=`basename "$__root"`
    __json=`http POST "$__root/api/source/$(basename "$2")" r="$1" d="$__domain"`
    if ! jq -e . &>/dev/null <<< "$__json"; then
        echo $2 # leave it to youtube-dl
        return 0
    fi

    declare -A __items
    eval $(jq -r '.data[] | "__items[\"" + .label + "\"]=\"" + .file + "\""' <<< "$__json")

    __label=`printf "%s\n" "${!__items[@]}" | fzy --prompt="Select label: "`
    echo "${__items[$__label]}"
)

traverse()
(
    set -e
    __type=`printf "%s\n" self ralode moonwalk jwplayer back iframe src href | fzy --prompt="Choose type ($1): "`
    case "$__type" in
        self) echo "$1"; return 0;;
        back) __result="$2";;
        src) __result=`parse_request "$1" "//*/@src | //*/@data-src" | unquote | fzy --prompt="Choose url: " | path_prefix "$1"`;;
        href) __result=`parse_request "$1" "//*/@href" | unquote | fzy --prompt="Choose url: " | path_prefix "$1"`;;
        iframe) __result=`parse_request "$1" "//iframe/@src | //iframe/@href" | unquote | fzy --prompt="Choose url: " | path_prefix "$1"`;;
        moonwalk) moonwalk "$2" "$1"; return 0;;
        ralode) ralode "$1" $(pre_ralode "$1"); return 0;;
        jwplayer) jwplayer "$1" $(pre_jwplayer "$1"); return 0;;
    esac

    [[ ! -z "$__result" ]] || __result="$1"
    traverse "$__result" "$1"
)
