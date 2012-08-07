construct.js
============

Port of python construct package http://construct.wikispaces.com/


Requirements
-----------
You need install coffescript and node-js to build construct.js
Ubuntu:
    sudo apt-get install nodejs coffeescript git


Building & Installing
---------------------
    
    git clone https://github.com/jjay/construct.js.git
    cd construct.js
    ./build.sh
    cp construct.js /path/to/static/files

Its done, now you can use construct.js

Usage
-----

    with ( construct ){
        struct = Struct("attempt_1",
            UBInt8("Age"),
            SBInt16("Hairs"),
            UBInt32("Weight")
        )
    }


    result = struct.parse('\x01\x00\x0f\x00\x00\x00\xff')
    console.log(result)
    /* output:

        Object >
            Age: 1
            Hairs: 15
            Weight: 255
    */


