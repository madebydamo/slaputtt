 document.addEventListener('DOMContentLoaded', function() {
    var elems = document.querySelectorAll('.sidenav');
    var instances = M.Sidenav.init(elems, {});
  });


document.addEventListener('DOMContentLoaded', function() {
    var elems = document.querySelectorAll('.dropdown-trigger');
    var instances = M.Dropdown.init(elems);
  });

var colorThemes = ["powderblue", "coral", "mint"];

function loadColorTheme(id) {
    console.log("asdf" + colorThemes.length);
    for (var i = 0; i < colorThemes.length; i++) {
            if (id == colorThemes[i]) {
               $('#' + id).disabled = false;
               console.log("anebked"  + id);
            }
            else {
               $('#' + id).disabled = true;
               console.log("disabled"  + id);
            }
       }
}

//scrolspy

document.addEventListener('DOMContentLoaded', function() {
    var elems = document.querySelectorAll('.scrollspy');

    var instances = M.ScrollSpy.init(elems, {scrollOffset: 50});
  });