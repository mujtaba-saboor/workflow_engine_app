function make_subdomain() {
  var x = document.getElementById("company_name_id").value;
  x = x.replace(/\W/g, '');
  document.getElementById("domain_place").innerHTML = "Your portal will be live at: https://" + x + ".workengine.com";
  document.getElementById("subdomain_id").value = x;
}
