 document.addEventListener('DOMContentLoaded', function() {
    var elems = document.querySelectorAll('.sidenav');
    var instances = M.Sidenav.init(elems, {});
  });


document.addEventListener('DOMContentLoaded', function() {
    var elems = document.querySelectorAll('.dropdown-trigger');
    var instances = M.Dropdown.init(elems);
  });


function loadColorTheme1() {
    document.getElementsByTagName('link')[1].disabled = true;
       document.getElementsByTagName('link')[2].disabled = false;
}

function loadColorTheme2() {
    document.getElementsByTagName('link')[1].disabled = false;
       document.getElementsByTagName('link')[2].disabled = true;
}
