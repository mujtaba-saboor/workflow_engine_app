$(document).ready(function(){
  $("#company_name_id").change(function(){
    var subdomain = $(this).val();
    subdomain = subdomain.replace(/\W/g, '');
    $("#domain_place").html("Your portal will be live at: https://" + subdomain + ".workengine.com");
    $("#subdomain_id").val(subdomain);
  });
});

$(document).ready(function(){
        $("#add_file_field_id").change(
            function(){
                if ($(this).val()) {
                    $("#add_file_field_button_id").attr('disabled',false);
                }
            }
            );
    });
