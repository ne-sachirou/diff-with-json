diff-with-json
==
diff with JSON structure.

Installation
--
### Pre-requiments
- [jq](https://stedolan.github.io/jq/)
- diff or [colordiff](http://www.colordiff.org/)

### Download a binary
Download a binary from [releases](https://github.com/ne-sachirou/diff-with-json/releases) and put it into PATH.

### Build from source
```sh
git clone --depth=1 git@github.com:ne-sachirou/diff_with_json.git
cd diff_with_json
make build
cp bin/diff_with_json /usr/local/bin/
```

Usage
--
```
diff-with-json [OPTIONS] FILES...

diff with JSON structure.

Example:
	diff-with-json -L a.json -L b.json /tmp/a /tmp/b

    -u
    -L LABEL
    -h, --help                       Show help
```

Tips: Use with SVN. `svn diff --diff-cmd diff-with-json`

Development
--
### Pre-requiments
- [Crystal](https://crystal-lang.org/)

Contributing
--
1. Fork it ( https://github.com/ne-sachirou/diff_with_json/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

Contributors
--
- [[ne-sachirou]](https://github.com/ne-sachirou) ne_Sachirou - creator, maintainer
