diff-with-json
==
diff with JSON structure.

[![Build Status](https://travis-ci.org/ne-sachirou/diff-with-json.svg?branch=master)](https://travis-ci.org/ne-sachirou/diff-with-json)

Installation
--
### Pre-requiments
- [Crystal](https://crystal-lang.org/)
- diff or [colordiff](http://www.colordiff.org/)
- [jq](https://stedolan.github.io/jq/)

### Download a binary
Download a binary from [releases](https://github.com/ne-sachirou/diff-with-json/releases) and put it into PATH.

### Build from source
```sh
git clone --depth=1 git@github.com:ne-sachirou/diff-with-json.git
cd diff-with-json
make build
cp bin/diff-with-json /usr/local/bin/
```

Usage
--
```
diff-with-json [OPTIONS] FILES...

	diff with JSON structure.

Example:
	diff-with-json -L a.json -L b.json /tmp/a /tmp/b

Options:
    -u, --unified                    
    -L LABEL, --label=LABEL          Use LABEL instead of file name.
    -h, --help                       Output this help.
```

Tips: Use with SVN. `svn diff --diff-cmd diff-with-json`

Development
--
### Pre-requiments
- [Crystal](https://crystal-lang.org/)

### Tests
Run `make test` before commit.

### Editing README
Please Edit src/README.md.ecr then `make build`.

Contributing
--
1. Fork it ( https://github.com/ne-sachirou/diff-with-json/fork )
2. Create your feature branch (git checkout -b my_new_feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my_new_feature)
5. Create a new Pull Request

Contributors
--
- [[ne-sachirou]](https://github.com/ne-sachirou) ne_Sachirou - creator, maintainer
