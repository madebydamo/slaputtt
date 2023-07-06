document.addEventListener("DOMContentLoaded", function () {
  var elems = document.querySelectorAll(".sidenav");
  var instances = M.Sidenav.init(elems, {});
});

document.addEventListener("DOMContentLoaded", function () {
  var elems = document.querySelectorAll(".dropdown-trigger");
  var instances = M.Dropdown.init(elems);
});

var colorThemes = ["powderblue", "coral", "mint"];

function loadColorTheme(id) {
  console.log("asdf" + colorThemes.length);
  for (var i = 0; i < colorThemes.length; i++) {
    if (id == colorThemes[i]) {
      $("#" + id).disabled = false;
      console.log("anebked" + id);
    } else {
      $("#" + id).disabled = true;
      console.log("disabled" + id);
    }
  }
}

//scrolspy

document.addEventListener("DOMContentLoaded", function () {
  var elems = document.querySelectorAll(".scrollspy");

  var instances = M.ScrollSpy.init(elems, { scrollOffset: 50 });
});

function showComparison(data) {
  var div = d3.select("#compareDiv");
  var margin = { top: 30, right: 30, bottom: 30, left: 30 };

  var width =
    div.node().getBoundingClientRect().width - margin.left - margin.right;
  var height = (width * 1) / 3 - margin.top - margin.bottom; // To maintain aspect ratio 3:4

  var svg = div
    .html("")
    .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  var x = d3
      .scaleBand()
      .range([0, width])
      .domain(d3.range(data[0].length))
      .padding(0.05),
    y = d3
      .scaleBand()
      .range([height, 0])
      .domain(d3.range(data.length))
      .padding(0.05);

  svg.append("g").call(d3.axisLeft(y));
  svg
    .append("g")
    .attr("transform", "translate(0," + height + ")")
    .call(d3.axisBottom(x));

  svg
    .selectAll("rect")
    .data(data.flat())
    .enter()
    .append("rect")
    .attr("x", function (d, i) {
      return x(i % data[0].length);
    })
    .attr("y", function (d, i) {
      return y(Math.floor(i / data[0].length));
    })
    .attr("width", x.bandwidth())
    .attr("height", y.bandwidth())
    .attr("fill", function (d) {
      return d === 1 ? "green" : d === 2 ? "red" : "white";
    })
    .attr("class", function (d) {
      return d === 1 ? "green" : d === 2 ? "red" : "";
    });
}
