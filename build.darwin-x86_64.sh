#!/bin/bash -eux
CLANG_TARGET=$(clang -v 2>&1 | awk '/^Target:/{print $2}')
CC_CMD=$(crystal build --release -o bin/diff-with-json --cross-compile --target "$CLANG_TARGET" bin/diff-with-json.cr | perl -pe 's#-l(\w+)#`ls /usr/local/lib/lib$1.a 2>/dev/null` ? "/usr/local/lib/lib$1.a" : "-l$1"#ge')
$CC_CMD
