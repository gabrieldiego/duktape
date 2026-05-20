/*
 *  Regression test for modern callback/property syntax seen in
 *  openstreetmap.org assets.
 */

/*===
3
1 2
3
5
===*/

function test() {
    let value = 2;
    var f = response => {
        return response + value;
    };
    print(f(1));

    var set = 1;
    var get = 2;
    var obj = { set, get };
    print(obj.set, obj.get);

    var methods = {
        add(a, b) {
            return a + b;
        }
    };
    print(methods.add(1, 2));

    let other = 5;
    print(other);
}

test();
