Instructions for releasing this cookbook:

- Update `metadata.rb` with new cookbook version

        version           '2.0.1'

- Ensure all tests pass

        $ rake

- Update `CHANGELOG.md` with recent changes

        $ rake changelog[v2.0.0] # use version of most-recent release tag
  
    - Prepend contents of `changelog.tmp` to `CHANGELOG.md`
    - Replace `HEAD` with current version number (match `metadata.rb` version)
    - Replace `YYYY-MM-DD` with current date, if necessary
    - For each commit line item:
        - Remove `Fix #xx ` string (regex: `Fix #\d+\s`)
        - Replace `TYPE` with one of:
          `BREAK`   - breaking changes
          `FIX`     - bug fix
          `IMPROVE` - improvement of existing feature
          `NEW`     - new feature
    - Remove `changelog.tmp`

- Commit changes to `metadata.rb` and `CHANGELOG.md`

        $ git add metadata.rb CHANGELOG.md
        $ git commit -m 'Update changelog, bump version'

- Ensure working directory is clean; add/stash changes, if necessary

        $ git add . && git stash

- Switch `knife.rb` configuration

        $ chefvm use 0

- Release cookbook

        $ rake release
