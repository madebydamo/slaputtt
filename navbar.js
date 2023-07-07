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
  console.log("WE GOT CALLED");
  var div = d3.select("#compareDiv");

  // Empty the div
  div.html("");

  var margin = { top: 50, right: 30, bottom: 30, left: 30 };

  var divWidth = div.node().getBoundingClientRect().width;
  var width = divWidth - margin.left - margin.right;
  var squareSize = Math.min(width / data[0].length, width / data.length);
  var heatmapWidth = squareSize * data[0].length;
  var heatmapHeight = squareSize * data.length;

  var svg = div
    .append("svg")
    .attr("width", divWidth)
    .attr("height", heatmapHeight + margin.top + margin.bottom)
    .append("g")
    .attr(
      "transform",
      "translate(" + (divWidth - heatmapWidth) / 2 + "," + margin.top + ")"
    );

  var x = d3
      .scaleBand()
      .range([0, heatmapWidth])
      .domain(d3.range(data[0].length))
      .padding(0.05),
    y = d3
      .scaleBand()
      .range([heatmapHeight, 0])
      .domain(d3.range(data.length))
      .padding(0.05);

  // Axis
  svg
    .append("g")
    .attr("class", "y axis")
    .call(d3.axisLeft(y).ticks(0).tickSize(0))
    .call((g) => g.select(".domain").remove())
    .append("text")
    .attr("y", -15)
    .attr("x", -heatmapHeight / 2)
    .attr("dy", "1em")
    .style("text-anchor", "middle")
    .text("Current")
    .attr("font-size", "15px");

  svg
    .append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + heatmapHeight + ")")
    .call(d3.axisBottom(x).ticks(0).tickSize(0))
    .call((g) => g.select(".domain").remove())
    .append("text")
    .attr("y", 30)
    .attr("x", heatmapWidth / 2)
    .attr("dy", "1em")
    .style("text-anchor", "middle")
    .text("Imported")
    .attr("font-size", "15px");

  var rects = svg.selectAll("rect").data(data.flat());

  // Remove old elements not present in new data
  rects.exit().transition().duration(1000).style("opacity", 0).remove();

  // Update existing elements
  rects
    .attr("fill", function (d) {
      return d === 1 ? "green" : d === 2 ? "red" : "white";
    })
    .attr("class", function (d) {
      return d === 1 ? "green" : d === 2 ? "red" : "";
    });

  // Create new elements as needed
  rects
    .enter()
    .append("rect")
    .attr("x", function (d, i) {
      return x(i % data[0].length);
    })
    .attr("y", function (d, i) {
      return y(Math.floor(i / data[0].length));
    })
    .attr("width", squareSize)
    .attr("height", squareSize)
    .attr("fill", function (d) {
      return d === 1 ? "green" : d === 2 ? "red" : "white";
    })
    .attr("class", function (d) {
      return d === 1 ? "green" : d === 2 ? "red" : "";
    });
}
