export FILES="src/core.coffee src/macros.coffee src/main.coffee"
echo Building construct $FILES
coffee -j construct.coffee -c $FILES
