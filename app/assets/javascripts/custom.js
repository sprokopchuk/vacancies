var ops = {
  country_id: "company_country",
  state_id:   "company_state",
  city_id:    "company_city"
}

$(document).on('ready page:load', function() {

  CountryStateSelect({
    chosen_ui: true,
    country_id: ops.country_id,
    state_id: ops.state_id,
    city_id: ops.city_id
  });


  $("#" + ops.state_id).on("change", function(data) {
    console.log("Data is send");
    return findCities($("#" + ops.state_id).val(),$("#" + ops.country_id).val());
  });



  function findCities(state_id, country_id) {

      //Remove all Chosen from existing fields
      removeChosenFromCityFields();

      //Perform AJAX request to get the data; on success, build the dropdown
      $.ajax({
        url: "/find_cities",
        type: 'post',

        dataType: 'json',
        cache: false,
        data: {
          country_id: country_id,
          state_id: state_id
        },
        success: function (data) { buildCitiesDropdown(data) }
      });
    }


  function removeChosenFromCityFields(){
      $("#" + ops.city_id + "_chosen").remove();
    }

  function buildCitiesDropdown(data) {
    ops.city_name = $('#' + ops.city_id).attr('name');
    ops.city_class = $('#' + ops.city_id).attr('class')
    console.log(data)
    if (data.length === 0) {
      html = '<input id="' + ops.city_id + '" name="' + ops.city_name + '" class="' + ops.city_class + '" type="text"  type="text" value="" >';
    } else {
      html = '<select id="' + ops.city_id + '" name="' + ops.city_name + '" class="' + ops.city_class + '" >';

      for (i = 0; i < data.length; i++) {
        html += '<option>' + data[i] + '</option>';
      }

      html += '</select>';
    }

    $('#' + ops.city_id).replaceWith(html);

    //This has to happen AFTER we've replaced the dropdown or text
    if (data.length > 0) {
      addChosenToCity();
    }

  }

 function addChosenToCity(){
    $('#' + ops.city_id).chosen();
  }
  // initialize persistent state

  $('#user_role').on('change', function(){
    var role = $(this).val();
    var speciality = $('#user_speciality');
    var invite_code = $("#user_invite_code");
    if(role == "applicant"){
      invite_code.hide();
      speciality.show();
    }else if(role == "manager"){
      speciality.hide();
      invite_code.show();
    }else{
      speciality.hide();
      invite_code.hide();
    }
  });
});


