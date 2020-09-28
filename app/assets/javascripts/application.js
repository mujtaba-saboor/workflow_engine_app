$(document).on('turbolinks:load', function(){
  $("body").on("change", "#company_name_id", function(){
    var subdomain = $(this).val();
    subdomain = subdomain.replace(/\W/g, '');
    subdomain = subdomain.toLowerCase();
    $("#domain_place").html("Your portal will be live at: " + subdomain + ".lvh.me:3000");
    $("#subdomain_id").val(subdomain);
  });

  $("#add_file_field_id").change(function(){
        if ($(this).val()) {
            $("#add_file_field_button_id").attr('disabled',false);
        }
    }
    );
});

$('#my-link').click(function (event) {
  window.location.reload(true);
});

