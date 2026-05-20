/*
 *  Regression test for the navbar.js callback shape that failed in NetSurf
 *  with Duktape's older parser.
 */

/*===
DOMContentLoaded click active open
===*/

function test() {
    var calls = [];
    var mobileMenuButton = {
        classList: {
            toggle: function (name) {
                calls.push(name);
            }
        },
        addEventListener: function (name, cb) {
            calls.push(name);
            cb();
        }
    };
    var navMenu = {
        classList: {
            toggle: function (name) {
                calls.push(name);
            }
        }
    };
    var document = {
        addEventListener: function (name, cb) {
            calls.push(name);
            cb();
        },
        getElementById: function (id) {
            return mobileMenuButton;
        },
        querySelector: function (selector) {
            return navMenu;
        }
    };

    document.addEventListener("DOMContentLoaded", () => {
        var mobileMenuButton = document.getElementById("mobile-menu");
        var navMenu = document.querySelector(".nav-menu");

        mobileMenuButton.addEventListener("click", () => {
            navMenu.classList.toggle("active");
            mobileMenuButton.classList.toggle("open");
        });
    });

    print(calls.join(" "));
}

test();
