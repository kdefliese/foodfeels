// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require jquery-ui/autocomplete
//= require jquery-ui/menu

// these will track of what food/meal/ing ids we have in our entry w/o displaying ids on the page
var mealVals = [];
var foodVals = [];
var ingredientVals = [];

$(document).on('ready', function() {

  // updates foods/meals/ingredients dropdown based on first dropdown selection
  $("#food-type-select").change(function() {
    $("#food-type-select option:selected").each(function() {
      var select_val = $("#food-type-select option:selected").val();
      var url = "";
      if (select_val === "Meals") {
        url = "/meals/all";
        button_word = "meal";
      }
      else if (select_val === "Foods") {
        url = "/foods/all";
        button_word = "food";
      }
      else if (select_val === "Ingredients") {
        url = "/ingredients/all";
        button_word = "ingredient";
      }
      $.ajax(url)
      .done(function(data) {
        console.log("success");
        var replace_html = "<select id=\"dynamic-food-list\">";
        for (var i = 0; i < data.length; i++) {
          replace_html += "<option value=\"" + data[i].name + "\" id=\"" + data[i].id + "\">" + data[i].name + "</option>";
        }
        replace_html += "</select>";
        $("#dynamic-food-list").replaceWith(
          replace_html
        );
        $("#add-to-entry").val(
          "Add " + button_word + " to entry"
        );
      })
      .fail(function() {
        console.log("failure");
      });
    });
  });

  // adds things to the food entry on the page
  $("#add-new-entry").click(function() {
    event.preventDefault();
    var type = $("#food-type-select option:selected").val();
    var name = $("#dynamic-food-list").val();
    $("#print-new-entry").append(
      "<p>" + type + ": " + name + "</p>"
    );
    if (type === "Meals") {
      mealVals.push($("#dynamic-food-list option:selected")[0].id);
      $("#print-new-entry").data(type, mealVals);
    }
    else if (type === "Foods") {
      foodVals.push($("#dynamic-food-list option:selected")[0].id);
      $("#print-new-entry").data(type, foodVals);
    }
    else if (type === "Ingredients") {
      ingredientVals.push($("#dynamic-food-list option:selected")[0].id);
      $("#print-new-entry").data(type, ingredientVals);
    }
  });

  // submits food entry and will update it in the db
  $("#create-food-entry").click(function() {
    $.ajax({
      method: "POST",
      url: "/entries",
      data: {notes: $("#notes").val(), time: $("#time").val(), user_id: $("#user-id").val(), day_id: $("#day-id").val(), category: $("#category-select").val(), meal_ids: $("#print-new-entry").data("Meals"), food_ids: $("#print-new-entry").data("Foods"), ingredient_ids: $("#print-new-entry").data("Ingredients") }
    })
    .done(function() {
      console.log("post entry success");
        // make another call to get the most recent entry and add it to the page
        $.ajax("/entries/last")
          .done(function(data) {
            console.log("last entry success");
            var meals = "";
            var foods = "";
            var ingredients = "";
            for (var i = 0; i < data.meals.length; i++) {
                meals += "<div class=\"meal\">" + data.meals[i].name + "</div>";
            }
            for (var j = 0; j < data.foods.length; j++) {
                foods += "<div class=\"food\">" + data.foods[j].name + "</div>";
            }
            for (var k = 0; k < data.ingredients.length; k++) {
                ingredients += "<div class=\"ingredient\">" + data.ingredients[k].name + "</div>";
            }
            $("#added-entries").append(
              "<div class=\"entry\" id=\"" + data.entry_time + "\">" + data.entry.category + "<br />" + data.entry_time + "<br />" + data.entry.notes + "<br />" + meals + "<br />" + foods + "<br />" + ingredients + "<br />" + "</div>"
            );
          })
          .fail(function() {
            console.log("last entry failure");
          });
        })
    .fail(function() {
      console.log("post entry failure");
    });
  });

  // edit entry link is clicked
  $(".edit-entry").click(function() {
    event.preventDefault();
    event.stopPropagation();
    console.log("click");
  });

  // autocomplete for search
  var cache = {};
  $("#autocomplete").autocomplete({
    minLength: 2,
    source: function(request, response) {
      var term = request.term;
      $.getJSON("/foods/search", request, function(data) {
        response(data);
        console.log(data);
      });
    },
    select: function( event, ui ) {
      $("#autocomplete").val(ui.item.label);
      $("#factual-id").val(ui.item.value);
      console.log("a value was selected");
      return false;
    }
  });

  // adds food from search to db and to entry
  $("#add-from-search").click(function() {
    var food_name = $("#autocomplete").val();
    var url = "/foods/search_specific?search_term=" + food_name;
    $.ajax(url)
      .done(function(data) {
        console.log("success");
        console.log(data);
      })
      .fail(function() {
        console.log("failure");
      });
    });



});
