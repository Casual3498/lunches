

function changedCurrency(sel){ 
  var currency_id = sel.options [sel.selectedIndex].value;
  var currency_name = sel.options [sel.selectedIndex].text;

  var elems_for_replace = document.getElementsByClassName('currency_name');
  for (var i = 0; i < elems_for_replace.length; i++) {

    elems_for_replace[i].innerHTML = "("+currency_name+")";
  }

  elems_for_replace = document.getElementsByClassName('currency_id');
  for (var i = 0; i < elems_for_replace.length; i++) {

    elems_for_replace[i].value = currency_id;
  }  

}


function disableCurrencySelect(){
  var elem = document.getElementById('currency');
  var menu_row = document.getElementsByClassName('menu_row');
  if (elem){
    if (menu_row.length) {
      elem.style.visibility = "hidden"; 
    }
    else {
      elem.style.visibility = "visible"; 
    }
  }
}


