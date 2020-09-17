$(document).ready(function(){
  $("#company_name_id").change(function(){
    var x = $("#company_name_id").val();
    x = x.replace(/\W/g, '');
    $("#domain_place").html("Your portal will be live at: https://" + x + ".workengine.com");
    $("#subdomain_id").val(x);
  });
});
