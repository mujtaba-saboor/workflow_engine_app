function make_domain() {
  var x = document.getElementById("company_name_id").value;
  document.getElementById("domain_place").innerHTML = "Your portal will be live at: https://" + x + ".workengine.com";
  document.getElementById("domain_id").value = "https://" + x + ".workengine.com"
}
