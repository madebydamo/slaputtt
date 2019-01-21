 document.addEventListener('DOMContentLoaded', function() {
    var elems = document.querySelectorAll('.sidenav');
    var instances = M.Sidenav.init(elems, {});
  });


document.addEventListener('DOMContentLoaded', function() {
    var elems = document.querySelectorAll('.dropdown-trigger');
    var instances = M.Dropdown.init(elems);
  });

function loadPowderblue() {
     document.getElementsByTagName('link')[1].disabled = true;
     document.getElementsByTagName('link')[2].disabled = false;
     document.getElementsByTagName('link')[3].disabled = false;
}

function loadCoral() {
    document.getElementsByTagName('link')[1].disabled = false;
    document.getElementsByTagName('link')[2].disabled = true;
    document.getElementsByTagName('link')[3].disabled = false;
}

function loadColorMint() {
     document.getElementsByTagName('link')[1].disabled = false;
     document.getElementsByTagName('link')[2].disabled = false;
     document.getElementsByTagName('link')[3].disabled = true;
}


//scrolspy

document.addEventListener('DOMContentLoaded', function() {
    var elems = document.querySelectorAll('.scrollspy');

    var instances = M.ScrollSpy.init(elems, {scrollOffset: 50});
  });
